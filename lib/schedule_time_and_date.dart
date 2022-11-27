import 'package:agp_ziauddin_virtual_clinic/constants/colors.dart';
import 'package:agp_ziauddin_virtual_clinic/main.dart';
import 'package:agp_ziauddin_virtual_clinic/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleTimeAndDateScreen extends StatefulWidget {
  final DocumentSnapshot ds;
  const ScheduleTimeAndDateScreen({Key? key, required this.ds})
      : super(key: key);

  @override
  State<ScheduleTimeAndDateScreen> createState() =>
      _ScheduleTimeAndDateScreenState();
}

class _ScheduleTimeAndDateScreenState extends State<ScheduleTimeAndDateScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Book Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText("Select Date", 16),
            VSpace(8),
            InkWell(
              onTap: () async {
                selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(3000));
                setState(() {});
              },
              child: Container(
                height: 40,
                decoration: boxDecoration(white),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat("dd/MM/yyyy")
                              .format(selectedDate ?? DateTime.now())),
                          Icon(Icons.date_range)
                        ],
                      ),
                    )),
              ),
            ),
            VSpace(20),
            boldText("Select Time", 16),
            VSpace(8),
            InkWell(
              onTap: () async {
                selectedTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                setState(() {});
              },
              child: Container(
                height: 40,
                decoration: boxDecoration(white),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text((selectedTime ?? TimeOfDay.now())
                              .format(context)),
                          Icon(Icons.timer)
                        ],
                      ),
                    )),
              ),
            ),
            VSpace(40),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : MaterialButton(
                    // minWidth: 90,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    height: 40,
                    color: green,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      await FirebaseFirestore.instance
                          .collection("appointment")
                          .add({
                        "userIds": [widget.ds.id, prefs!.getString("id")],
                        "doctor_name": widget.ds["name"],
                        "doctor_email": widget.ds["email"],
                        "doctor_hospital": widget.ds["hospital"],
                        "doctor_id": widget.ds.id,
                        "patient_id": prefs!.getString("id"),
                        "patient_email": prefs!.getString("email"),
                        "time":
                            (selectedTime ?? TimeOfDay.now()).format(context),
                        "date": DateFormat("dd/MM/yyyy")
                            .format(selectedDate ?? DateTime.now())
                      }).then((value) {
                        showSnackbar(
                            context, "Appointment booked Successfully");
                        setState(() {
                          isLoading = false;
                        });
                        goBack(context);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_online,
                          color: white,
                          size: 23,
                        ),
                        HSpace(5),
                        bAppText("Book Appointment", 16, white)
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
