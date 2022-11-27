

import 'package:agp_ziauddin_virtual_clinic/constants/colors.dart';
import 'package:agp_ziauddin_virtual_clinic/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        title: Text("About Us"),
      ),
      
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // boldText("SOFTSOLS PAKISTAN", 20),
                // Text(
                //   "Quality | Technology | Innovation | Customer Satisfaction | Win together",
                //   style: TextStyle(color: blue, fontSize: 18),
                //   textAlign: TextAlign.center,
                // ),
                Text(
                  "AGP Limited and Ziauddin University Hospital have taken the initiative to disseminate knowledge regarding Emergency Obstetric and Neonatal Care to the Doctors serving at primary care centers.To serve this purpose ZU has collaborated with AGP to build a mobile application for conducting EMNOC workshops and bridging primary and secondary care centers. Our main objective is to improve the provision of quality care at primary care centers in order to reduce the burden of maternal and neonatal morbidity and mortality in Pakistan",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
