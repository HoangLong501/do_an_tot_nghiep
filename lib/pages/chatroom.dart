import 'package:do_an_tot_nghiep/pages/chat_with_gemini.dart';
import 'package:do_an_tot_nghiep/pages/message.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class ChatRoom extends StatefulWidget {
  final String chatRoomId ,lastMessage ,  idUser , time ,nameGroup ,nameSend;

  const ChatRoom({super.key , required this.chatRoomId,required this.lastMessage,required this.idUser,required this.time , this.nameGroup="" ,this.nameSend="" });
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String image="" ,contactUser="", name="" , lastMess="";
  String timeNow ="";
  String? myId,myName;

  String getUsernameFromChatRoomId(String chatRoomId, String myUsername) {
    List<String> parts = chatRoomId.split("_");
    String otherUsername = parts.firstWhere((element) => element != myUsername);
    return otherUsername;
  }
  getDataUser()async{

  }
  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    myName = await SharedPreferenceHelper().getUserName();
    if(widget.idUser!=""){
      contactUser =widget.chatRoomId.split(myId!).join("");
      if (contactUser.endsWith("_")) {
        contactUser = contactUser.substring(0, contactUser.length - 1);
      }
      if (contactUser.startsWith("_")) {
        contactUser = contactUser.substring(1, contactUser.length );
      }
      print(contactUser);
      DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(contactUser).get();
      image = data.get("imageAvatar");
      name = data.get("Username");
    }
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
        if(widget.nameGroup==""){
          if(widget.idUser=="openai"){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatWithGemini(chatRoomId: widget.chatRoomId,)));
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Message(contactUser: contactUser,group: false,name: name, image: image, chatRoomId: widget.chatRoomId)));
          }

        }else{
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Message(contactUser: contactUser,group: true,name: widget.nameGroup, image: "", chatRoomId: widget.chatRoomId)));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.idUser==""?CircleAvatar(
              radius: 32,
              backgroundColor: WidgetStateColor.resolveWith((states) => Colors.blue,),
            ) :CircleAvatar(
              radius: 32,
              backgroundImage: image!="" ?Image.network(image).image : Image.asset("assets/images/logo.png").image ,
            ),
            SizedBox(width: 14,),
            // TextButton(onPressed: (){
            //   print(widget.chatRoomId);
            //   print(widget.nameGroup);
            //   print(widget.lastMessage);
            //   print(widget.time);
            // }, child: Text("3")),
            SizedBox(
              width: MediaQuery.of(context).size.width/2.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.nameGroup!=""? widget.nameGroup : name, style: TextStyle(color: Colors.black,fontSize: 20 , fontWeight: FontWeight.w500),),
                    ],
                  ),
                 widget.nameSend!=""? Text( "${widget.nameSend} : ${widget.lastMessage}",overflow:TextOverflow.ellipsis, style: TextStyle(color: Colors.black45,fontSize: 18),):
                 Text( widget.lastMessage,overflow:TextOverflow.ellipsis, style: TextStyle(color: Colors.black45,fontSize: 18),)
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
