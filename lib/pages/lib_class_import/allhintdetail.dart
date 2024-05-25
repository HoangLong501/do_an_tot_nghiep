import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/database.dart';
import '../../service/shared_pref.dart';
import '../notifications/noti.dart';

class AllHintDetail extends StatefulWidget {
  final String idHint;
  const AllHintDetail({super.key,required this.idHint});

  @override
  State<AllHintDetail> createState() => _AllHintDetailState();
}

class _AllHintDetailState extends State<AllHintDetail> {
  String idUser="",image="",username="",myId="",myName="";
  List<String> tokens=[];
  int check=0;
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(
          widget.idHint);
      username = querySnapshot.docs[0]["Username"];
      image = querySnapshot.docs[0]["imageAvatar"];
      tokens = List<String>.from(querySnapshot.docs[0]["tokens"]);
      print("dã vào");
      print(username);
    }catch(error){
      print("lỗi khi lấy dữ liệu người dùng $error");
    }

  }
  onLoad() async{
    myId= (await SharedPreferenceHelper().getIdUser())!;
    check=(await DatabaseMethods().getCkheckHint(myId, widget.idHint))! ;
    myName=(await SharedPreferenceHelper().getUserName())!;
    await getData();


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
    return
      GestureDetector(
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
                  backgroundImage: NetworkImage(image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      alignment:Alignment.centerLeft,
                      child: Text(
                        username,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "  bạn chung",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                    check==0?
                    Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width/3,
                            child:
                            TextButton(
                              onPressed: () async
                              {
                                Map<String, dynamic>hintInfoMap={
                                  "check":1
                                };
                                Map<String,dynamic> friendInfoMap={
                                  "id": myId,
                                  "status":"pending"
                                };
                                String title="thông báo mới ";
                                String body="Bạn có lơ mời kết bạn từ $myName";
                                DatabaseMethods().updateCheckHint(myId, widget.idHint, hintInfoMap);
                                DatabaseMethods().addFriends(myId, widget.idHint, friendInfoMap);
                                for(int i=0; i<tokens.length;i++) {
                                  NotificationDetail().sendAndroidNotification(
                                      tokens[i], title, body);
                                }
                                setState(() {
                               check=1;
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

                              child: Text("Thêm bạn bè",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          child: TextButton(
                              onPressed: ()
                              async {
                                await DatabaseMethods().deleteHint(myId,widget.idHint);
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
                    ):Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3.5,
                          child: TextButton(
                            onPressed: () async {
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty
                                  .all<Color>(Colors
                                  .lightBlue
                                  .shade50),
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
                                // Khoảng cách giữa biểu tượng và văn bản
                                Text(
                                  "Nhắn tin",
                                  style: TextStyle(
                                      color: Colors.blue.shade700, // Màu văn bản
                                      fontSize: 16
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          child: TextButton(
                            onPressed: () async {
                              Map<String, dynamic>hintInfoMap={
                                "check":0
                              };
                              DatabaseMethods().updateCheckHint(myId, widget.idHint, hintInfoMap);
                              setState(() {
                                  check=0;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateColor
                                  .resolveWith((states) =>
                              Colors.grey.shade300),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  )),
                            ),
                            child:  Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .person_remove,
                                      color: Colors
                                          .grey.shade700, // Màu biểu tượng
                                    ),
                                    SizedBox(width: 5),
                                    // Khoảng cách giữa biểu tượng và văn bản
                                    Text(
                                      "Hủy",
                                      style: TextStyle(
                                        color: Colors
                                            .black, // Màu văn bản
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
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
}
