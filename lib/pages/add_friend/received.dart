import 'dart:async';
import 'package:do_an_tot_nghiep/pages/add_friend/friend.dart';
import 'package:do_an_tot_nghiep/pages/add_friend/hintfriend.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/receiveddettail.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/user.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Received extends StatefulWidget {
  const Received({super.key});

  @override
  State<Received> createState() => _FriendsState();
}

class _FriendsState extends State<Received> {
  Stream<QuerySnapshot>? getListReceived;
  String id="";
  onLoad()async{
  id= (await SharedPreferenceHelper().getIdUser())! ;
  getListReceived= DatabaseMethods().getReceived(id);
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
          title:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child:  Center(

                child: Text("Bạn bè",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              ),

              Icon(
                Icons.search,
              )
            ],
          ) ,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: ()
                            async {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>HintFriend()));
                            },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                      ),
                          child: Text("Gợi ý",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black
                          ),
                          )
                      ),
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: ()
                          {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>Friends()));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),

                          ),
                          child: Text("Bạn bè",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black
                            ),
                          )
                      ),
                    ],
                  ),
                ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            getReceived(),
            //getHint()
           // getFriends()
      ]
    )
    )
    );
  }
Widget getReceived(){
    return StreamBuilder<QuerySnapshot>(
        stream: getListReceived,
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot)    {
         if (snapshot.connectionState == ConnectionState.waiting) {
         return CircularProgressIndicator();
         }
         if (snapshot.hasError) {
         return Center(child: Text("lỗi ròi"));
         }
         if(snapshot.data == null ||snapshot.data!.docs.isEmpty){
           return Center(child: Text("bạn chưa có lời mời kết bạn nào"));
         }
          // print("kiemtra: ${snapshot.data!.docs[0]["id"]}");
           return snapshot.hasData?
             Container(
             height: MediaQuery.of(context).size.height,
             //MediaQuery.of(context).size.height,
                 child:  Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(10),
                       child: Row(
                         children: [
                           Expanded(
                             child: Text(
                               "Lời mời kết bạn ${snapshot.data!.docs.length} ",
                               style: TextStyle(
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     ListView.builder(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
                         itemCount: snapshot.data!.docs.length, // Số lượng mục trong ListView
                         itemBuilder: (BuildContext context, int index) {
                           Map<String, dynamic> data =snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            print("data $data");
                           print("id trước khi vào:${data["id"]}");
                         return ReceivedDetail( key: ValueKey(data["id"]),idReceived: data["id"]);
                         }
                     ),

                   ],
                 )

           ):Center(child: Text("bị lỗi rồi"));
         }

   );
 }
}




