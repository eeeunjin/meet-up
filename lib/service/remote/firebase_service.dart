import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';

///
/// Firebase Instance를 모아놓은 클래스
///
class FirebaseInstance {
  static FirebaseFirestore db = FirebaseFirestore.instance;
}

///
/// Firebase Reference를 모아놓은 클래스
///
class FirebaseRefs {
  // user collection
  CollectionReference colRefUser = FirebaseInstance.db.collection("users");
  CollectionReference colRefRoom = FirebaseInstance.db.collection("rooms");
  CollectionReference colRefGoodHistory =
      FirebaseInstance.db.collection("goodHistories");
}

///
/// Firebase CRUD 함수들을 모아놓은 클래스
///
class FirebaseCRUD {
  /// 콜렉션 정보를 읽어오는 함수
  Future<List<T>> readCollection<T>({
    int? limit,
    FilterInfo? filterInfo,
    required CollectionReference colRef,
  }) async {
    try {
      // Get 메서드를 이용해서 Collection 하위의 documents 들의 Snapshot 가져오기
      QuerySnapshot querySnapshot;
      if (limit == null) {
        if (T == RoomModel) {
          if (filterInfo == null) {
            querySnapshot = await colRef.get();
          } else {
            // 최신 순으로 정렬해서 가져오기
            querySnapshot = await createFilterQuery(
              filterInfo: filterInfo,
              colRef: colRef,
            ).get();
          }
        } else if (T == GoodHistoryModel) {
          if (filterInfo == null) {
            logger.e("[GoodHistoryModel Read] 필터 정보가 필요합니다");
            return List.empty();
          }
          querySnapshot = await createFilterQuery(
            filterInfo: filterInfo,
            colRef: colRef,
          ).orderBy("gh_change_date", descending: true).get();
        } else {
          querySnapshot = await colRef.get();
        }
      } else {
        if (T == RoomModel) {
          if (filterInfo == null) {
            querySnapshot = await colRef.limit(limit).get();
          } else {
            // 최신 순으로 정렬해서 가져오기
            querySnapshot = await createFilterQuery(
              colRef: colRef,
              filterInfo: filterInfo,
            ).limit(limit).get();
          }
        } else if (T == GoodHistoryModel) {
          if (filterInfo == null) {
            logger.e("[GoodHistoryModel Read] 필터 정보가 필요합니다");
            return List.empty();
          }
          querySnapshot = await createFilterQuery(
            filterInfo: filterInfo,
            colRef: colRef,
          ).limit(limit).orderBy("gh_change_date", descending: true).get();
        } else {
          querySnapshot = await colRef.limit(limit).get();
        }
      }

      // 불러온 documents 들의 정보를 list로 매핑해서 반환하기
      return querySnapshot.docs.map((doc) {
        if (T == UserModel) {
          return UserModel.fromJson(doc.data() as Map<String, Object?>) as T;
        } else if (T == MyRoomModel) {
          return MyRoomModel.fromJson(doc.data() as Map<String, Object?>) as T;
        } else if (T == RoomModel) {
          return RoomModel.fromJson(doc.data() as Map<String, Object?>) as T;
        } else if (T == GoodHistoryModel) {
          return GoodHistoryModel.fromJson(doc.data() as Map<String, Object?>)
              as T;
        } else {
          // 지정하지 않은 형식의 모델 값이 들어오면 에러를 반환
          throw Exception("Unsupported document type.");
        }
      }).toList();
    } catch (err) {
      // Documents Snapshot을 가져오는 도중 에러가 발생하면 에러 코드를 출력하고 빈 리스트 반환
      debugPrint("Error reading collection: $err");
      return [];
    }
  }

