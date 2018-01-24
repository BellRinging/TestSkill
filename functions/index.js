const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// listen for Following events and then trigger a push notification
exports.observeFollowing = functions.database.ref('/following/{uid}/{followingId}')
  .onCreate(event => {

    var uid = event.params.uid;
    var followingId = event.params.followingId

    // let's log out some messages

    console.log('User: ' + uid + ' is following: ' + followingId);

    // trying to figure out fcmToken to send a push message
    return admin.database().ref('/users/' + followingId).once('value', snapshot => {

      var userWeAreFollowing = snapshot.val();

      return admin.database().ref('/users/' + uid).once('value', snapshot => {

        var userDoingTheFollowing = snapshot.val();

        var payload = {
          notification: {
            title: "You now have a new follower",
            body: userDoingTheFollowing.name + ' is now following you'
          },
          data: {
            followerId: uid
          }
        }

        admin.messaging().sendToDevice(userWeAreFollowing.fcmToken, payload)
          .then(response => {
            console.log("Successfully sent message:", response);
          }).catch(function(error) {
            console.log("Error sending message:", error);
          });

      })


    })
  })

exports.sendPushNotifications = functions.https.onRequest((req, res) => {
  res.send("Attempting to send push notification...")
  console.log("LOGGER --- Trying to send push message...")

  // admin.message().sendToDevice(token, payload)

  var uid = 'NUPR2dHs7ehUYN01PtzKpyJbY753';

  return admin.database().ref('/users/' + uid).once('value', snapshot => {

    var user = snapshot.val();

    console.log("User username: " + user.username + " fcmToken: " + user.fcmToken);

    var payload = {
      notification: {
        title: "Push notification TITLE HERE",
        body: "Body over here is our message body..."
      }
    }

    admin.messaging().sendToDevice(user.fcmToken, payload)
      .then(function(response) {
        // See the MessagingDevicesResponse reference documentation for
        // the contents of response.
        console.log("Successfully sent message:", response);
      })
      .catch(function(error) {
        console.log("Error sending message:", error);
      });
  })

})
