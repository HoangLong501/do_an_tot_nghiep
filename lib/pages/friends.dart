import 'dart:async';

import 'package:do_an_tot_nghiep/pages/lib_class_import/user.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  Stream<QuerySnapshot>? getListReceived;
 // List<String> listReceiveds=[];
  Stream<QuerySnapshot>? listReceived;
  String id="";
  bool hidden_accept=true;
  bool addFriends=true;

  List<Person> listFriends=[];
  onLoad()async{
    id= (await SharedPreferenceHelper().getIdUser())! ;

   // print(getListReceived!.length);
 //  listReceived=  DatabaseMethods().getListUserReceive(getListReceived!) ;

//print(listReceived);
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
                      StreamBuilder(stream: DatabaseMethods().getReceived(id),
                          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                             if(snapshot.hasData){
                               Text(snapshot.data!.docs[0]["id"]??"Null");
                             }else{
                               return SizedBox();
                             }
                             return SizedBox();
                          }),
                      SizedBox(width: 10,),
                      TextButton(
                          onPressed: ()
                          {

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
            //getReceived(),
            //getHint()
           // getFriends()
      ]
    )
    )
    );
  }
// Widget getReceived(){
//     return StreamBuilder<QuerySnapshot>(
//         stream: listReceived,
//         builder: (context,AsyncSnapshot<QuerySnapshot> snapshot)    {
//           print(snapshot.data!.size);
//          if (snapshot.connectionState == ConnectionState.waiting) {
//          return Center(child: CircularProgressIndicator());
//          } else if (snapshot.hasError) {
//          return Center(child: CircularProgressIndicator());
//          } else {
//            return Container(
//              height: MediaQuery.of(context).size.height,
//                  child:  Column(
//                    children: [
//                      Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Row(
//                          children: [
//                            Expanded(
//                              child: Text(
//                                "Lời mời kết bạn ${snapshot.data!.docs.length} ",
//                                style: TextStyle(
//                                  fontSize: 20,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      ListView.builder(
//                          shrinkWrap: true,
//                          physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
//                          itemCount: snapshot.data!.docs.length, // Số lượng mục trong ListView
//                          itemBuilder: (BuildContext context, int index) {
//                            Map<String, dynamic> data =snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                            print(data);
//                            return GestureDetector(
//                              onTap: (){
//
//                              },
//                              child: Padding(
//                                padding: const EdgeInsets.all(10.0),
//                                child: Row(
//                                  children: [
//                                    Container(
//                                      height: 100,
//                                      child: CircleAvatar(
//                                        radius: 50,
//                                        backgroundImage: NetworkImage(data["imageAvatar"],
//                                     ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(10.0),
//                                      child: Column(
//                                        mainAxisAlignment: MainAxisAlignment.start,
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: [
//                                          Container(
//                                            padding: const EdgeInsets.only(left: 3),
//                                            alignment:Alignment.centerLeft,
//                                            child: Text(
//                                              data["Username"],
//                                              textAlign: TextAlign.left,
//                                              style: TextStyle(
//                                                  fontSize: 16,
//                                                  fontWeight: FontWeight.bold
//                                              ),
//                                            ),
//                                          ),
//                                          Container(
//                                            child: Text(
//                                              " $index bạn chung",
//                                              style: TextStyle(
//                                                  fontSize: 14,
//                                                  fontWeight: FontWeight.w300
//                                              ),
//                                            ),
//                                          ),
//                                          Row(
//                                            children: [
//                                              // if(!)
//                                              Container(
//                                                  width: MediaQuery.of(context).size.width/3 -7,
//                                                  // decoration: BoxDecoration(
//                                                  //   borderRadius: BorderRadius.circular(10.0),
//                                                  // ),
//                                                  child:addFriends?
//                                                  TextButton(
//                                                    onPressed: () async
//                                                    {
//                                                      Map<String,dynamic> receivedInfoMap={
//                                                        "id":id,
//                                                        "status":"friend"
//                                                      };
//                                                      Map<String,dynamic> requestInfoMap={
//                                                        "id":data["Id"],
//                                                        "status":"friend"
//                                                      };
//                                                       DatabaseMethods().addFriends(id, data["Id"], receivedInfoMap);
//                                                      DatabaseMethods().addFriends(data["Id"],id , requestInfoMap);
//                                                      setState(() {
//                                                        addFriends=false;
//                                                      });
//                                                    },
//                                                    style:  ButtonStyle(
//                                                      backgroundColor:MaterialStateProperty.all<Color>(Colors.blue.shade800),
//                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                        RoundedRectangleBorder(
//                                                          borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây
//
//                                                        ),
//                                                      ),
//                                                    ),
//
//                                                    child: Text("Chấp nhận",
//                                                      style: TextStyle(
//                                                          fontSize: 16,
//                                                          color: Colors.white
//                                                      ),
//                                                    ),
//                                                  ): TextButton(
//                                                    onPressed: () async
//                                                    {
//
//                                                    },
//                                                    style:  ButtonStyle(
//                                                      backgroundColor:MaterialStateProperty.all<Color>(Colors.grey.shade400),
//                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                        RoundedRectangleBorder(
//                                                          borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây
//
//                                                        ),
//                                                      ),
//                                                    ),
//
//                                                    child: Text("Bạn bè",
//                                                      style: TextStyle(
//                                                          fontSize: 16,
//                                                          color: Colors.black
//                                                      ),
//                                                    ),
//                                                  )
//
//                                              ),
//                                              SizedBox(width: 10,),
//                                              Container(
//                                                width: MediaQuery.of(context).size.width/3 -6,
//                                                // decoration: BoxDecoration(
//                                                //   borderRadius: BorderRadius.circular(10.0),
//                                                // ),
//                                                child: TextButton(
//                                                    onPressed: ()
//                                                    {
//                                                    },
//                                                    style: ButtonStyle(
//                                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
//                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                        RoundedRectangleBorder(
//                                                          borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây
//
//                                                        ),
//                                                      ),
//                                                    ),
//                                                    child: Text("Xóa",
//                                                      style: TextStyle(
//                                                          fontSize: 16,
//                                                          color: Colors.black
//                                                      ),
//                                                    )
//                                                ),
//                                              ),
//                                            ],
//                                          )
//                                        ],
//                                      ),
//                                    )
//                                  ],
//                                ),
//                              ),
//                            );
//                          }
//                      ),
//                    ],
//                  )
//
//            );
//          }
//         },
//
//    );
//  }
}




 // Widget getFriends(){
 //
 //     return Column(
 //       children: [
 //         Padding(
 //           padding: const EdgeInsets.all(15.0),
 //           child: Row(
 //             children: [
 //               Expanded(
 //                 child: Text(
 //                   "${listFriends.length} bạn bè",
 //                   style: TextStyle(
 //                     fontSize: 20,
 //                     fontWeight: FontWeight.bold,
 //                   ),
 //                 ),
 //               ),
 //
 //             ],
 //           ),
 //         ),
 //
 //         ListView.builder(
 //             shrinkWrap: true,// Đảm bảo ListView chính tự co lại vừa đủ với nội dung
 //             physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
 //             itemCount: listFriends.length, // Số lượng mục trong ListView
 //             itemBuilder: (BuildContext context, int index) {
 //               return GestureDetector(
 //                 onTap: (){
 //                 },
 //                 child: Padding(
 //                   padding: const EdgeInsets.only(left: 5,bottom: 10),
 //                   child: Row(
 //                     children: [
 //                       Container(
 //                         height: 70,
 //                         child: CircleAvatar(
 //                           radius: 50,
 //                           backgroundImage: NetworkImage(listFriends[index].image,
 //                           ),
 //                         ),
 //                       ),
 //                       Padding(
 //                         padding: const EdgeInsets.only(left: 5),
 //                         child: Column(
 //                           mainAxisAlignment: MainAxisAlignment.start,
 //                           crossAxisAlignment: CrossAxisAlignment.start,
 //                           children: [
 //                             Container(
 //                               padding: const EdgeInsets.only(left: 3),
 //                               alignment:Alignment.centerLeft,
 //                               child: Text(
 //                                 textAlign: TextAlign.left,
 //                                 listFriends[index].username,
 //                                 style: TextStyle(
 //                                     fontSize: 16,
 //                                     fontWeight: FontWeight.bold
 //                                 ),
 //                               ),
 //                             ),
 //                             Container(
 //                               child: Text(
 //                                 " $index bạn chung",
 //                                 style: TextStyle(
 //                                     fontSize: 14,
 //                                     fontWeight: FontWeight.w300
 //                                 ),
 //                               ),
 //                             ),
 //
 //                           ],
 //                         ),
 //                       )
 //                     ],
 //                   ),
 //                 ),
 //               );
 //             }
 //         ),
 //
 //       ],
 //     );
 //   }


