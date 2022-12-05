import 'dart:async';
import 'package:agp_ziauddin_virtual_clinic/main.dart';
import 'package:agp_ziauddin_virtual_clinic/video_call_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as console;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

bool alreadyListening = false;

class CustomAwesomeNotification {
  StreamSubscription<ReceivedAction>? _actionStreamSubscription;
  void listen(context) async {
    await _actionStreamSubscription?.cancel();
    if (alreadyListening) {
      return;
    }
    alreadyListening = true;
    _actionStreamSubscription = AwesomeNotifications().actionStream.listen(
      (message) async {
        if (message.buttonKeyPressed.startsWith("accept")) {
          console.log("Call Accepted");
          await Permission.camera.request();
          await Permission.microphone.request();
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => VideoCallScreen(
                channelName: message.buttonKeyPressed
                    .split("-")[1], // Rookie Doctor Code Whos Calling
              ),
            ),
          );
        } else if (message.buttonKeyPressed == "decline") {
          console.log("Call Decline");
          // decline call
        }
      },
    );
  }
}
