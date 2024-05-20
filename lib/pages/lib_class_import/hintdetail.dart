import 'dart:async';
import 'package:do_an_tot_nghiep/pages/profile_friend.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../notifications/noti.dart';
class HintDetail extends StatefulWidget {
  final String id ;
  const HintDetail({super.key , required this.id});

  @override
  State<HintDetail> createState() => _HintDetailState();
}

class _HintDetailState extends State<HintDetail> {
  List items=[0,1,2];
  String username='',image='',id='' , myId='',myName="";
  List<String> tokens=[];
  int check=0;
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(
          widget.id);
      print(querySnapshot.docs[0].data());
      username = querySnapshot.docs[0]["Username"];
      image = querySnapshot.docs[0]["imageAvatar"];
      id = querySnapshot.docs[0]["IdUser"];
      tokens = List<String>.from(querySnapshot.docs[0]["tokens"]);
      print(image);
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }

  }
  onLoad() async{
    await getData();
    myName=(await SharedPreferenceHelper().getUserName())!;
    myId=(await SharedPreferenceHelper().getIdUser())!;
    check=await DatabaseMethods().getCkheckHint(myId, id)! ;
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

      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileFriend(idProfileUser: id)));

      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1,
            ),

            borderRadius:
            BorderRadius.circular(10), // Độ bo góc
          ),
          width: 250,
          // Đặt chiều rộng của Container
          height: 350,
          margin: EdgeInsets.symmetric(horizontal: 2),
          // Đặt khoảng cách giữa các phần tử

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Căn lề trái cho các phần tử trong cột
            children: [
              Container(
                width: 250,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(
                          9)), // Độ cong của góc bo tròn
                  child:image==""?Image.asset("assets/images/avarta.jpg"): Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),

              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(
                        9)), // Độ cong của góc bo tròn
                child: image==""? Image(image: Image.asset("assets/images/logo.png").image,): Image.network(
                  image,
                  fit: BoxFit.cover,

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                 username,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    // Đặt chiều cao của Container
                    width: 80,
                    // Đặt chiều rộng của Container
                    child: Stack(
                      children: List.generate(
                          items.length, (index) {
                        return Positioned(
                          right: 15 + index * 15,
                          // Tăng vị trí của mỗi ảnh trước để nó đè lên ảnh sau một phần
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Đảm bảo container có hình dạng tròn
                              border: Border.all(
                                // Định nghĩa viền
                                color: Colors.white,
                                // Màu của viền
                                width:
                                2, // Độ dày của viền
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage:
                              NetworkImage(
                                "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Text(
                    "bạn chung",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              check==0?
              Row(
                children: [
                  SizedBox(width: 15,),
                  TextButton(
                    onPressed: () async {
                      Map<String, dynamic>hintInfoMap={
                        "check":1
                      };
                      Map<String,dynamic> friendInfoMap={
                        "id": myId,
                        "status":"pending"
                      };
                      //print("send noti");
                      String title="thông báo mới ";
                      String body="Bạn có lơ mời kết bạn từ $myName";
                      DatabaseMethods().updateCheckHint(myId, id, hintInfoMap);
                      DatabaseMethods().addFriends(myId, id, friendInfoMap);
                      for(int i=0; i<tokens.length;i++) {
                        NotificationDetail().sendAndroidNotification(
                            tokens[i], title, body);
                      }
                      setState(() {
                        check=1;
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
                              "Thêm bạn bè",
                              style: TextStyle(
                                color: Colors
                                    .white, // Màu văn bản
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () async {
                        await DatabaseMethods().deleteHint(myId,id);
                        setState(() {
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
                      child: Text(
                        "Xóa",
                        style: TextStyle(
                            color: Colors.black),
                      ))
                ],
              ):Row(
                children: [
                  SizedBox(width: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width/4,
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
                  TextButton(
                      onPressed: () async {
                        Map<String, dynamic>hintInfoMap={
                          "check ":0
                        };
                        DatabaseMethods().updateCheckHint(myId, id, hintInfoMap);
                        DatabaseMethods().deleteReceived(myId, id);
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
