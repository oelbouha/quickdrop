// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNewMessageNotification = onDocumentCreated({
  document: "messages/{messageId}",
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
    const recipientId = messageData.recipientId;
    const text = messageData.text;

    console.log(`📨 Processing message from ${senderId} to ${recipientId}`);

    if (!recipientId || !text) {
      console.log("❌ Missing recipientId or text");
      return null;
    }

    // Get recipient's FCM token
    const userDoc = await admin.firestore().collection("users").doc(recipientId).get();

    if (!userDoc.exists) {
      console.log(`❌ User ${recipientId} does not exist`);
      return null;
    }

    const userData = userDoc.data();
    if (!userData.fcmToken) {
      console.log(`❌ No FCM token for recipient ${recipientId}`);
      return null;
    }

    const token = userData.fcmToken;
    const payload = {
      notification: {
        title: "New Message",
        body: text.length > 100 ? text.slice(0, 100) + "..." : text,
        sound: "default",
      },
      data: {
        senderId: senderId,
        recipientId: recipientId,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    // Send the notification
    const response = await admin.messaging().sendToDevice(token, payload);
    
    if (response.successCount > 0) {
      console.log(`✅ Notification sent successfully to ${recipientId}`);
    } else {
      console.log(`⚠️ Failed to send notification: ${JSON.stringify(response.results)}`);
    }

    return null;
  } catch (error) {
    console.error("❌ Error in sendNewMessageNotification:", error);
    return null;
  }
});


// # Create a message document using gcloud
// gcloud firestore documents create \
//   --project=quickdrop-38749 \
//   --collection-group=messages \
//   --data='{
//     "senderId": {"stringValue": "T0BMzJj4bhgh91P5PKXZAI8Kvg82"},
//     "recipientId": {"stringValue": "wdrVujnB6dgglhbj6M7h0PsZ9ow1"},
//     "text": {"stringValue": "gcloud test message"},
//     "timestamp": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"},
//     "type": {"stringValue": "text"}
//   }'

//   # Get your Firebase project's REST API endpoint
// # Replace PROJECT_ID with quickdrop-38749
// curl -X POST \
// 'https://firestore.googleapis.com/v1/projects/quickdrop-38749/messages:send' \
// -H 'Authorization: Bearer '$(gcloud auth print-access-token) \
// -H 'Content-Type: application/json' \
// -d '{
//   "message": {
//       "token": "fGUOLfMWR7mEnR1V1InPXw:APA91bFPyZpxTM7QyzbgtmhAVZH3T4k8eo7SqEmDlfrpoALKLeFghyihOux8ikFrOgc3havfaFNf49_RWbt8Dma_p4Jeckxoq60RyAojW5S-O9_bHFyBsro",
//       "notification": {
//         "title": "Hello",
//         "body": "This is a test notification"
//       }
//     }
// }'