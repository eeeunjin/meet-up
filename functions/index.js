const { onDocumentUpdated } = require("firebase-functions/v2/firestore");

const { initializeApp } = require("firebase-admin/app");

const {
  getFirestore,
  Timestamp,
} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

// MARK: - sendScheduleMessage
exports.sendScheduleMessage = onDocumentUpdated("rooms/{roomId}", async (event) => {
  const roomId = event.params.roomId;
  const before = event.data.before.data();
  const after = event.data.after.data();

  if (before.room_participant_reference.length === 2 && after.room_participant_reference.length === 3) {
    await handleParticipantChange(roomId);
  }

  const beforeScheduleExist = (before.room_schedule != null);
  if (beforeScheduleExist) {
    const afterScheduleExist = (after.room_schedule != null);
    if (!afterScheduleExist) {
      await handleScheduleDeleted(roomId);
      return;
    }

    const beforeSchedule = before.room_schedule;
    const beforeAgree = beforeSchedule.participants_agree_selected_schedule;
    const afterSchedule = after.room_schedule;
    const afterAgree = afterSchedule.participants_agree_selected_schedule;

    const isAllScheduleDecided = (beforeAgree.length === 3 && afterAgree.length == 4);
    if (isAllScheduleDecided) {
      await handleScheduleDecided(roomId, afterSchedule, after);
    }
  }
});

// MARK: - handleParticipantChange
// 일정 등록 가능 채팅 추가
async function handleParticipantChange(roomId) {
  const chatRoomRef = db.collection("chatRooms").doc(roomId);
  const chatRef = chatRoomRef.collection("chats");
  const roomRef = db.collection("rooms").doc(roomId);

  await chatRef.add({
    "uid": "",
    "nickname": "",
    "profile_icon": "",
    "content": "",
    "date": Timestamp.now(),
    "room_reference": roomId,
    "type": "schedule_write",
  });

  await roomRef.update({
    "recentMessage": "일정 등록이 가능합니다 !",
  });

  console.log("일정 추가 가능 채팅이 추가되었습니다.");
}

// MARK: - handleScheduleDecided
// 일정 확정 시, review, diary, schedule_end 채팅 추가
async function handleScheduleDecided(roomId, afterSchedule, after) {
  const chatRoomRef = db.collection("chatRooms").doc(roomId);
  const chatRef = chatRoomRef.collection("chats");
  const roomRef = db.collection("rooms").doc(roomId);

  await chatRef.add({
    "uid": "",
    "nickname": "",
    "profile_icon": "",
    "content": "",
    "date": Timestamp.now(),
    "room_reference": roomId,
    "type": "schedule_decide",
  });

  await roomRef.update({
    "recentMessage": "일정이 확정되었습니다 !",
  });

  await roomRef.update({
    "isScheduleDecided": true,
  });

  var threeDaysBefore = afterSchedule.date.toDate();
  threeDaysBefore.setDate(threeDaysBefore.getDate() - 3);
  threeDaysBefore.setHours(0, 0, 0, 0);

  var twoDaysBefore = afterSchedule.date.toDate();
  twoDaysBefore.setDate(twoDaysBefore.getDate() - 2);
  twoDaysBefore.setHours(0, 0, 0, 0);

  var oneDayBefore = afterSchedule.date.toDate();
  oneDayBefore.setDate(oneDayBefore.getDate() - 1);
  oneDayBefore.setHours(0, 0, 0, 0);

  if (threeDaysBefore > Timestamp.now().toDate()) {
    await chatRef.add({
      "uid": "",
      "nickname": "",
      "profile_icon": "",
      "content": "three",
      "date": Timestamp.fromDate(threeDaysBefore),
      "room_reference": roomId,
      "type": "schedule_alarm",
    });
  }
  if (twoDaysBefore > Timestamp.now().toDate()) {
    await chatRef.add({
      "uid": "",
      "nickname": "",
      "profile_icon": "",
      "content": "two",
      "date": Timestamp.fromDate(twoDaysBefore),
      "room_reference": roomId,
      "type": "schedule_alarm",
    });
  }
  if (oneDayBefore > Timestamp.now().toDate()) {
    await chatRef.add({
      "uid": "",
      "nickname": "",
      "profile_icon": "",
      "content": "one",
      "date": Timestamp.fromDate(oneDayBefore),
      "room_reference": roomId,
      "type": "schedule_alarm",
    });
  }

  var afterFourHours = afterSchedule.date.toDate();
  afterFourHours.setSeconds(afterFourHours.getSeconds() + 1);

  await chatRef.doc("review").set({
    "uid": "",
    "nickname": "",
    "profile_icon": "",
    "content": "",
    "date": Timestamp.fromDate(afterFourHours),
    "room_reference": roomId,
    "type": "review",
  });

  afterFourHours.setSeconds(afterFourHours.getSeconds() + 1);
  await chatRef.doc("diary").set({
    "uid": "",
    "nickname": "",
    "profile_icon": "",
    "content": "",
    "date": Timestamp.fromDate(afterFourHours),
    "room_reference": roomId,
    "type": "diary",
  });

  afterFourHours.setSeconds(afterFourHours.getSeconds() + 1);
  await chatRef.doc("schedule_end").set({
    "uid": "",
    "nickname": "",
    "profile_icon": "",
    "content": "",
    "date": Timestamp.fromDate(afterFourHours),
    "room_reference": roomId,
    "type": "schedule_end",
  });

  var userUIDs = afterSchedule.participants_agree_selected_schedule;
  for (uid of userUIDs) {
    var userRef = db.collection("users").doc(uid);
    var myScheduleRef = userRef.collection("mySchedule").doc(roomId);

    var roomScheduleData = after;
    roomScheduleData["room_name"] = myScheduleRef.id;

    await myScheduleRef.set(roomScheduleData);
  }
}
