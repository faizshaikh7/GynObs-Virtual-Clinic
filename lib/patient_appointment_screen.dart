import 'package:agp_ziauddin_virtual_clinic/about_us_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/constants/colors.dart';
import 'package:agp_ziauddin_virtual_clinic/database_methods.dart';
import 'package:agp_ziauddin_virtual_clinic/main.dart';
import 'package:agp_ziauddin_virtual_clinic/patient_video_consultation_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/schedule_time_and_date.dart';
import 'package:agp_ziauddin_virtual_clinic/splash_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientAppointmentScreen extends StatefulWidget {
  const PatientAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<PatientAppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<PatientAppointmentScreen> {
  bool isLoading = false;
  int selected = -1;
  GlobalKey<ScaffoldState> dKey = GlobalKey<ScaffoldState>();

  var doctorsStream;
  doOnLaunch() async {
    doctorsStream = await DatabaseMethods().getDoctors();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doOnLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      key: dKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Appointments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: doctorsStream,
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? snapshot.data!.docs.length == 0
                    ? Center(child: boldText("No Appointments", 16))
                    : ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          return Card(
                            color: white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: grey2!)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: grey2,
                                        child: Icon(
                                          Icons.person,
                                          size: 35,
                                        ),
                                      ),
                                      HSpace(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          boldText(ds["name"], 19),
                                          VSpace(3),
                                          normalText(ds["email"], 16),
                                        ],
                                      ),
                                    ],
                                  ),
                                  VSpace(10),
                                  normalText(
                                      "From " +
                                          ds["hospital"] +
                                          " Hospital At " +
                                          ds["city"],
                                      17),
                                  VSpace(10),
                                  PrimaryOutlineButton(() {
                                    goto(context,
                                        ScheduleTimeAndDateScreen(ds: ds));
                                  }, "Schedule", fullWidth(context)),
                                ],
                              ),
                            ),
                          );
                        }))
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}