  /// 콜렉션의 stream snapshots을 불러오는 함수
  Stream<QuerySnapshot<Object?>> readCollectionStream<T>({
    int? limit,
    FilterInfo? filterInfo,
    String? myUID,
    required CollectionReference colRef,
  }) {
    // 콜렉션 스냅샷 스트림 정보를 반환
    // 실시간으로 스트림 정보를 Read 할 수 있음
    final firebaseRefs = FirebaseRefs();
    if (limit == null) {
      if (T == RoomModel) {
        if (filterInfo == null) {
          return colRef
              .where("room_owner_reference",
                  isNotEqualTo: firebaseRefs.colRefUser.doc(myUID!))
              .orderBy("room_owner_reference")
              .snapshots();
        } else {
          return createFilterQuery(
            filterInfo: filterInfo,
            colRef: colRef,
          )
              .where("room_owner_reference",
                  isNotEqualTo: firebaseRefs.colRefUser.doc(myUID!))
              .orderBy("room_owner_reference")
              .snapshots();
        }
      } else {
        return colRef.snapshots();
      }
    } else {
      if (T == RoomModel) {
        if (filterInfo == null) {
          return colRef
              .where("room_owner_reference",
                  isNotEqualTo: firebaseRefs.colRefUser.doc(myUID!))
              .orderBy("room_owner_reference")
              .limit(limit)
              .snapshots();
        } else {
          return createFilterQuery(
            colRef: colRef,
            filterInfo: filterInfo,
          )
              .where("room_owner_reference",
                  isNotEqualTo: firebaseRefs.colRefUser.doc(myUID!))
              .orderBy("room_owner_reference")
              .limit(limit)
              .snapshots();
        }
      } else {
        return colRef.limit(limit).snapshots();
      }
    }
  }

