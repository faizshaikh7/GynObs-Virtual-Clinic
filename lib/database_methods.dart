import 'dart:developer' as console;
import 'package:agp_ziauddin_virtual_clinic/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String colName, String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection(colName)
        .doc(userId)
        .set(userInfoMap);
  }

  Future updateUserInfoToDB(
      String colName, String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection(colName)
        .doc(userId)
        .update(userInfoMap);
  }

  // getUserInfoFromDB() async {
  //   var currentUserUID = await FirebaseAuth.instance.currentUser!.uid;
  //   console.log("this is your UID $currentUserUID");
  //   print("this is your UID $currentUserUID");

  //   print("After");
  //   CollectionReference users =
  //       FirebaseFirestore.instance.collection("doctors");

  //   return FutureBuilder<DocumentSnapshot>(
  //     future: users.doc(currentUserUID).get(),
  //     builder: ((context, snapshot) {
  //       print("yoooo");
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         Map<String, dynamic> data =
  //             snapshot.data!.data() as Map<String, dynamic>;
  //         console.log(
  //             "work in this Hospital : ${data['hospital'] ?? 'danbdjahdjaeoudoa'}");
  //         print(
  //             "work in this Hospital : ${data['hospital'] ?? 'danbdjahdjaeoudoa'}");
  //       }
  //       console.log("Failed To Fetch Data");
  //       print("Failed To Fetch Data");
  //       return Container();
  //     }),
  //   );
  // }

  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getPatients() async {
    return FirebaseFirestore.instance
        .collection("patients")
        .where("doctor_email", isEqualTo: prefs!.getString("email"))
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatroom() async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .where("userIds", arrayContains: prefs!.getString("id"))
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getPatientReports() async {
    return FirebaseFirestore.instance
        .collection(
            prefs!.getString("type") == "Doctor" ? "reports" : "precriptions")
        .where(
            prefs!.getString("type") == "Doctor" ? "doctor_id" : "patient_id",
            isEqualTo: prefs!.getString("id"))
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getDoctors() async {
    return FirebaseFirestore.instance.collection("doctors").snapshots();
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> searchCategoriesByPrice(
      String colName, int price) async {
    return FirebaseFirestore.instance
        .collection(colName)
        // .where("price", isGreaterThanOrEqualTo: price+100000)
        .where("price", isLessThan: price)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getCollection(String col) async {
    return FirebaseFirestore.instance.collection(col).snapshots();
  }

  Future<Stream<QuerySnapshot>> getMultiCollection(
      String col1, String col2, String doc) async {
    return FirebaseFirestore.instance
        .collection(col1)
        .doc(doc)
        .collection(col2)
        .orderBy("ts", descending: false)
        .snapshots();
  }
}
