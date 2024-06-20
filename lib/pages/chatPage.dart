import 'dart:async';
import 'package:do_an_tot_nghiep/pages/group_chat.dart';
import 'package:page_transition/page_transition.dart';
import 'package:do_an_tot_nghiep/pages/chatroom.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Stream<QuerySnapshot>? listChatRoom , listGroupChat;
  StreamSubscription? _currentStreamSubscription;
  String? id ;
  bool swapChat =true;
  onLoad()async{
    id=await SharedPreferenceHelper().getIdUser();
    listChatRoom = DatabaseMethods().getChatRooms(id!);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    onLoad();
  }
  @override
  void dispose() {
    _currentStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadStream;
    loadStream = StreamBuilder<QuerySnapshot>(stream: listChatRoom,
        builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return Column(
              children: snapshot.data!.docs.map((data){
                String contact;
                String nameGroup , nameSend;
                try{
                  contact =data.get("UserContact");
                }
                catch(e){
                  contact="";
                }
                 try{
                   nameGroup =data.get("NameGroup");
                 }
                 catch(e){
                   nameGroup="";
                 }
                try{
                  nameSend =data.get("userSent");
                }
                catch(e){
                  nameSend="";
                }
                return ChatRoom(chatRoomId: data["ID"], lastMessage: data["LastMessage"], idUser: contact, time: data["Time"].toString(),nameGroup: nameGroup,nameSend: nameSend,);
              }).toList(),
            );
          }else{
            return Text("No data");
          }
        }
    );
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
                    icon: Icon(Icons.arrow_back_rounded,size: 30,)),
                Text("Đoạn chat",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700),)
              ],
            ),
           IconButton(onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupChat()));
           }, icon: Icon(Icons.group_add_outlined,size: 30,))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300,
              ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            helperMaxLines: 1,
                            hintText: "Tìm kiếm",
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                          onChanged: (value){
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            //Stream để ở đây

          
            Container(
              child: loadStream,
            ),
          ],
        ),
      ),
      bottomNavigationBar:BottomAppBar(
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                children: [
                  GestureDetector(
                      onTap:(){
                        setState(() {
                          swapChat =!swapChat;
                          listChatRoom = DatabaseMethods().getChatRooms(id!);
                        });
                      },
                      child: Icon(Icons.messenger_outline ,color: swapChat ? Colors.blue :Colors.black,)),
                  Text("Đoạn chat" , style: TextStyle(color: swapChat ? Colors.blue :Colors.black,),),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      setState(() {
                        swapChat =!swapChat;
                        listChatRoom = DatabaseMethods().getGroupChatStream(id!);
                        //print(listChatRoom!.isEmpty);
                      });
                    },
                    child: Icon(Icons.people ,color: !swapChat ? Colors.blue :Colors.black,)),
                Text("Nhóm" , style: TextStyle(color: !swapChat ? Colors.blue :Colors.black,),),
              ],
            ),
          ],
        ),
      )
    );
  }
}
