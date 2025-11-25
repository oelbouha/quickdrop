// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
require('dotenv').config();

if (!admin.apps.length) {
  admin.initializeApp();
}


const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);


const translations = {
  newMessage: {
    en: "New Message",
    fr: "Nouveau message",
    ar: "رسالة جديدة"
  },
  newRequest: {
    en: (name) => `New package request from ${name}`,
    fr: (name) => `Nouvelle demande de colis de la part de ${name}`,
    ar: (name) => `طلب طرد جديد من ${name}`
  },
   newRequestTitle: {
    en: (name) => `New package request`,
    fr: (name) => `Nouvelle demande de colis`,
    ar: (name) => `طلب طرد جديد`
  }
};



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
    
    const userDoc = await admin.firestore().collection("users").doc(recipientId).get();
    const senderDoc = await admin.firestore().collection("users").doc(senderId).get();

    if (!userDoc.exists || !senderDoc.exists) {
      return null;
    }

    const recipientData = userDoc.data();
    const senderData = senderDoc.data();

    const lang = recipientData.language || "en";
   
    const title = translations.newMessage[lang] || translations.newMessage["en"];



    if (!recipientId ) {
      return null;
    }

   
    
    
    if (!recipientData.fcmToken) {
      return null;
    }

    const token = recipientData.fcmToken;
    
    // Updated payload format for the modern API
    const message = {
      token: token,
      notification: {
        title: title,
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
    
    const recipientData = userDoc.data();

    const userData = senderDoc.data();
    const userName = userData.displayName;
    const lang = recipientData.language || "en";
    // const text = "New package request from " + userName;
    const title = translations.newRequestTitle[lang] || translations.newRequest["en"];
    const body = translations.newRequest[lang](userName) || translations.newRequest["en"];


    const notificationRef = await admin.firestore().collection("notifications").add({
      senderId: senderId,
      receiverId: recipientId,
      message: body,
      date: admin.firestore.FieldValue.serverTimestamp(),
      read: false, 
    });
    
    if (!recipientData.fcmToken) {
      return null;
    }

    const token = recipientData.fcmToken;
    const message = {
      token: token,
      notification: {
        title: title,
        body: body.length > 100 ? body.slice(0, 100) + "..." : body,
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


