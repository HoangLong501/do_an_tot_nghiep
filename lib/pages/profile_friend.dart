import 'dart:async';
//import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/pages/comment.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/newsfeed_detail.dart';
import 'package:do_an_tot_nghiep/pages/option_profile.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'notifications/noti.dart';


class ProfileFriend extends StatefulWidget {
  final String idProfileUser;
  const ProfileFriend({super.key , required this.idProfileUser});
  @override
  State<ProfileFriend> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileFriend> {
  Stream<QuerySnapshot>? myNewsfeedStream;
  String name="",image="",background="",myId="",myName="";
  bool myProfile=true;
  List<String> tokens=[];
  int check=0;
  getDataUser()async{
    if(widget.idProfileUser!=myId){
      myProfile=false;
    }
    try {
      QuerySnapshot data = await DatabaseMethods().getUserById(widget.idProfileUser);
      name = data.docs[0]["Username"];
      image = data.docs[0]["imageAvatar"];
      tokens = List<String>.from(data.docs[0]["tokens"]);
      //background=data.docs[0]["imageAvatar"];
    }catch(e){
      print("lỗi lấy thông tin người dùng");
    }
  }
  upCheck() async {
     QuerySnapshot listFriend= await FirebaseFirestore.instance
         .collection("relationship").doc(myId).collection("friend")
         .where("status", isEqualTo: "friend").get();
     var doc=listFriend.docs;
     print(doc.length);
    for(int i=0;i<doc.length;i++){
      if(doc[i]["id"]==widget.idProfileUser){
        check=2;
      }
    }
  }
  onLoad()async{
    myId=(await SharedPreferenceHelper().getIdUser())!;
    await getDataUser();

    myName=(await SharedPreferenceHelper().getUserName())!;
    myNewsfeedStream = DatabaseMethods().getMyNews(widget.idProfileUser);
    check=await DatabaseMethods().getCkheckHint(myId, widget.idProfileUser)! ;
    await upCheck();
    print("check: $check");
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 40,left: 20,right: 20,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap:(){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back,size: 30,)),
                  Text( name!,style: TextStyle(
                    fontSize: 18
                  ),),
                  Icon(Icons.search_outlined,size: 30,),
                ],
              ),
            ),
            Stack(
              children: [
                Image(
                    image: Image.network("https://static.vecteezy.com/system/resources/thumbnails/001/849/553/small_2x/modern-gold-background-free-vector.jpg").image,
                    height: 240,
                    width: MediaQuery.of(context).size.width/1.0,
                    fit: BoxFit.fitWidth,
                ),
                Container(
                    margin: EdgeInsets.only(top: 180 , left: 10),
                    alignment: Alignment.bottomLeft,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(backgroundImage: Image.network(image).image,
                            radius: 80,
                        ),
                        SizedBox(height: 8,),
                        Text(name ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        Row(
                          children: [
                            Text("0" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            Text("  bạn bè" ,style: TextStyle(fontSize: 16,color: Colors.grey.shade600),),
                          ],
                        ),
                        ]
                     ),
                ),
        
              ],
            ),
            Row(
              children: [
                if( check==0)
               Container(
                  margin: EdgeInsets.only(top: 10,left: 20),
                  width: MediaQuery.of(context).size.width/2.7,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      GestureDetector(
                        onTap: (){
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
                          DatabaseMethods().updateCheckHint(myId, widget.idProfileUser, hintInfoMap);
                          DatabaseMethods().addFriends(myId, widget.idProfileUser, friendInfoMap);
                          for(int i=0; i<tokens.length;i++) {
                            NotificationDetail().sendAndroidNotification(
                                tokens[i], title, body);
                          }
                          setState(() {
                            check=1;
                          });
                        },
                     child:  Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(Icons.person_add_alt_1,
                              color: Colors.white,
                              )
                          ),
                          Center(
                              child: Text("Thêm bạn bè",
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              )
                          ),
                        ],
                      ),
                ),
                )else if(check==2)
               Container(
                 margin: EdgeInsets.only(top: 10,left: 20),
                 width: MediaQuery.of(context).size.width/2.7,
                 height: 40,
                 decoration: BoxDecoration(
                   color: Colors.grey.shade300,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child:
                 GestureDetector(
                   onTap: (){
                   },
                   child:  Row(
                     children: [
                       Container(
                           margin: EdgeInsets.only(left: 30,right: 10),
                           child:Icon(CupertinoIcons.person_2_alt,
                             color: Colors.black,
                           )
                       ),
                       Center(
                           child: Text("Bạn bè",
                             style: TextStyle(fontSize: 16,color: Colors.black),
                           )
                       ),
                     ],
                   ),
                 ),
               ) else
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 20),
                    width: MediaQuery.of(context).size.width/2.7,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                    GestureDetector(
                      onTap: (){
                        Map<String, dynamic>hintInfoMap={
                          "check":0
                        };
                        DatabaseMethods().updateCheckHint(myId, widget.idProfileUser, hintInfoMap);
                        DatabaseMethods().deleteReceived(myId, widget.idProfileUser);
                        setState(() {
                          check=0;
                        });
                      },
                      child:  Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(Icons.person_remove,
                                color: Colors.white,
                              )
                          ),
                          Center(
                              child: Text("Hủy lời mời",
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
               check==2? Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  width: MediaQuery.of(context).size.width/3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                  Center(child: Text("Nhắn tin",style: TextStyle(fontSize: 16,color: Colors.white),)),
                ):
               Container(
                 margin: EdgeInsets.only(top: 10,left: 10),
                 width: MediaQuery.of(context).size.width/3,
                 height: 40,
                 decoration: BoxDecoration(
                   color: Colors.grey.shade300,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child:
                 Center(child: Text("Nhắn tin",style: TextStyle(fontSize: 16,color: Colors.black),)),
               ),
                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  width: MediaQuery.of(context).size.width/6.5,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>OptionProfile(idProfile:widget.idProfileUser)));
                    },
                child: Center(child: Icon(Icons.more_horiz)),
                  )
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Row(
                children: [
                  TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade100)),
                      onPressed: (){},
                      child: Text("Bài viết",style: TextStyle(color: Colors.blue.shade600,
        
                      ),),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text("Ảnh",style: TextStyle(color: Colors.grey.shade600),),
                  ),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
            Container(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Text("Chi tiết",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            ),
            Container(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Độc thân",style: TextStyle(fontSize: 16),),

                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(Icons.location_pin , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Đến từ ",style: TextStyle(fontSize: 16),),
                      Text("Thành phố Hồ Chính Minh",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(Icons.access_time_filled_outlined , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Tham gia vào ",style: TextStyle(fontSize: 16),),
                      Text("Tháng ? Năm ?",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(Icons.list , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Xem thông tin giới thiệu của $name",style: TextStyle(fontSize: 16),),
                    ],
                  ),
        
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bạn bè",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  TextButton(onPressed: (){}, child: Text("Tìm bạn bè",style: TextStyle(fontSize: 16,color: Colors.blue),)),
                ],
              ),
            ),
            Padding(
              padding:EdgeInsets.only(left: 20,right: 20),
              child: Wrap(
                children: [
                  Container(
                    padding:EdgeInsets.only(bottom: 10,right: 8),
                    child: Column(
                      children: [
                        Image(image: Image.network("https://static-cse.canva.com/blob/1468006/1600w-0U5NB7wvTkA.jpg").image,
                          fit: BoxFit.fill,
                          height: 110,
                          width: 110,
                        ),
                        Text("Name friend",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.only(bottom: 10,right: 8),
                    child: Column(
                      children: [
                        Image(image: Image.network("https://static-cse.canva.com/blob/1468006/1600w-0U5NB7wvTkA.jpg").image,
                          fit: BoxFit.fill,
                          height: 110,
                          width: 110,
                        ),
                        Text("Name friend",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.only(bottom: 10,right: 8),
                    child: Column(
                      children: [
                        Image(image: Image.network("https://static-cse.canva.com/blob/1468006/1600w-0U5NB7wvTkA.jpg").image,
                          fit: BoxFit.fill,
                          height: 110,
                          width: 110,
                        ),
                        Text("Name friend",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
              width: MediaQuery.of(context).size.width/1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade300
              ),
              child: Center(child: Text("Xem tất cả bạn bè",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)),
            ),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bài viết",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  TextButton(onPressed: (){}, child: Text("Bộ lọc",style: TextStyle(color: Colors.lightBlue,fontSize: 17),))
                ],
              ),
            ),
            // Duyệt newsfeed ở đây
            StreamBuilder<QuerySnapshot>(
                  stream: myNewsfeedStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("connection");
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No data available"));
                }
                if (snapshot.hasData) {
                    return IntrinsicHeight(
                      child: Column(
                        children: snapshot.data!.docs.map((document){
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                          return  WidgetNewsfeed(idUser: data["UserID"],date: data["newTimestamp"].toDate(),id: data["ID"]??"", username: data["userName"]??"", content: data["content"]??"", time: data["ts"]??"", image: data["image"]??"");

                        }).toList(),
                      ),
                    );
                } else {
                  // Trường hợp dữ liệu không phù hợp
                  return Center(child: Text(" Dòng 306 Invalid data format"));
                }
              }),
          ],
        ),
      ),
    );
  }
}

