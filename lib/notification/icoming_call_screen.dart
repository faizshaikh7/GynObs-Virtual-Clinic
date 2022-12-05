import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({Key? key}) : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "Dr Sama Rais",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Incoming Video Call...",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 350,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: Icon(Icons.call_end, size: 35),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(80, 80),
                          shape: const CircleBorder(),
                          backgroundColor: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 125,
                      ),
                      ElevatedButton(
                        child: Icon(Icons.call_sharp, size: 35),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(80, 80),
                          shape: const CircleBorder(),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
