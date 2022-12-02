import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as console;
import 'package:flutter/foundation.dart';

class NotificationServices {
  final String fcmTestToken =
      "fZrw96KNS-Gg1HveRR_D54:APA91bHLPlYpiIE0bDtHtR9c5oC90KQ4XXmmqTZdzok6WdOuWrDasBwsRAh-YOMztyEBDztBpOJKfCvpYV1ixEZL-7kbI6g8AcPsb2DEDtQ_Zenlrjem-x6CX_jZ0FxUuxF17u0CjBnU";

  final String authorizationServerKey =
      "key=AAAA-Q3BGzY:APA91bH_cLGZQXjGQ85b4S_EmlbAIoca80WD9UIPlqYyTJDAmy2ptrYPcSfnbMgmHmiZ9gV_sLKNKy4HGcoVjip-qgeOUjBulCIQllAn_mW8suir4B2DS-NBT2Vq6Ov5w2bfLEhqClP0";

  void sendPushMessage(fcmToken) async {
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": authorizationServerKey,
        },
        body: jsonEncode(
          <String, dynamic>{
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICKED",
              "status": "done",
              "body": "hello world Yo",
              "title": "One Piece is Real"
            },
            // "notification": <String, dynamic>{
            //   "title": "One Piece is Real",
            //   "body": "hello world Yo",
            // },
            "to": fcmTestToken,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        console.log("error push notification");
      }
    }

    // API #2

    //   var headersList = {
    //     'Accept': '*/*',
    //     'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    //     'Content-Type': 'application/json',
    //     'Authorization': authorizationServerKey,
    //   };
    //   var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    //   var body = {
    //     "to": fcmTestToken,
    //     "data": {
    //       "body": "Body of Your Notification in Data",
    //       "title": "Title of Your Notification in Title",
    //       "key_1": "Value for key_1",
    //       "key_2": "Value for key_2"
    //     }
    //   };

    //   var req = http.Request('POST', url);
    //   req.headers.addAll(headersList);
    //   req.body = json.encode(body);

    //   var res = await req.send();
    //   final resBody = await res.stream.bytesToString();

    //   if (res.statusCode >= 200 && res.statusCode < 300) {
    //     print(resBody);
    //   } else {
    //     print(res.reasonPhrase);
    //   }
    // }
  }

  // Permission Req ##

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      console.log("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      console.log("User granted provisional permission");
    } else {
      console.log("User Decline ");
    }
  }
}
