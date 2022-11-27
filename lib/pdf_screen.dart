import 'package:agp_ziauddin_virtual_clinic/constants/colors.dart';
import 'package:agp_ziauddin_virtual_clinic/database_methods.dart';
import 'package:agp_ziauddin_virtual_clinic/play_video_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/view_pdf_screen.dart';
import 'package:agp_ziauddin_virtual_clinic/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  var videosStream;
  doOnLaunch() async {
    videosStream = await DatabaseMethods()
        .getMultiCollection("training", "pdfs", "rKGOeINxIqKzz1rABcrG");
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
      appBar: AppBar(elevation: 0, title: Text("Pdfs")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: videosStream,
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? snapshot.data!.docs.length == 0
                    ? Center(child: boldText("No Pdfs", 16))
                    : ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () async {
                             
                             goto(context, ViewPdfScreen(url: ds["pdf_url"]));
                            },
                            child: Card(
                              color: white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: grey2!)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf,size: 22,color: red,),
                                    HSpace(20),
                                    boldText(ds["title"], 18),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }))
                : Center(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
