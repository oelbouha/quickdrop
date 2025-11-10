// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
require('dotenv').config();

if (!admin.apps.length) {
  admin.initializeApp();
}


const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);


exports.createPaymentIntent = onCall(async (request) => {
  
  if (!request.auth) {
    console.log('No auth found');
    throw new HttpsError('unauthenticated', 'Must be signed in');
  }


  
  const { amount, currency } = request.data;

  if (!amount || !currency) {
    // console.log('Missing amount or currency');
    throw new HttpsError('invalid-argument', 'Missing amount or currency');
  }

  if (typeof amount !== 'number' || amount <= 0) {
    throw new HttpsError('invalid-argument', 'Amount must be a positive number');
  }

  try {
    // console.log('Calling Stripe API...');
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: { enabled: true },
      metadata: { userId: request.auth.uid },
    });

    return { clientSecret: paymentIntent.client_secret };
  } catch (error) {
    
    throw new HttpsError('internal', error.message);
  }
});




exports.sendNewMessageNotification = onDocumentCreated({
  document: "chats/{chatId}/messages/{messageId}",
  region: "us-central1"
}, async (event) => {
  try {
    const snap = event.data;
    if (!snap) {
      return null;
    }

    const messageData = snap.data();
    const senderId = messageData.senderId;
    const recipientId = messageData.receiverId;
    const text = messageData.text;

    

    if (!recipientId || !text) {
      return null;
    }

    const userDoc = await admin.firestore().collection("users").doc(recipientId).get();

    if (!userDoc.exists) {
      return null;
    }

    const userData = userDoc.data();
    
    if (!userData.fcmToken) {
      return null;
    }

    const token = userData.fcmToken;
    
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
      // Android specific settings
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


    // Send the notification using the modern API
    const response = await admin.messaging().send(message);

    return null;
  } catch (error) {

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
      return null;
    }

    const messageData = snap.data();
    const senderId = messageData.senderId;
    const recipientId = messageData.receiverId;
   


    if (!recipientId ) {
      return null;
    }

       const userDoc = await admin.firestore().collection("users").doc(recipientId).get();
    const senderDoc = await admin.firestore().collection("users").doc(senderId).get();

    if (!userDoc.exists) {
      return null;
    }

    const userData = senderDoc.data();
    const userName = userData.displayName;
    const text = "New package request from " + userName;


    const notificationRef = await admin.firestore().collection("notifications").add({
      senderId: senderId,
      receiverId: recipientId,
      message: text,
      date: admin.firestore.FieldValue.serverTimestamp(),
      read: false, 
    });
    
    if (!userData.fcmToken) {
      return null;
    }

    const token = userData.fcmToken;
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
      //  Android specific settings
      android: {
        notification: {
          sound: "default",
        }
      },
      // iOS specific settings
      apns: {
        payload: {
          aps: {
            sound: "default"
          }
        }
      }
    };

    
    // Send the notification using the modern API
    const response = await admin.messaging().send(message);

    return null;
  } catch (error) {
    
    return null;
  }
});


