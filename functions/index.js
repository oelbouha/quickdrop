/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNewMessageNotification = functions.firestore
    .document("messages/{messageId}")
    .onCreate(async (snap , context) => {
        const dmessageDta = snap.data();

        const senderId = messageData.senderId;
        const recipientId = messageData.recipientId;
        const text = messageData.text;

        if (!recipientId || !text) {
        console.log("❌ Missing recipientId or text");
        return null;
        }

        const userDoc = await admin.firestore().collection("users").doc(recipientId).get();

        if (!userDoc.exists || !userDoc.data().fcmToken) {
        console.log("❌ No FCM token for recipient");
        return null;
        }


        const token = userDoc.data().fcmToken;
         const payload = {
      notification: {
        title: "New Message",
        body: text.length > 100 ? text.slice(0, 100) + "..." : text,
        sound: "default",
      },
      data: {
        senderId: senderId,
        click_action: "FLUTTER_NOTIFICATION_CLICK", 
        },
        };
        try {
        await admin.messaging().sendToDevice(token, payload);
        console.log(`✅ Notification sent to ${recipientId}`);
        } catch (error) {
        console.error("❌ Error sending notification:", error);
        }

        return null;
    })
