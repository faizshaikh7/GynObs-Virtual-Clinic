import 'dart:async';
import 'package:agp_ziauddin_virtual_clinic/main.dart';
import 'package:agp_ziauddin_virtual_clinic/video_call_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as console;

import 'package:flutter/material.dart';

class CustomAwesomeNotification {
  StreamSubscription<ReceivedAction>? _actionStreamSubscription;

  void listen(context) async {
    await _actionStreamSubscription?.cancel();

    _actionStreamSubscription = AwesomeNotifications().actionStream.listen(
      (message) {
        if (message.buttonKeyPressed.startsWith("accept")) {
          console.log("Call Accepted");
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => VideoCallScreen(
                channelName: callerRoomID, // Rookie Doctor Code Whos Calling
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
