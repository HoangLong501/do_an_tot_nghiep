import 'dart:async';

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

  Stream<QuerySnapshot>? listChatRoom;
  String? id ;
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
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.menu,size: 28,),
                    ),
                ),
                SizedBox(width: 20,),
                Text("Đoạn chat",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700),)
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.mode_edit_outline_sharp,size: 28,),
              ),
            ),
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
            StreamBuilder<QuerySnapshot>(
                stream: listChatRoom,
                builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return Column(
                        children: snapshot.data!.docs.map((data){
                          return ChatRoom(chatRoomId: data["ID"], lastMessage: data["LastMessage"], idUser: data["UserContact"], time: data["Time"]);
                        }).toList(),
                      );
                    }else{
                      return Text("No data");
                    }
                      return Text("Failed access Firebase");
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar:BottomAppBar(
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.messenger_outline),
                Text("Đoạn chat"),
              ],
            ),
            Column(
              children: [
                Icon(Icons.people),
                Text("Danh bạ"),
              ],
            ),
            Column(
              children: [
                Icon(Icons.newspaper_outlined),
                Text("Tin"),
              ],
            ),
          ],
        ),
      )
    );
  }
}
