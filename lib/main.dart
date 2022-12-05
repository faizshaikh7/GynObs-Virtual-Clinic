import 'dart:developer';
import 'dart:io';

import 'package:agp_ziauddin_virtual_clinic/database_methods.dart';
import 'package:agp_ziauddin_virtual_clinic/doctor_appointment_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/doctor_main_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/notification/icoming_call_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/other_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/patient_main_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String callerName = "Unknown";
String callerRoomID = "";
String callerHospital = "";

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  console.log("surgen Recive's $callerName message");
  console.log("Background: message => ${message.toString()}");
  log("BG Message data: ${message.data}");
  callerName = message.data["name"];
  callerRoomID = message.data["room_id"];
  callerHospital = message.data["hospital"] ?? "Freelancer";

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: "call_channel",
      title: callerName,
      body: "from $callerHospital",
      wakeUpScreen: true,
      fullScreenIntent: true,
      displayOnBackground: true,
      displayOnForeground: true,
      locked: true,
      // customSound:
      //     "https://open.spotify.com/track/68EkhVWIeULhHxcbi1QhzK?si=668ffccbfff94980",
    ),
    actionButtons: [
      NotificationActionButton(
        key: "decline",
        enabled: true,
        label: "Decline",
        isDangerousOption: true,
        buttonType: ActionButtonType.Default,
      ),
      NotificationActionButton(
        key: 'accept-$callerRoomID',
        label: "Answer",
        enabled: true,
        buttonType: ActionButtonType.Default,
        color: Colors.green,
      )
    ],
  );
}

Future<void> getFCMData(RemoteMessage message) async {
  log("InApp Message data: ${message.data}");
  callerName = message.data["name"];
  callerRoomID = message.data["room_id"];
  callerHospital = message.data["hospital"] ?? "Freelancer";

  log(callerName);
  log(callerRoomID);
  log(callerHospital);

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: "call_channel", // Check here if not work
      title: callerName,
      body: callerHospital,
      wakeUpScreen: true,
      fullScreenIntent: true,
      displayOnBackground: true,
      displayOnForeground: true,
      locked: true,
      // customSound:
      //     "https://open.spotify.com/track/68EkhVWIeULhHxcbi1QhzK?si=668ffccbfff94980",
    ),
    actionButtons: [
      NotificationActionButton(
        key: "decline",
        enabled: true,
        label: "Decline",
        isDangerousOption: true,
        buttonType: ActionButtonType.Default,
      ),
      NotificationActionButton(
        key: 'accept-$callerRoomID',
        label: "Answer",
        enabled: true,
        buttonType: ActionButtonType.Default,
        color: Colors.green,
      )
    ],
  );

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'call_channel_group',
        channelKey: "call_channel",
        channelName: 'agp_clinic',
        channelDescription: 'video calling',
        defaultColor: Colors.green,
        ledColor: Colors.white,
        enableVibration: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
        // playSound: true,
        // soundSource:
        //     "https://open.spotify.com/track/68EkhVWIeULhHxcbi1QhzK?si=668ffccbfff94980",
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupName: "Basic Group",
        channelGroupkey: 'call_channel_group',
      ),
    ],
    debug: true,
  );

  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen(getFCMData);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  runApp(const MyApp());
}

SharedPreferences? prefs;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? checkLogin;
  String? isPatient;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin = prefs!.getBool("islogin") ?? false;
    isPatient = prefs!.getString("type") ?? "Doctor";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "A2Z GynObs",
      theme: ThemeData(primarySwatch: Colors.green),
      home: checkLogin == true
          ? isPatient == "Doctor"
              ? DoctorMainScreen()
              : PatientMainScreen()
          : SplashScreen(),
    );
  }
}