  /// 쿼리로 stream snapshots을 불러오는 함수
  Stream<QuerySnapshot<Object?>> readCollectionStreamByQuery<T>(
      {required String uid}) {
    final firebaseRefs = FirebaseRefs();

    if (T == MyRoomModel) {
      return firebaseRefs.colRefRoom
          .where('room_owner_reference',
              isEqualTo: firebaseRefs.colRefUser.doc(uid))
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  /// 콜렉션 정보를 삭제하는 함수 (하위에 더이상 collection이 존재하면 안됨)
  Future<bool> deleteCollection({required CollectionReference colRef}) async {
    try {
      QuerySnapshot querySnapshot = await colRef.get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (err) {
      logger.d("지울 collection이 없습니다: $err");
      return false;
    }
  }

  // Room Model의 필터 정보에 맞게 쿼리를 반환해주는 함수
  Query<Object?> createFilterQuery({
    required FilterInfo filterInfo,
    required CollectionReference colRef,
  }) {
    Query<Object?> filteredQuery = colRef;
    // MARK: - RoomModel 필터 정보
    // 메인 카테고리 같아야 함
    if (filterInfo.room_category != null) {
      filteredQuery = filteredQuery.where("room_category",
          isEqualTo: filterInfo.room_category);
    }
    // 세부 카테고리 같아야 함
    if (filterInfo.room_category_detail != null) {
      filteredQuery = filteredQuery.where("room_category_detail",
          isEqualTo: filterInfo.room_category_detail);
    }
    // 테스트 필요
    if (filterInfo.room_age != null) {
      filteredQuery =
          filteredQuery.where("room_age", arrayContains: filterInfo.room_age);
    }
    // 성별 비율 같아야 함
    if (filterInfo.room_gender_ratio != null) {
      filteredQuery = filteredQuery.where("room_gender_ratio",
          isEqualTo: filterInfo.room_gender_ratio);
    }
    // 시/도 같아야 함
    if (filterInfo.room_region_district != null) {
      filteredQuery = filteredQuery.where("room_region_district",
          isEqualTo: filterInfo.room_region_district);
    }
    // 시/군/구 같아야 함
    if (filterInfo.room_region_province != null) {
      filteredQuery = filteredQuery.where("room_region_province",
          isEqualTo: filterInfo.room_region_province);
    }
    // 규칙 완전히 같아야 함
    if (filterInfo.room_rules != null) {
      filteredQuery =
          filteredQuery.where("room_rules", isEqualTo: filterInfo.room_rules);
    }

    // MARK: - GoodHistoryModel 필터 정보
    // uid 가 같아야 함
    if (filterInfo.uid != null) {
      filteredQuery = filteredQuery.where("gh_uid", isEqualTo: filterInfo.uid);
    }
    // type이 같아야 함
    if (filterInfo.type != null) {
      filteredQuery =
          filteredQuery.where("gh_type", isEqualTo: filterInfo.type);
    }

    return filteredQuery;
  }

  /// 도큐먼트 정보를 생성하는 함수
  Future<bool> createDocument<T>({
    required DocumentReference docRef,
    required T data,
  }) async {
    try {
      // data가 존재하는 경우
      if (data != null) {
        if (T == UserModel) {
          UserModel user = data as UserModel;
          await docRef.set(user.toJson());
          return true;
        } else if (T == MyRoomModel) {
          MyRoomModel myRoom = data as MyRoomModel;
          await docRef.set(myRoom.toJson());
          return true;
        } else if (T == RoomModel) {
          RoomModel myEnterRequest = data as RoomModel;
          await docRef.set(myEnterRequest.toJson());
          return true;
        } else if (T == GoodHistoryModel) {
          GoodHistoryModel goodHistory = data as GoodHistoryModel;
          await docRef.set(goodHistory.toJson());
          return true;
        } else {
          // 지정하지 않은 모델인 경우 에러 반환
          throw Exception("Unsupported document type.");
        }
      } else {
        // data가 null인 경우
        throw Exception("Data isn't exist");
      }
    } catch (err) {
      // 생성 작업 실패 시 에러 메시지와 함께 예외를 던지지 않고 false 반환
      debugPrint("Error creating document: $err");
      return false;
    }
  }

  /// 도큐먼트 정보를 읽어오는 함수
  Future<T> readDocument<T>({required DocumentReference docRef}) async {
    try {
      // get 메서드를 이용하여 docRef의 snapshot 정보를 가져오기
      DocumentSnapshot snapshot = await docRef.get();

      // snapshot의 정보를 json 형태로 불러오기
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      // 데이터가 존재하는 경우
      if (data != null) {
        if (T == UserModel) {
          return UserModel.fromJson(data) as T;
        } else if (T == MyRoomModel) {
          return MyRoomModel.fromJson(data) as T;
        } else if (T == RoomModel) {
          return RoomModel.fromJson(data) as T;
        } else {
          // 지정한 모델이 아닌 경우 에러 코드 반환
          throw Exception("Unsupported document type.");
        }
      } else {
        // 데이터가 존재하지 않는 경우
        throw Exception("Document data is null.");
      }
    } catch (e) {
      // 에러 반환
      throw Exception("Error reading document: $e");
    }
  }

  /// 도큐먼트 정보를 업데이트하는 함수
  Future<bool> updateDocument({
    required DocumentReference docRef,
    required Map<String, dynamic> data,
  }) async {
    try {
      // data<json 정보>를 update() 메서드에 전달
      await docRef.update(data);
      return true;
    } catch (err) {
      // 업데이트 작업 실패 시 에러 메시지 출력 및 실패 반환
      throw Exception("Error updating document: $err");
    }
  }

  /// 도큐먼트 정보를 지우는 함수
  Future<bool> deleteDocument({required DocumentReference docRef}) async {
    try {
      // docRef에 해당하는 레퍼런스 삭제 요청
      await docRef.delete();
      return true;
    } catch (err) {
      // 삭제 작업 실패 시 에러 메시지와 함께 false를 반환
      debugPrint("Error deleting document: $err");
      return false;
    }
  }

  /// 필드에 해당하는 도큐먼트 정보를 지우는 함수
  Future<bool> deleteDocumentByField({
    required CollectionReference colRef,
    required String fieldName,
    required DocumentReference fieldValue,
  }) async {
    try {
      QuerySnapshot querySnapshot =
          await colRef.where(fieldName, isEqualTo: fieldValue).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        logger.d("Deleted by userDelete (docs name: ${doc.reference.id})");
        await doc.reference.delete();
      }
      return true;
    } catch (err) {
      logger.d("Error deleting document by field: $err");
      return false;
    }
  }
}

///
/// Firebase Auth 관련 함수들을 모아놓은 클래스
///
class FirebaseAUTH {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 전화번호 인증을 위한 메서드
  Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 해당 전화 번호와 smsCode를 확인하여 만들어진 credential을 전송하여 로그인 및 회원 가입하는 메서드
  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  /// 탈퇴하는 메서드
  Future<bool> deleteUser() async {
    try {
      logger.d("Deleting user...");
      logger.d("Current user: ${_auth.currentUser}");
      await _auth.currentUser!.delete();
      return true;
    } catch (e) {
      logger.d("Error deleting user: $e");
      return false;
    }
  }
}
