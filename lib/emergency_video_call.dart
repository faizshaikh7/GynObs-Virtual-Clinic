import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EmergencyVideoCall extends StatefulWidget {
  const EmergencyVideoCall({Key? key}) : super(key: key);

  @override
  State<EmergencyVideoCall> createState() => _EmergencyVideoCallState();
}

class _EmergencyVideoCallState extends State<EmergencyVideoCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Emergency"),
    );
  }
}
