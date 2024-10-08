import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/pages/comment.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/newsfeed_detail.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';


class Profile extends StatefulWidget {
  final String idProfileUser;
  const Profile({super.key , required this.idProfileUser});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream<QuerySnapshot>? myNewsfeedStream;
  String name="",image="",background="";
  bool myProfile=true;
  getDataUser()async{
    if(widget.idProfileUser!=await SharedPreferenceHelper().getIdUser()){
      myProfile=false;
    }
    QuerySnapshot data = await DatabaseMethods().getIdUserDetail(widget.idProfileUser);
    name = data.docs[0]["Username"];
    image = data.docs[0]["imageAvatar"];
    //background=data.docs[0]["imageAvatar"];
  }
  onLoad()async{
    await getDataUser();
    myNewsfeedStream = DatabaseMethods().getMyNews(widget.idProfileUser);
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
                        CircleAvatar(backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,
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
            Container(
              margin: EdgeInsets.only(top: 10,left: 20,right: 20),
              width: MediaQuery.of(context).size.width/1,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  Center(child: Text("+ Thêm vào tin",style: TextStyle(fontSize: 18,color: Colors.white),)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,left: 20,right: 20),
              width: MediaQuery.of(context).size.width/1,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  Center(child: Text("Chỉnh sửa trang cá nhân",style: TextStyle(fontSize: 18,color: Colors.black),)),
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
                  TextButton(
                    onPressed: (){},
                    child: Text("Reels",style: TextStyle(color: Colors.grey.shade600),),
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
                      Icon(Icons.home_sharp , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Sống tại ",style: TextStyle(fontSize: 16),),
                      Text("Thành phố Hồ Chính Minh",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
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
                      Text("Xem thêm thông tin giới thiệu",style: TextStyle(fontSize: 16),),
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
                          return  WidgetNewsfeed(date: data["newTimestamp"].toDate(),id: data["ID"]??"", username: data["userName"]??"", content: data["content"]??"", time: data["ts"]??"", image: data["image"]??"",idComment: data["id_comment"??""],);
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

