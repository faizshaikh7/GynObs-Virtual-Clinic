import 'dart:convert';

import 'package:agp_ziauddin_virtual_clinic/about_us_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/add_patient_screen.dart';
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
import 'package:agp_ziauddin_virtual_clinic/video_consultation_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/widgets/custom_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as console;

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

  _emergencyCallFunc(BuildContext context) {
    // goBack(context);
    // goto(
    //     context,
    //     VideoCallScreen(
    //         channelName: "")); // ADD CURRENT USER CODE IN CHANNEL NAME!
    NotificationServices().sendPushMessage(notificationToken);
    goBack(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyVideoCall(),
        ));
  }

  getNotificationToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        notificationToken = value;
        console.log(notificationToken ?? "Token is Null");
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
