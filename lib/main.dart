import 'package:agp_ziauddin_virtual_clinic/doctor_main_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/other_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/patient_main_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage event) async {
  console.log("Message Recive to Surgen");
  console.log("Background: message => ${event.toString()}");
  final String headDoctorCode = "9012";
  final String headDoctorEmail = "zukemari@email.com";

  final String roomId = "9219";

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: "basic_channel", // Check here if not work
      title: "Faiz Shaikh",
      body: "9653179521",
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
        key: 'accept-$roomId',
        label: "Accept",
        enabled: true,
        buttonType: ActionButtonType.Default,
        color: Colors.green,
      )
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: "basic_channel", // Check here if not work
        channelName: 'Whatsapp',
        channelDescription: 'Whatsapp calling',
        defaultColor: Colors.green,
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupName: "Basic Group",
        channelGroupkey: 'basic_channel_group',
      ),
    ],
    debug: true,
  );
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
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
      title: "EmNOC A2Z",
      theme: ThemeData(primarySwatch: Colors.green),
      home: checkLogin == true
          ? isPatient == "Doctor"
              ? DoctorMainScreen()
              : PatientMainScreen()
          : SplashScreen(),
    );
  }
}
