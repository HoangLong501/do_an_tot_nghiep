import 'dart:convert';

import 'package:http/http.dart' as http;


class  NotificationDetail {
  Future<void> sendAndroidNotification(
      authorizedSupplierTokenId, body , tittle) async {
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
              'title': tittle,
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