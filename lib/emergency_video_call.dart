import 'package:flutter/material.dart';

class EmergencyVideoCall extends StatefulWidget {
  const EmergencyVideoCall({Key? key}) : super(key: key);

  @override
  State<EmergencyVideoCall> createState() => _EmergencyVideoCallState();
}

class _EmergencyVideoCallState extends State<EmergencyVideoCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Emergency Contact")),
    );
  }
}
