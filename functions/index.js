const {onDocumentUpdated} = require("firebase-functions/v2/firestore");

const {initializeApp} = require("firebase-admin/app");

const {
  getFirestore,
  Timestamp,
} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.sendChatRoomScheduleDecisionNotice =
onDocumentUpdated("rooms/{roomId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  console.log("before: ", before.room_participant_reference.length);
  console.log("after: ", after.room_participant_reference.length);
  if (before.room_participant_reference.length === 2 &&
    after.room_participant_reference.length === 3) {
    const chatRoomId = event.params.roomId;
    console.log("chatRoomId: ", chatRoomId);
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
    console.log("새로운 채팅 문서가 추가되었습니다.");
  }
});
