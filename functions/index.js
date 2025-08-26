// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNewMessageNotification = onDocumentCreated({
  document: "chats/{chatId}/messages/{messageId}",
  region: "us-central1"
}, async (event) => {
  try {
    const snap = event.data;
    if (!snap) {
      console.log("No data associated with the event");
      return null;
    }

    const messageData = snap.data();
    const senderId = messageData.senderId;
    const recipientId = messageData.receiverId;
    const text = messageData.text;

    console.log(`📨 Processing message from ${senderId} to ${recipientId}`);
    console.log(`📝 Message text: "${text}"`);

    if (!recipientId || !text) {
      console.log("❌ Missing recipientId or text");
      return null;
    }

    // Get recipient's FCM token
    console.log(`🔍 Looking up user document for recipient: ${recipientId}`);
    const userDoc = await admin.firestore().collection("users").doc(recipientId).get();

    if (!userDoc.exists) {
      console.log(`❌ User ${recipientId} does not exist`);
      return null;
    }

    const userData = userDoc.data();
    console.log(`👤 User data found, checking for FCM token...`);
    
    if (!userData.fcmToken) {
      console.log(`❌ No FCM token for recipient ${recipientId}`);
      console.log(`📄 Available user fields: ${Object.keys(userData)}`);
      return null;
    }

    const token = userData.fcmToken;
    console.log(`🔑 FCM token found: ${token.substring(0, 20)}...`);
    
    // Updated payload format for the modern API
    const message = {
      token: token,
      notification: {
        title: "New Message",
        body: text.length > 100 ? text.slice(0, 100) + "..." : text,
      },
      data: {
        senderId: senderId,
        recipientId: recipientId,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
      // Optional: Android specific settings
      android: {
        notification: {
          sound: "default",
        }
      },
      // Optional: iOS specific settings
      apns: {
        payload: {
          aps: {
            sound: "default"
          }
        }
      }
    };

    console.log(`📤 Sending notification with payload:`, JSON.stringify(message, null, 2));

    // Send the notification using the modern API
    const response = await admin.messaging().send(message);
    
    console.log(`✅ Notification sent successfully to ${recipientId}. Message ID: ${response}`);

    return null;
  } catch (error) {
    console.error("❌ Error in sendNewMessageNotification:", error);
    
    // More detailed error logging
    if (error.code) {
      console.error(`🚨 Error code: ${error.code}`);
    }
    if (error.message) {
      console.error(`💬 Error message: ${error.message}`);
    }
    if (error.details) {
      console.error(`📋 Error details:`, JSON.stringify(error.details, null, 2));
    }
    
    return null;
  }
});


exports.packageRequestNotification = onDocumentCreated({
  document: "/requests/{requestsId}",
  region: "us-central1"
}, async (event) => {
  try {
    const snap = event.data;
    if (!snap) {
      console.log("No data associated with the event");
      return null;
    }

    const messageData = snap.data();
    const senderId = messageData.senderId;
    const recipientId = messageData.receiverId;
   

    // console.log(`📨 Processing message from ${senderId} to ${recipientId}`);
    // console.log(`📝 Message text: "${text}"`);

    if (!recipientId ) {
      console.log("❌ Missing recipientId ");
      return null;
    }

    // Get recipient's FCM token
    console.log(`🔍 Looking up user document for recipient: ${recipientId}`);
    const userDoc = await admin.firestore().collection("users").doc(recipientId).get();
    const senderDoc = await admin.firestore().collection("users").doc(senderId).get();

    if (!userDoc.exists) {
      console.log(`❌ User ${recipientId} does not exist`);
      return null;
    }

    const userData = senderDoc.data();
    const userName = userData.displayName;
    const text = "New package request from " + userName;

    console.log(`👤 User data found, checking for FCM token...`);

    const notificationRef = await admin.firestore().collection("notifications").add({
      senderId: senderId,
      receiverId: recipientId,
      message: text,
      date: admin.firestore.FieldValue.serverTimestamp(),
      read: false, 
    });
    
    if (!userData.fcmToken) {
      console.log(`❌ No FCM token for recipient ${recipientId}`);
      console.log(`📄 Available user fields: ${Object.keys(userData)}`);
      return null;
    }

    const token = userData.fcmToken;
    // console.log(`🔑 FCM token found: ${token.substring(0, 20)}...`);
    
    // Updated payload format for the modern API
    const message = {
      token: token,
      notification: {
        title: "New Request",
        body: text.length > 100 ? text.slice(0, 100) + "..." : text,
      },
      data: {
        senderId: senderId,
        recipientId: recipientId,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
      // Optional: Android specific settings
      android: {
        notification: {
          sound: "default",
        }
      },
      // Optional: iOS specific settings
      apns: {
        payload: {
          aps: {
            sound: "default"
          }
        }
      }
    };

    // console.log(`📤 Sending notification with payload:`, JSON.stringify(message, null, 2));

    // Send the notification using the modern API
    const response = await admin.messaging().send(message);
    
    console.log(`✅ Notification sent successfully to ${recipientId}. Message ID: ${response}`);

    return null;
  } catch (error) {
    console.error("❌ Error in packageRequestNotification:", error);
    
    return null;
  }
});


