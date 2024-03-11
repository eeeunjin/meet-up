import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
}

///
/// Firebase CRUD 함수들을 모아놓은 클래스
///
class FirebaseCRUD {
  /// 콜렉션 정보를 읽어오는 함수
  Future<List<T>> readCollection<T>(
      {required CollectionReference colRef}) async {
    try {
      // Get 메서드를 이용해서 Collection 하위의 documents 들의 Snapshot 가져오기
      QuerySnapshot querySnapshot = await colRef.get();

      // 불러온 documents 들의 정보를 list로 매핑해서 반환하기
      return querySnapshot.docs.map((doc) {
        if (T == UserModel) {
          return UserModel.fromJson(doc.data() as Map<String, Object?>) as T;
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
  Stream<QuerySnapshot<Object?>> readCollectionStream(
      {required CollectionReference colRef}) {
    // 콜렉션 스냅샷 스트림 정보를 반환
    // 실시간으로 스트림 정보를 Read 할 수 있음
    return colRef.snapshots();
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
        }
        // 다른 모델에 대한 처리 추가
        // else if (T == OtherModel) {
        //   return OtherModel.fromJson(data) as T;
        // }
        else {
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
}
