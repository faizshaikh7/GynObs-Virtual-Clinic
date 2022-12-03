import 'dart:convert';

import 'package:agp_ziauddin_virtual_clinic/about_us_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/add_patient_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/doctor_main_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/notification/awesome_notification.dart';
import 'package:agp_ziauddin_virtual_clinic/services/api_and_notification_service.dart';
import 'package:agp_ziauddin_virtual_clinic/chat_list_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/constants/colors.dart';
import 'package:agp_ziauddin_virtual_clinic/database_methods.dart';
import 'package:agp_ziauddin_virtual_clinic/doctor_profile_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/emergency_video_call.dart';
import 'package:agp_ziauddin_virtual_clinic/emnoc_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/main.dart';
import 'package:agp_ziauddin_virtual_clinic/patients_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/reports_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/splash_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/training_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/upload_report_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/video_call_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/video_consultation_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as console;

var currentUserEmail = "";
var currentUserCity = "";
var currentUserRoomID = "";
var currentUserHospital = "";
var currentUserName = "";
var currentUserUID = "";

class DoctorAppointmentScreen extends StatefulWidget {
  const DoctorAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<DoctorAppointmentScreen> {
  GlobalKey<ScaffoldState> dKey = GlobalKey<ScaffoldState>();

  final String headDoctorCode = "9012";
  final String headDoctorEmail = "zukemari@email.com";
  final String roomId = "9219";

  String? notificationToken;
  String? testNotificationToken;

  _emergencyCallFunc(BuildContext context) async {
    await Permission.camera.request();
    await Permission.microphone.request();
    goBack(context); // FIX GOO BACKK WALA THING
    goto(context, VideoCallScreen(channelName: currentUserRoomID));
    // NotificationServices().sendPushMessage(notificationToken);
    NotificationServices().sendPushMessage(testNotificationToken);
    // goBack(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => EmergencyVideoCall(),
    //     ));
  }

  getNotificationToken() async {
    await FirebaseMessaging.instance.getToken().then((fcmToken) {
      setState(() {
        var currentUser = FirebaseAuth.instance.currentUser;
        console.log("CURRENT USER EMAIL => ${currentUser!.email}");

        if (currentUser.email == "faizshaikh@gmail.com") {
          // change email after testing^^
          DatabaseMethods().updateUserInfoToDB(
            "doctors",
            currentUser.uid,
            {
              "fcm_token": fcmToken,
            },
          );
          console.log(fcmToken ?? "Token is Null");
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices().requestPermission();
    getNotificationToken();
    CustomAwesomeNotification().listen(context);
    // DatabaseMethods().getUserInfoFromDB();

    // Testing FCM Token
    CollectionReference surgenDoctorCollection =
        FirebaseFirestore.instance.collection("doctors");

    var testingSurgenDoctorData =
        surgenDoctorCollection.doc("IfJmpFsjsTRY3ddUDPkglP48CHY2").get();

    testingSurgenDoctorData.then((fieldsValue) => {
          testNotificationToken = fieldsValue["fcm_token"],
          print("Testing FCM TOKEN ===> ${fieldsValue["name"]}"),
          print("Testing FCM TOKEN ===> ${fieldsValue["fcm_token"]}"),
        });
    // Testing FCM Token

    // CURRENT SURGEN DATA DATA START
    // CollectionReference surgenDoctorCollection =
    //     FirebaseFirestore.instance.collection("doctors");

    // var surgenDoctorData =
    //     surgenDoctorCollection.doc("4aweZpdCXeUyyqZgzcXSWNoXl912").get();

    // surgenDoctorData.then((fieldsValue) => {
    //       notificationToken = fieldsValue["fcm_token"],
    //       print("Surgens FCM TOKEN ===> ${fieldsValue["name"]}"),
    //       print("Surgens FCM TOKEN ===> ${fieldsValue["fcm_token"]}"),
    //     });
    // CURRENT SURGEN DATA DATA END

    // CURRENT USER DATA START
    var uid = FirebaseAuth.instance.currentUser!.uid;
    currentUserUID = uid;

    CollectionReference users =
        FirebaseFirestore.instance.collection("doctors");

    var data = users.doc(currentUserUID).get();

    data.then((data) {
      currentUserEmail = data["email"];
      currentUserName = data["name"];
      currentUserRoomID = data["code"].toString();
      currentUserHospital = data["hospital"];
      currentUserCity = data["city"];

      print(currentUserName);
      print(currentUserEmail);
      print(currentUserRoomID);
      print(currentUserHospital);
      print(currentUserUID);
      print(currentUserCity);
    });
    // CURRENT USER DATA END
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      key: dKey,
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       dKey.currentState!.openDrawer();
      //     },
      //     icon: Icon(
      //       Icons.menu,
      //       size: 30,
      //     ),
      //   ),
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   title: Image.asset(
      //     "images/head.png",
      //     height: 110,
      //     color: grey1,
      //   ),
      // ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  normalText(prefs!.getString("name") ?? "Unknown", 20),
              accountEmail: Text(prefs!.getString("email") ?? "Unknown"),
              currentAccountPicture: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
            ),
            DrawerItems(Icons.home, "Home", () {
              goBack(context);
            }),
            DrawerItems(Icons.person, "Profile", () {
              goBack(context);
              goto(context, DoctorProfileScreen());
            }),
            DrawerItems(Icons.info, "About Us", () {
              goBack(context);
              goto(context, AboutUsScreen());
            }),
            DrawerItems(Icons.privacy_tip, "EmNOC", () {
              goBack(context);
              goto(context, EMNOCScreen());
            }),
            DrawerItems(Icons.book_online, "Appointment", () {
              goBack(context);
              goto(context, PatientsScreen());
            }),
            DrawerItems(Icons.video_camera_back_outlined, "Video Consultation",
                () {
              goBack(context);
              goto(context, VideoConsultationScreen());
            }),
            DrawerItems(Icons.chat, "Chat", () {
              goBack(context);
              goto(context, ChatListScreen());
            }),
            DrawerItems(Icons.model_training, "Training", () {
              goBack(context);
              goto(context, TrainingScreen());
            }),
            DrawerItems(Icons.pregnant_woman, "Symptom Checker", () async {
              String url =
                  "https://www.mdcalc.com/calc/423/pregnancy-due-dates-calculator";
              if (!await launchUrl(Uri.parse(url))) {
                throw 'Could not launch $url';
              }
            }),
            DrawerItems(Icons.logout, "Sign Out", () {
              prefs!.setBool("islogin", false);
              goOff(context, SplashScreen());
            }),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: fullWidth(context),
                  height: 170,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          "images/left.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "images/right.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    dKey.currentState!.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 30),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Item(Icons.file_copy, "Reports", () {
                              goto(context, ReportsScreen());
                            }, Colors.green),
                            Item(Icons.person, "Patients", () {
                              goto(context, PatientsScreen());
                            }, Colors.blue[900]),
                          ],
                        ),
                        VSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Item(Icons.book, "Upload Prescription", () {
                              goto(context, UploadReportScreen());
                            }, Colors.orange),
                            Item(Icons.computer, "Symptom Checker", () async {
                              String url =
                                  "https://www.mdcalc.com/calc/423/pregnancy-due-dates-calculator";
                              if (!await launchUrl(Uri.parse(url))) {
                                throw 'Could not launch $url';
                              }
                            }, Colors.purple[900]),
                          ],
                        ),
                        VSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Item(Icons.model_training, "Training", () {
                              goto(context, TrainingScreen());
                            }, Colors.cyan[900]),
                            Item(Icons.pregnant_woman, "EmNOC", () {
                              goBack(context);
                              goto(context, EMNOCScreen());
                            }, Colors.teal[900])
                          ],
                        ),
                        VSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Item(
                              Icons.emergency_recording_rounded,
                              "Doctor Emergency",
                              () {
                                _emergencyCallFunc(context);
                              },
                              Colors.red[900],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Item(IconData icon, String title, Function fun, Color? color) {
    return InkWell(
      onTap: () {
        fun();
      },
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: grey2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: color,
              ),
              VSpace(5),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
