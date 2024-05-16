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
  Stream<List<String>>? getListReceived;
  List<String> listReceiveds=[];
  List<Person> listReceived=[];
  String id="";
  bool hidden_accept=true;
  bool addFriends=true;
  Stream<List<Person>>? getListUsersHint;
  List<Person> listUserHint=[];
  List<Person>listAllUsers=[];
  List<String> listRequest=[];
  List<String> getlistIdFriends=[];

  List<Person> listFriends=[];
onLoad()async{
  id= (await SharedPreferenceHelper().getIdUser())!;
  getListReceived=await DatabaseMethods().getReceive(id);
  listAllUsers=await DatabaseMethods().getUser();
  getListUsersHint=await DatabaseMethods().getHideHintsUsers(id, listAllUsers);
  await for(List<Person> list in getListUsersHint!){
    listUserHint=list;
  }
  await for(List<String> list in getListReceived!){
        listReceiveds=list;
  }
  for(String idReceived in listReceiveds) {
    //print(idReceived);
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(idReceived);
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      Person user = Person.fromJson(userData);
      listReceived.add(user);
    }
  }
  // print(listReceived);
   print(listReceived.length);
listRequest=await DatabaseMethods().getRequest(id);
  getlistIdFriends=await DatabaseMethods().getFriends(id);
  for(String idUser in getlistIdFriends){
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(idUser);
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      Person user = Person.fromJson(userData);
      listFriends.add(user);
    }
  }
 // print(listFriends);
  //print(listReceived);
  //print(listReceived.length);
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
                            {

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Lời mời kết bạn ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Xem tất cả",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
            itemCount: listReceived.length, // Số lượng mục trong ListView
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(listReceived[index].image,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment:Alignment.centerLeft,
                              child: Text(
                                textAlign: TextAlign.left,
                                listReceived[index].username,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                " $index bạn chung",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            ),
                            Row(
                              children: [
                               // if(!li)
                                Container(
                                  width: MediaQuery.of(context).size.width/3 -7,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),
                                  child:
                                    TextButton(
                                      onPressed: () async
                                      {
                                         DatabaseMethods().requestFriend(id,listReceived[index].id);
                                        setState(() {
                                          });
                                        },
                                      style:  ButtonStyle(
                                        backgroundColor:MaterialStateProperty.all<Color>(Colors.blue.shade800),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây

                                            ),
                                      ),
                                      ),

                                      child: Text("Chấp nhận",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white
                                        ),
                                      ),
                                  )
                                  ),
                                SizedBox(width: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width/3 -6,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),
                                  child: TextButton(
                                      onPressed: ()
                                      {
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây

                                          ),
                                        ),
                                      ),
                                      child: Text("Xóa",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ],
    );
 }
 Widget getHint(){
   return Column(
     children: [
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Row(
           children: [
             Expanded(
               child: Text(
                 "Những người bạn có thể biết ",
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
           shrinkWrap: true,// Đảm bảo ListView chính tự co lại vừa đủ với nội dung
            physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
           itemCount: listUserHint.length, // Số lượng mục trong ListView
           itemBuilder: (BuildContext context, int index) {
             return GestureDetector(
               onTap: (){
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 15,bottom: 10),
                 child: Row(
                   children: [
                     Container(
                       height: 100,
                       child: CircleAvatar(
                         radius: 50,
                         backgroundImage: NetworkImage(listUserHint[index].image,
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             padding: const EdgeInsets.only(left: 3),
                             alignment:Alignment.centerLeft,
                             child: Text(
                               textAlign: TextAlign.left,
                               listUserHint[index].username,
                               style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold
                               ),
                             ),
                           ),
                           Container(
                             child: Text(
                               " $index bạn chung",
                               style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w300
                               ),
                             ),
                           ),
                           Row(
                             children: [
                               if(listRequest.contains(listUserHint[index].id))
                                 Container(
                                   width: MediaQuery.of(context).size.width/3 ,
                                   child: TextButton(
                                     onPressed: () async {
                                       print("danh sách gửi");
                                       await DatabaseMethods().deleteRequest(id!, listUserHint[index].id);
                                       List<String> updateRequest=await DatabaseMethods().getRequest(id!);
                                       setState(()   {
                                         listRequest=updateRequest;
                                         print("danh sách request: $listRequest");
                                       });

                                     },
                                     style: ButtonStyle(
                                       backgroundColor:
                                       MaterialStateProperty
                                           .all<Color>(Colors
                                           .blue
                                           .shade800),
                                       // Màu nền của nút
                                       shape: MaterialStateProperty
                                           .all<
                                           RoundedRectangleBorder>(
                                         RoundedRectangleBorder(
                                           borderRadius:
                                           BorderRadius
                                               .circular(
                                               10.0), // Bo góc của nút
                                         ),
                                       ),
                                     ),
                                     child: Row(
                                       mainAxisSize:
                                       MainAxisSize.min,
                                       children: [
                                         if(listRequest.contains(listUserHint[index].id))
                                           Row(
                                             children: [
                                               Icon(
                                                 Icons
                                                     .person_remove,
                                                 color: Colors
                                                     .white, // Màu biểu tượng
                                               ),
                                               SizedBox(width: 5),
                                               // Khoảng cách giữa biểu tượng và văn bản
                                               Text(
                                                 "Hủy lời mời",
                                                 style: TextStyle(
                                                   color: Colors
                                                       .white, // Màu văn bản
                                                 ),
                                               )
                                             ],
                                           )
                                         else
                                           Row(
                                             children: [
                                               Icon(
                                                 Icons
                                                     .person_add_alt_1,
                                                 color: Colors
                                                     .white, // Màu biểu tượng
                                               ),
                                               SizedBox(width: 5),
                                               // Khoảng cách giữa biểu tượng và văn bản
                                               Text(
                                                 "thêm bạn bè",
                                                 style: TextStyle(
                                                   color: Colors
                                                       .white, // Màu văn bản
                                                 ),
                                               )
                                             ],
                                           ),
                                       ],
                                     ),
                                   ),
                                 )
                               else
                                 Container(
                                   width: MediaQuery.of(context).size.width/3 ,
                                   child: TextButton(
                                     onPressed: ()async {
                                       // print("elseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                                       await DatabaseMethods()
                                           .requestFriend(
                                           id!,
                                           listUserHint[index]
                                               .id);
                                       List<String>  updateListRequest=await DatabaseMethods().getRequest(id!) ;
                                       setState(()   {
                                         listRequest= updateListRequest;
                                         print("Thêm bạn bè: $listRequest");
                                       });
                                     },
                                     style: ButtonStyle(
                                       backgroundColor:
                                       MaterialStateProperty
                                           .all<Color>(Colors
                                           .blue
                                           .shade800),
                                       // Màu nền của nút
                                       shape: MaterialStateProperty
                                           .all<
                                           RoundedRectangleBorder>(
                                         RoundedRectangleBorder(
                                           borderRadius:
                                           BorderRadius
                                               .circular(
                                               10.0), // Bo góc của nút
                                         ),
                                       ),
                                     ),
                                     child: Row(
                                       mainAxisSize:
                                       MainAxisSize.min,
                                       children: [
                                         Icon(
                                           Icons
                                               .person_add_alt_1,
                                           color: Colors
                                               .white, // Màu biểu tượng
                                         ),
                                         SizedBox(width: 5),
                                         Text(
                                           "Thêm bạn bè",
                                           style: TextStyle(
                                             color: Colors
                                                 .white, // Màu văn bản
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),

                               SizedBox(width: 10,),
                               Container(
                                 width: MediaQuery.of(context).size.width/3.5,
                                 // decoration: BoxDecoration(
                                 //   borderRadius: BorderRadius.circular(10.0),
                                 // ),
                                 child: TextButton(
                                     onPressed: ()
                                     {
                                     },
                                     style: ButtonStyle(
                                       backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                         RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây

                                         ),
                                       ),
                                     ),
                                     child: Text("Xóa",
                                       style: TextStyle(
                                           fontSize: 16,
                                           color: Colors.black
                                       ),
                                     )
                                 ),
                               ),
                             ],
                           )
                         ],
                       ),
                     )
                   ],
                 ),
               ),
             );
           }
       ),

     ],
   );
 }
 Widget getFriends(){

     return Column(
       children: [
         Padding(
           padding: const EdgeInsets.all(15.0),
           child: Row(
             children: [
               Expanded(
                 child: Text(
                   "${listFriends.length} bạn bè",
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
             shrinkWrap: true,// Đảm bảo ListView chính tự co lại vừa đủ với nội dung
             physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
             itemCount: listFriends.length, // Số lượng mục trong ListView
             itemBuilder: (BuildContext context, int index) {
               return GestureDetector(
                 onTap: (){
                 },
                 child: Padding(
                   padding: const EdgeInsets.only(left: 5,bottom: 10),
                   child: Row(
                     children: [
                       Container(
                         height: 70,
                         child: CircleAvatar(
                           radius: 50,
                           backgroundImage: NetworkImage(listFriends[index].image,
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 5),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(
                               padding: const EdgeInsets.only(left: 3),
                               alignment:Alignment.centerLeft,
                               child: Text(
                                 textAlign: TextAlign.left,
                                 listFriends[index].username,
                                 style: TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                             ),
                             Container(
                               child: Text(
                                 " $index bạn chung",
                                 style: TextStyle(
                                     fontSize: 14,
                                     fontWeight: FontWeight.w300
                                 ),
                               ),
                             ),

                           ],
                         ),
                       )
                     ],
                   ),
                 ),
               );
             }
         ),

       ],
     );
   }

}
