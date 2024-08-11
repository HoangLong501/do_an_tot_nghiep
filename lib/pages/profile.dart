import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/edit_profile_detail.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/newsfeed_detail.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/edit_story.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'lib_class_import/userDetailProvider.dart';

class Profile extends StatefulWidget {
  final String idProfileUser;
  const Profile({super.key , required this.idProfileUser});
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  Stream<QuerySnapshot>? myNewsfeedStream;
  // String name="",image="",background="",relationship="",born="",address="",since="";
  bool myProfile=true;
  int quantityFriend=0;
  List friends=[] , temp=[];
  bool openEye = true;
  bool openEyeDetail = true;
  onLoad()async{
    friends = await DatabaseMethods().getFriends(widget.idProfileUser);
    friends.remove(widget.idProfileUser);
    quantityFriend = friends.length;
    if(friends.length>6){
      temp=friends.sublist(0,6);
    }else{
      temp=friends;
    }
    myNewsfeedStream = DatabaseMethods().getOnlyMyNews(widget.idProfileUser);
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
    final userDetailProvider = Provider.of<UserDetailProvider>(context);
    userDetailProvider.getUser();
    userDetailProvider.getUserDetails();
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
                  Text( userDetailProvider.name ,style: TextStyle(
                    fontSize: 18
                  ),),
                  Icon(Icons.search_outlined,size: 30,),
                ],
              ),
            ),
            Stack(
              children: [
                Image(
                    image: Image.network(userDetailProvider.background==""?"https://i.ibb.co/9WYddvb/image.png":userDetailProvider.background).image,
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
                        CircleAvatar(backgroundImage:  Image.network(userDetailProvider.avatar==""?"https://i.ibb.co/jzk0j6j/image.png":userDetailProvider.avatar).image,
                            radius: 80,
                        ),
                        SizedBox(height: 8,),
                        Text(userDetailProvider.name ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        Row(
                          children: [
                            Text("$quantityFriend" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
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
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>EditStory(idUser: widget.idProfileUser)));
                    },
                      child: Center(
                          child: Text("+ Thêm vào tin",style: TextStyle(fontSize: 18,color: Colors.white),))),
            ),
            GestureDetector(
                onTap: ()  {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>
                    EditProfileDetail(idUser: widget.idProfileUser)));
                },
           child:  Container(
              margin: EdgeInsets.only(top: 10,left: 20,right: 20),
              width: MediaQuery.of(context).size.width/1,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),

                child:   Center(child: Text("Chỉnh sửa trang cá nhân",style: TextStyle(fontSize: 18,color: Colors.black),)),
              )
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
              child: Row(
                children: [
                  Text("Chi tiết",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                  IconButton(onPressed: ()async{
                    setState(() {
                      openEyeDetail = !openEyeDetail;
                    });
                    await FirebaseFirestore.instance.collection("user").doc(widget.idProfileUser).collection("advance").doc(widget.idProfileUser)
                        .set({
                      "privateDetail":openEyeDetail,
                      "privateFriend":openEye,
                    });
                  }, icon: Icon(openEyeDetail==true ? CupertinoIcons.eye : CupertinoIcons.eye_slash , color: openEyeDetail==true ? Colors.blue :Colors.grey,))
                ],
              ),
            ),
            Container(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Column(
                children: [
                  userDetailProvider.address!=""? Row(
                    children: [
                      Icon(Icons.home_sharp , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Sống tại ",style: TextStyle(fontSize: 16),),
                      Text(userDetailProvider.address,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  userDetailProvider.born!=""? Row(
                    children: [
                      Icon(Icons.location_pin , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Đến từ ",style: TextStyle(fontSize: 16),),
                      Text(userDetailProvider.born,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  userDetailProvider.sex!=""? Row(
                    children: [
                      Icon(CupertinoIcons.profile_circled , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Giới tính  ",style: TextStyle(fontSize: 16),),
                      Text(userDetailProvider.sex,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  userDetailProvider.relationship!=""? Row(
                    children: [
                      Icon(CupertinoIcons.heart , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Đang ",style: TextStyle(fontSize: 16),),
                      Text(userDetailProvider.relationship,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  userDetailProvider.address!="" && userDetailProvider.born!="" && userDetailProvider.sex!=""
                      && userDetailProvider.relationship !="" ?SizedBox(height: 8,):SizedBox(),
                  userDetailProvider.address!="" && userDetailProvider.born!="" && userDetailProvider.sex!=""
                      && userDetailProvider.relationship !="" ? Row(
                    children: [
                      Icon(Icons.list , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Xem thêm thông tin giới thiệu",style: TextStyle(fontSize: 16),),
                    ],
                  ):Center(
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>
                            EditProfileDetail(idUser: widget.idProfileUser)));
                      },
                      child: Text("Hãy cho mọi người biết thêm về bạn",
                        style: TextStyle(fontSize: 16),

                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Bạn bè",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                      IconButton(onPressed: ()async{

                        setState(() {
                          openEye = !openEye;
                        });
                        await FirebaseFirestore.instance.collection("user").doc(widget.idProfileUser).collection("advance").doc(widget.idProfileUser)
                            .set({
                          "privateDetail":openEyeDetail,
                          "privateFriend":openEye,
                        });
                        print(openEye);
                      }, icon: Icon(openEye==true ? CupertinoIcons.eye : CupertinoIcons.eye_slash , color: openEye==true ? Colors.blue :Colors.grey,))
                    ],
                  ),
                  TextButton(onPressed: (){}, child: Text("Tìm bạn bè",style: TextStyle(fontSize: 16,color: Colors.blue),)),
                ],
              ),
            ),
            Container(
              padding:EdgeInsets.only(left: 20,right: 20),
              height: temp.isEmpty? 10: temp.length>3? 300 :150,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,// Số lượng cột
                ),
                itemBuilder: (BuildContext context, int index) {
                  return FriendDetail(id: temp[index]);
                },
                itemCount: temp.length, // Tổng số item trong grid
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
                          return  WidgetNewsfeed(idUser: data["UserID"],date: data["newTimestamp"].toDate(),id: data["ID"]??"", username: data["userName"]??"", content: data["content"]??"", time: data["ts"]??"", image: data["image"]??"",);
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

class FriendDetail extends StatefulWidget {
  final String id;
  const FriendDetail({super.key , required this.id});

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  String name="",image="";

  onLoad()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(widget.id).get();
    name=data.get("Username");
    image = data.get("imageAvatar");
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
    return Container(
      padding:EdgeInsets.only(bottom: 10,right: 8),
      child: Column(
        children: [
          Expanded(
            child: image!=""? Image(image: Image.network(image).image
              ,
              fit: BoxFit.fitHeight,
            ): CircleAvatar(backgroundColor: Colors.blue,),
          ),
          Text(name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
        ],
      ),
    );

  }


}


