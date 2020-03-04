const functions = require('firebase-functions');
const uuid = require('uuid')
// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// listen for Following events and then trigger a push notification

// exports.writeToFirestore = functions.firestore
//   .document('some/doc')
//   .onWrite((change, context) => {
//     db.doc('some/otherdoc').set({ ... });
//   });


exports.createGameRecordsWithinUser = functions.firestore
    .document('gameDetails/{detailId}')
    .onCreate((snap, context) => {
      // If we set `/users/marie/incoming_messages/134` to {body: "Hello"} then
      // var id = context.params.detailId ;
      const newValue = snap.data();
      const value = newValue.value;
      const remark = newValue.remark;
      const gameId = newValue.gameId;
      const id = newValue.id;
      const winType = newValue.winType;
      const whoLose = newValue.whoLose;
      const whoWin = newValue.whoWin;
      const byErrorFlag = newValue.byErrorFlag;


      var payload = {
          id: id,
          gameId: gameId,
          value: value
      }
        console.log('User: ' + payload);
      db.doc('users/' + userId + '/gameRecords/' + id ).set(payload);

    });

// exports.observeFollowing = functions.database.ref('/following/{uid}/{followingId}')
//   .onCreate(event => {
//
//     var uid = event.params.uid;
//     var followingId = event.params.followingId
//
//     // let's log out some messages
//
//     console.log('User: ' + uid + ' is following: ' + followingId);
//
//     // trying to figure out fcmToken to send a push message
//     return admin.database().ref('/users/' + followingId).once('value', snapshot => {
//
//       var userWeAreFollowing = snapshot.val();
//
//       return admin.database().ref('/users/' + uid).once('value', snapshot => {
//
//         var userDoingTheFollowing = snapshot.val();
//
//         var payload = {
//           notification: {
//             title: "You now have a new follower",
//             body: userDoingTheFollowing.name + ' is now following you'
//           },
//           data: {
//             followerId: uid
//           }
//         }
//
//         admin.messaging().sendToDevice(userWeAreFollowing.fcmToken, payload)
//           .then(response => {
//             console.log("Successfully sent message:", response);
//           }).catch(function(error) {
//             console.log("Error sending message:", error);
//           });
//
//       })
//
//
//     })
//   })
//
// exports.sendPushNotifications = functions.https.onRequest((req, res) => {
//   res.send("Attempting to send push notification...")
//   console.log("LOGGER --- Trying to send push message...")
//
//   // admin.message().sendToDevice(token, payload)
//
//   var uid = 'NUPR2dHs7ehUYN01PtzKpyJbY753';
//
//   return admin.database().ref('/users/' + uid).once('value', snapshot => {
//
//     var user = snapshot.val();
//
//     console.log("User username: " + user.username + " fcmToken: " + user.fcmToken);
//
//     var payload = {
//       notification: {
//         title: "Push notification TITLE HERE",
//         body: "Body over here is our message body..."
//       }
//     }
//
//     admin.messaging().sendToDevice(user.fcmToken, payload)
//       .then(function(response) {
//         // See the MessagingDevicesResponse reference documentation for
//         // the contents of response.
//         console.log("Successfully sent message:", response);
//       })
//       .catch(function(error) {
//         console.log("Error sending message:", error);
//       });
//   })

// })
