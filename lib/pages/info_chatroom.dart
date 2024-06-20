import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/member_chat.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
class InfoChatroom extends StatefulWidget {
  final String idChatRoom;
  const InfoChatroom({super.key , required this.idChatRoom});

  @override
  State<InfoChatroom> createState() => _InfoChatroomState();
}

class _InfoChatroomState extends State<InfoChatroom> {
  List members=[];
  String image="" , nameChat="";
  String? myId;
  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).get();
    nameChat = data.get("NameGroup");
    members = data.get("user");
    try{
      image = data.get("image");
    }
    catch(e){
      image="";
    }
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
        //backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_rounded, size: 30,)),
                ],
              ),
            ),
            IconButton(onPressed: (){


            }, icon: Icon(CupertinoIcons.ellipsis_vertical)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: image=="" ? Center(
                  child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 60,
                  ),
                ) :Center(
                child: CircleAvatar(
                  backgroundImage: Image.network(image).image,
                  radius: 60,
                  ),
               ) ,
              ),
            Center(child: Text(nameChat , style: TextStyle(fontSize: 28 , fontWeight: FontWeight.w500),)),
            Text("Tùy chỉnh" , style: TextStyle(fontSize: 16,color: Colors.grey),),
            Row(
              children: [
                Icon(CupertinoIcons.circle_lefthalf_fill,size: 30 , color: Colors.blue,),
                SizedBox(width: 20,),
                Text("Chủ đề" , style: TextStyle(fontSize: 18),),
              ],
            ),
            Row(
              children: [
                Icon(CupertinoIcons.textformat_abc,size: 30 , color: Colors.blue,),
                SizedBox(width: 20,),
                Text("Tên group" , style: TextStyle(fontSize: 18),),
              ],
            ),
            Row(
              children: [
                Icon(CupertinoIcons.pencil_ellipsis_rectangle,size: 30 , color: Colors.blue,),
                SizedBox(width: 20,),
                Text("Biệt danh" , style: TextStyle(fontSize: 18),),
              ],
            ),
            Text("Thông tin về đoạn chat" , style: TextStyle(fontSize: 16,color: Colors.grey),),
           TextButton(
             onPressed: (){
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MemberChat(idChatRoom: widget.idChatRoom,)));
             },
             child: Row(
                  children: [
                    Icon(CupertinoIcons.person_2_fill,size: 30 , color: Colors.blue,),
                    SizedBox(width: 20,),
                    Text("Xem thành viên" , style: TextStyle(fontSize: 18),),
                  ],
              ),
           ),
            Text("Rời khỏi đoạn chat" , style: TextStyle(fontSize: 16,color: Colors.grey),),
            TextButton(
              onPressed: (){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text("Hãy xác nhận !"),
                        content: Text("Bạn muốn rời khỏi nhóm chat này"),
                        actions: [
                          TextButton(onPressed: (){
                              Navigator.of(context).pop();
                          }, child: Text("Cancel")),
                          TextButton(onPressed: ()async{
                            print(myId);
                            print(members);
                            members.remove(myId);
                            print(members);
                            Map<String , dynamic> updateMember={
                              "user":members
                            };
                            await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).update(updateMember);
                            // Đóng hộp thoại trước

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            // Sử dụng Future.delayed để đảm bảo hộp thoại đã đóng trước khi điều hướng

                          }, child: Text("Oke")),
                        ],
                      );
                    });
              },
              child: Row(
                children: [
                  Icon(Icons.exit_to_app_outlined,size: 30 , color: Colors.red,),
                  SizedBox(width: 20,),
                  Text("Rời khỏi đoạn chat" , style: TextStyle(fontSize: 18 , color: Colors.red),),
                ],
              ),
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }


}
