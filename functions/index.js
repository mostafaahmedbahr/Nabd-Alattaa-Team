const {setGlobalOptions} = require("firebase-functions/v2");
const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({
  maxInstances: 10,
});

exports.sendNotificationToAll = onCall(async (request) => {
  try {
    const {title, body} = request.data;

    await admin.messaging().send({
      topic: "all_users",
      notification: {
        title: title,
        body: body,
      },
    });

    return {
      success: true,
      message: "Notification sent successfully",
    };
  } catch (e) {
    console.error(e);

    return {
      success: false,
      message: e.message,
    };
  }
});
