import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../service/database.dart';
import '../service/shared_pref.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController questionController = TextEditingController();
  String? myId;

  onLoad()async{
    // final model = GenerativeModel(
    //   model: 'gemini-1.5-flash',
    //   apiKey: "AIzaSyBilZaA-VH8wpnhQxPqkBhYpEORWsU8pks",
    // );
    // final prompt = 'Xin chào , bạn có biết tiếng Việt không';
    //
    // final response = await model.generateContent([Content.text(prompt)]);
    // print(response.text);
    // myId = await SharedPreferenceHelper().getIdUser();
    // String idRoomChat = SharedPreferenceHelper().getChatRoomIdUserName("openai", myId!);
    // String theme = Colors.cyan.shade200.value.toString();
    // Map<String , dynamic> chatRoomInfoMap={
    //   "LastMessage":"Tôi là trợ lý ảo , bạn có thể hỏi tôi hoặc tâm sự với tôi",
    //   "UserContact":"openai",
    //   "ID":idRoomChat,
    //   "Time":DateTime.now().toString(),
    //   "user":[myId,"openai"],
    //   "Theme":theme,
    // };
    // print(chatRoomInfoMap);
    // DatabaseMethods().createChatRoom(idRoomChat, chatRoomInfoMap);

    setState(() {

    });
  }


  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Interaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: 'Enter your question',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // if (questionController.text.isNotEmpty) {
                //   _getResponse(_controller.text);
                // }
              },
              child: Text('Get Response'),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
