import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('messages/{pushId}')
  .onCreate(async (snapshot) => {
    const message = snapshot.data();
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Message',
        body: `${message.sender} sent a new message`,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    };
    return fcm.sendToTopic('messages', payload);
  });
