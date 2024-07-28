import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatWithGemini extends StatefulWidget {
  final String chatRoomId;
  const ChatWithGemini({super.key , required this.chatRoomId});

  @override
  State<ChatWithGemini> createState() => _ChatWithGeminiState();
}

class _ChatWithGeminiState extends State<ChatWithGemini> {
  TextEditingController questionController = TextEditingController();
  final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: "AIzaSyBilZaA-VH8wpnhQxPqkBhYpEORWsU8pks",
      generationConfig: GenerationConfig(maxOutputTokens: 100));
  String? myId;
  String myName="";
  List<Content> chatHistory = [];
  Stream<QuerySnapshot>? messRoom;
  
  getInfoUser(String id)async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(id).get();
    myName =  data.get("Username");

  }

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    await getInfoUser(myId!);
    messRoom = FirebaseFirestore.instance.collection("gemini").doc(myId).collection("chats").orderBy('timestamp' ,descending: true).snapshots();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final snapshot = await FirebaseFirestore.instance.collection("gemini").doc(myId).collection("chats").orderBy('timestamp' ,descending: true).snapshots().first;
    final historyData = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      chatHistory = historyData.map((messageData) {
        final question = messageData['question'];
        final answer = messageData['answer'];
        final role = messageData['role'];
        if (role == 'user') {
          return Content.text(question);
        } else {
          return Content.model([TextPart(answer)]);
        }
      }).toList();
    });

  }
  Future<void> _sendMessage(String message) async {
    final chat = model.startChat(history: chatHistory);
    final response = await chat.sendMessage(Content.text(message));
    await saveChatMessage(myId!, message, response.text.toString(), 'user');
    setState(() {
      chatHistory.add(Content.text(message));
      chatHistory.add(Content.model([TextPart(response.text.toString())]));
    });
    // chatHistory.add(Content.text(message));
    // chatHistory.add(Content.model([TextPart(response.text.toString())]));
    questionController.clear();
  }
  Future<void> saveChatMessage(String userId, String question, String answer, String role) async {
    await FirebaseFirestore.instance.collection("gemini").doc(myId).collection("chats").add({
      'question': question,
      'answer': answer,
      'role': role,
      'timestamp': DateTime.now(),
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_rounded,size: 30,color: Colors.blueGrey)),
                Text("Gemini",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700 , color: Colors.blueGrey),)
              ],
            ),
            IconButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Xác nhận!"),
                  content: Text("Bạn muốn làm mới cuộc trò chuyện với Gemini , cuộc trò chuyện trước đây sẽ mất và không thể"
                      " quay lại"),
                  actions: [
                    TextButton(onPressed: ()async{
                      QuerySnapshot data = await FirebaseFirestore.instance.collection("gemini").doc(myId).collection("chats").get();
                      for(int i=0;i < data.docs.length ;i++){
                        String id = data.docs[i].id;
                        await FirebaseFirestore.instance.collection("gemini").doc(myId)
                        .collection("chats").doc(id).delete().then((e){
                          setState(() {
                            chatHistory =[];
                          });
                        });
                      }
                      Navigator.of(context).pop();
                    }, child: Text("Ok")),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("Cancel"))
                  ],
                );
              });
            }, icon: Icon(CupertinoIcons.add_circled_solid,size: 30,color: Colors.blueGrey,))
          ],
        ),
      ),

      body:Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: messRoom ,
          builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData){
              return Center(child: Text("Hãy đặt câu hỏi cho gemini"),);
            }
            if(snapshot.data!.size==0){
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Xin chào $myName!" , style: TextStyle(
                        fontSize: 20,color: Colors.teal
                      ),),
                      Text("Hôm nay tôi có thể giúp gì cho bạn?",style: TextStyle(
                        fontSize: 18 , color: Colors.black38
                      ),)
                    ],
                  ));
            }else{
              return ListView.builder(
                padding: EdgeInsets.only(left: 10),
                reverse: true,
                itemCount:  snapshot.data!.size,
                itemBuilder: (context , index){
                  DocumentSnapshot ds= snapshot.data!.docs[index];
                  return MessageDetail(key:ValueKey(ds["timestamp"]) , question: ds["question"],answer: ds["answer"],);
                },
              );
            }
          },
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: MediaQuery.of(context).viewInsets.bottom+20,),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:Colors.white
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.4,
              child: TextField(
                controller: questionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Hãy nhập câu hỏi của bạn',
                ),
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              onPressed: () {
                _sendMessage(questionController.text);
              },
              icon: Icon(Icons.send),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );

  }
}

class MessageDetail extends StatefulWidget {
  final String question , answer;
  const MessageDetail({super.key , required this.question, required this.answer});

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question from user
          Align(
            alignment: Alignment.centerRight,
            child: ChatBubble(
              message: widget.question,
              isUserMessage: true,
            ),
          ),
          SizedBox(height: 5),
          // Answer from Gemini
          Align(
            alignment: Alignment.centerLeft,
            child: ChatBubble(
              message: widget.answer,
              isUserMessage: false,
            ),
          ),
        ],
      ),
    );
  }
}
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: isUserMessage ? Colors.blueAccent : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isUserMessage ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }
}