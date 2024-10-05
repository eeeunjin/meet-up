const {onDocumentUpdated} = require("firebase-functions/v2/firestore");

const {initializeApp} = require("firebase-admin/app");

const {
  getFirestore,
  Timestamp,
} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.sendScheduleMessage =
onDocumentUpdated("rooms/{roomId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  console.log("before: ", before.room_participant_reference.length);
  console.log("after: ", after.room_participant_reference.length);

  // 채팅방 참여자가 2명에서 3명으로 변경되었을 때 (방장 포함 4명이 한 방에 들어온 경우)
  // 채팅방에 스케줄 확정 알림을 위한 채팅 문서를 추가합니다.
  if (before.room_participant_reference.length === 2 &&
    after.room_participant_reference.length === 3) {
    const chatRoomId = event.params.roomId;
    const chatRoomRef = db.collection("chatRooms").doc(chatRoomId);
    const chatRef = chatRoomRef.collection("chats");
    const roomRef = db.collection("rooms").doc(chatRoomId);

    await chatRef.add({
      "uid": "",
      "nickName": "",
      "Content": "",
      "date": Timestamp.now(),
      "room_reference": chatRoomId,
      "type": "schedule_write",
    });

    // room 정보 중, recent message 값을 업데이트
    await roomRef.set({
      "recentMessage": "일정 등록이 가능합니다 !",
    });

    console.log("일정 추가 가능 채팅이 추가되었습니다.");
  }

  // 4명의 인원이 일정을 모두 확정한 경우
  // 1. 채팅방에 스케줄 확정 알림을 위한 채팅 문서를 추가
  // 2. roomModel의 isScheduleDecided 값을 true로 변경
  const beforeScheduleExist = (before.room_schedule != null);
  if (beforeScheduleExist) {
    const afterScheduleExist = (after.room_schedule != null);
    if (!afterScheduleExist) {
      // TODO: 일정이 삭제된 경우에 대한 경우 처리
      // roomModel의 isScheduleDecided 값을 false로 변경
      // room 정보 중, recent message 값을 업데이트
      // 해당 채팅방의 스케줄 관련 채팅 문서를 삭제
      // 해당 채팅방의 3,2,1일전 알림 채팅 문서를 삭제
      // 해당 채팅방의 상호평가 알림 채팅 문서를 삭제
      // 해당 채팅방의 일기쓰기 알림 채팅 문서를 삭제
      // 유저들의 schedule document 삭제

      return;
    }

    const beforeSchedule = before.room_schedule;
    const beforeAgree = beforeSchedule.participants_agree_selected_schedule;
    const afterSchedule = after.room_schedule;
    const afterAgree = afterSchedule.participants_agree_selected_schedule;

    const isAllScheduleDecided = (beforeAgree.length === 3 &&
       afterAgree.length == 4);

    // 4명의 인원이 모두 일정을 확정한 경우
    if (isAllScheduleDecided) {
      const chatRoomId = event.params.roomId;
      const chatRoomRef = db.collection("chatRooms").doc(chatRoomId);
      const chatRef = chatRoomRef.collection("chats");
      const roomRef = db.collection("rooms").doc(chatRoomId);

      // 일정 확정 알림 문구 추가
      await chatRef.add({
        "uid": "",
        "nickName": "",
        "Content": "",
        "date": Timestamp.now(),
        "room_reference": chatRoomId,
        "type": "schedule_decide",
      });

      // 해당 채팅 방의 최근 메세지 업데이트
      await roomRef.update({
        "recentMessage": "일정이 확정되었습니다 !",
      });

      // roomModel의 isScheduleDecided 값을 true로 변경 -> 일정을 삭제할 수 없도록 하기 위한 변수
      await roomRef.update({
        "isScheduleDecided": true,
      });

      // 3일 전 자정
      var threeDaysBefore = afterSchedule.date.toDate();
      threeDaysBefore.setDate(threeDaysBefore.getDate() - 3);
      threeDaysBefore.setHours(0, 0, 0, 0);
      // 2일 전 날짜
      var twoDaysBefore = afterSchedule.date.toDate();
      twoDaysBefore.setDate(twoDaysBefore.getDate() - 2);
      twoDaysBefore.setHours(0, 0, 0, 0);
      // 1일 전 날짜
      var oneDayBefore = afterSchedule.date.toDate();
      oneDayBefore.setDate(oneDayBefore.getDate() - 1);
      oneDayBefore.setHours(0, 0, 0, 0);

      // 설정된 만남 일자 기준 3일전 2일전 1일전이 현재 시간보다 이후인 경우 document에 추가
      if (threeDaysBefore > Timestamp.now().toDate()) {
        await chatRef.add({
          "uid": "",
          "nickName": "",
          "Content": "three",
          "date": Timestamp.fromDate(threeDaysBefore),
          "room_reference": chatRoomId,
          "type": "schedule_alarm",
        });
      } 
      if (twoDaysBefore > Timestamp.now().toDate()) {
        await chatRef.add({
          "uid": "",
          "nickName": "",
          "Content": "two",
          "date": Timestamp.fromDate(twoDaysBefore),
          "room_reference": chatRoomId,
          "type": "schedule_alarm",
        });
      }
      if (oneDayBefore > Timestamp.now().toDate()) {
        await chatRef.add({
          "uid": "",
          "nickName": "",
          "Content": "one",
          "date": Timestamp.fromDate(oneDayBefore),
          "room_reference": chatRoomId,
          "type": "schedule_alarm",
        });
      }

      // 상호 평가 & 일기 알림 일자 계산 (만남 일자 시간 2시간 이후)
      var afterTwoHours = afterSchedule.date.toDate();
      afterTwoHours.setHours(afterTwoHours.getHours() + 2);

      // 상호 평가 알림 추가
      await chatRef.add({
        "uid": "",
        "nickName": "",
        "Content": "",
        "date": Timestamp.fromDate(afterTwoHours),
        "room_reference": chatRoomId,
        "type": "review",
      });

      // 일기 쓰기 알림 추가
      await chatRef.add({
        "uid": "",
        "nickName": "",
        "Content": "",
        "date": Timestamp.fromDate(afterTwoHours),
        "room_reference": chatRoomId,
        "type": "diary",
      });

      // 각자 인원들에게 일정 관련 알림 추가
      var userUIDs = afterSchedule.participants_agree_selected_schedule;
      for (uid of userUIDs) {
        var userRef = db.collection("users").doc(uid);
        var title = afterSchedule.title;
        var date = afterSchedule.date.toDate();
        var docID = title + date.toString();

        var myScheduleRef = userRef.collection("mySchedule").doc(docID);
        // myScheduleRef에 after data를 document로 추가 (RoomModel 자체를 Schedule 정보로 사용)
        await myScheduleRef.set(after);
      }
    }
  }
});
