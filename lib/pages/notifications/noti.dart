import 'dart:convert';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class  NotificationDetail {

  Future sendNotificationToAnyDevice(String idUserNeedTake , String body , String title)async{
    List token=[];
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(idUserNeedTake).get();
    token = data.get("tokens");
    for (var element in token) {
      await sendAndroidNotification(element, body, title);
    }
  }
  Future sendNotificationToGroupChat(String idGroupChat, String body , String title)async{
    String? myId;
    myId = await SharedPreferenceHelper().getIdUser();
    List users=[];
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("groupChat").doc(idGroupChat).get();
    users = data.get("user");
    users.remove(myId);
    for (var user in users) {
      print(user);
        await sendNotificationToAnyDevice(user, body, title);
    }
  }

  Future<void> sendAndroidNotification(authorizedSupplierTokenId, body , title) async {
    try {
      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAArhGvuPY:APA91bGy-dlbPhsKYFrUDaWgo8qCFlZrBXEoNm6JBnkIKoznJ18KTK4FA6Sh5ng-AQRFyyaHU6IhB1T7kEyubXr4ApaCjYmgj5Q5isilX08VWf-Vo19lDbqQvV7wsanG3itSQOYeloDU',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': authorizedSupplierTokenId,
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }


}