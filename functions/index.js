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

    await chatRef.add({
      "uid": "",
      "nickName": "",
      "Content": "",
      "date": Timestamp.now(),
      "room_reference": "",
      "type": "schedule_write",
    });
    console.log("일정 추가 가능 채팅이 추가되었습니다.");
  }

  // 4명의 인원이 일정을 모두 확정한 경우
  // 채팅방에 스케줄 확정 알림을 위한 채팅 문서를 추가합니다.
  const isScheduleExist = (before.room_schedule != null);
  if (isScheduleExist) {
    const isAllScheduleDecided = (before.room_schedule[participants_agree_selected_schedule].length === 3 && after.room_schedule[participants_agree_selected_schedule].length == 4);
    if (isAllScheduleDecided) {
      const chatRoomId = event.params.roomId;
      const chatRoomRef = db.collection("chatRooms").doc(chatRoomId);
      const chatRef = chatRoomRef.collection("chats");

      await chatRef.add({
        "uid": "",
        "nickName": "",
        "Content": "",
        "date": Timestamp.now(),
        "room_reference": "",
        "type": "schedule_decide",
      });
      console.log("일정 확정 채팅이 추가되었습니다.");
    }
  }
});
