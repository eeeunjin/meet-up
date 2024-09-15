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
    }, { merge: true });

    console.log("일정 추가 가능 채팅이 추가되었습니다.");
  }

  // 4명의 인원이 일정을 모두 확정한 경우
  // 1. 채팅방에 스케줄 확정 알림을 위한 채팅 문서를 추가
  // 2. roomModel의 isScheduleDecided 값을 true로 변경
  const isScheduleExist = (before.room_schedule != null);
  if (isScheduleExist) {
    const beforeSchedule = before.room_schedule;
    const beforeAgree = beforeSchedule.participants_agree_selected_schedule;
    const afterSchedule = after.room_schedule;
    const afterAgree = afterSchedule.participants_agree_selected_schedule;

    const isAllScheduleDecided = (beforeAgree.length === 3 &&
       afterAgree.length == 4);
    if (isAllScheduleDecided) {
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
        "type": "schedule_decide",
      });

      await roomRef.set({
        "recentMessage": "일정이 확정되었습니다 !",
      }, { merge: true });

      console.log("일정 확정 채팅이 추가되었습니다.");

      await roomRef.update({
        "isScheduleDecided": true,
      });
      console.log("RoomModel의 isScheduleDecided 값이 true로 변경되었습니다.");
    }
  }
});
