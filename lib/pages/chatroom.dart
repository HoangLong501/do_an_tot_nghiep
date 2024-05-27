import 'package:do_an_tot_nghiep/pages/message.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class ChatRoom extends StatefulWidget {
  final String chatRoomId ,lastMessage ,  idUser , time;

  const ChatRoom({super.key , required this.chatRoomId,required this.lastMessage,required this.idUser,required this.time});
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String image="" ,contactUser="", name="" , lastMess="";
  String timeNow ="";
  String? myId;

  String getUsernameFromChatRoomId(String chatRoomId, String myUsername) {
    List<String> parts = chatRoomId.split("_");
    String otherUsername = parts.firstWhere((element) => element != myUsername);
    return otherUsername;
  }
  getDataUser()async{

  }
  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    contactUser =widget.chatRoomId.split("${myId!}_").join("").toString();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(contactUser).get();
    image = data.get("imageAvatar");
    print("anh avatar ${data.get("imageAvatar")}");
    name = data.get("Username");
    lastMess = widget.lastMessage;
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
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Message(name: name, image: image, chatRoomId: widget.chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: image!="" ?Image.network(image).image : Image.asset("assets/images/logo.png").image ,
            ),
            SizedBox(width: 14,),
            SizedBox(
              width: MediaQuery.of(context).size.width/2.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(color: Colors.black,fontSize: 20 , fontWeight: FontWeight.w500),),
                    ],
                  ),
                  Text(widget.lastMessage,overflow:TextOverflow.ellipsis, style: TextStyle(color: Colors.black45,fontSize: 18),)
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20,top: 10),
                child: Text(DateFormat('h:mma').format(DateTime.parse(widget.time)), style: TextStyle(color: Colors.black45,fontSize: 16),))
          ],
        ),
      ),
    );
  }
}
