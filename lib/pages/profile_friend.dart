import 'dart:async';
//import 'dart:js_interop';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/newsfeed_detail.dart';
import 'package:do_an_tot_nghiep/pages/option_profile.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'notifications/noti.dart';


class ProfileFriend extends StatefulWidget {
  final String idProfileUser;
  const ProfileFriend({super.key , required this.idProfileUser});
  @override
  State<ProfileFriend> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileFriend> {
  Stream<QuerySnapshot>? myNewsfeedStream;
  String name="",image="",myId="",myName="",background="",relationship="",born="",address="",since="";
  List tokens=[];
  int check=0;
  List follower =[] , follow=[] , friends=[] , temp=[];
  int quantityFriend=0;
  bool followed = true;
  bool privateFriend = false;
  
  getTokens()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(widget.idProfileUser).get();
    tokens = data.get("tokens");
  }
  getDetail()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("userinfo").doc(widget.idProfileUser).get();
    try{
      relationship = data.get("relationship");
      born = data.get("born");
      address = data.get("address");
      since = data.get("since");
      background = data.get("imageBackground");
    }catch(e){
      relationship ="";
      born = "";
      address = "";
      since = "";
      background = "";
    }
  }
  upCheck() async {
     QuerySnapshot listFriend= await FirebaseFirestore.instance
         .collection("relationship").doc(widget.idProfileUser).collection("friend")
         .get();
    for(var data in listFriend.docs){
      if(data.id==myId){
        print(data.id==myId);
        if(data["status"]=="pending"){
            check = 1;
        }else{
          check = 2;
        }
      }
    }

  }
  getStatusPrivate()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(widget.idProfileUser)
        .collection("advance").doc(widget.idProfileUser).get();
    try{
      privateFriend = data.get("privateFriend");
    }catch(e){
      privateFriend = false;
    }
  }
  getStatusFollow()async{
    List tempFollow=[];
    DocumentSnapshot dataFollow = await FirebaseFirestore.instance.collection("user").doc(myId)
        .collection("advance").doc(myId).get();
    try{
      tempFollow = dataFollow.get("unfollow");
    }catch(e){
      tempFollow = [];
    }
    if(tempFollow.isEmpty){
      followed = true;
    }else{
      followed = !tempFollow.contains(widget.idProfileUser);
    }
  }
  onLoad()async{
    myId=(await SharedPreferenceHelper().getIdUser())!;
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection("relationship").doc(widget.idProfileUser).collection("follower").doc(widget.idProfileUser).get();
    follower = data.get("data");
    DocumentSnapshot data1 = await FirebaseFirestore.instance
        .collection("relationship").doc(myId).collection("follow").doc(myId).get();
    follow = data1.get("data");
    DocumentSnapshot data2 = await FirebaseFirestore.instance.collection("user").doc(widget.idProfileUser).get();
    image = data2.get("imageAvatar");
    name = data2.get("Username");
    myName=(await SharedPreferenceHelper().getUserName())!;
    myNewsfeedStream = DatabaseMethods().getMyNewsProfile(widget.idProfileUser , myId);
    await upCheck();
    friends = await DatabaseMethods().getFriends(widget.idProfileUser);
    friends.remove(myId);
    quantityFriend = friends.length;
    if(friends.length>6){
      temp=friends.sublist(0,6);
    }else{
      temp=friends;
    }
    await getStatusFollow();
    await getStatusPrivate();
    await getTokens();
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
                  Text( name,style: TextStyle(
                    fontSize: 18
                  ),),
                  Icon(Icons.search_outlined,size: 30,),
                ],
              ),
            ),
            Stack(
              children: [
                // Image(
                //     image: Image.network("https://static.vecteezy.com/system/resources/thumbnails/001/849/553/small_2x/modern-gold-background-free-vector.jpg").image,
                //     height: 240,
                //     width: MediaQuery.of(context).size.width/1.0,
                //     fit: BoxFit.fitWidth,
                // ),
                Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width/1.0,
                ),
                Container(
                    margin: EdgeInsets.only(top: 180 , left: 10),
                    alignment: Alignment.bottomLeft,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        image!=""? CircleAvatar(
                             backgroundImage: Image.network(image).image,
                            radius: 80,
                        ):CircleAvatar(backgroundColor: Colors.blue,radius: 80,),
                        SizedBox(height: 8,),
                        Text(name ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
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
            Column(
              children: [
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
                            onTap: ()async{
                              Map<String,dynamic> friendInfoMap={
                                "id": myId,
                                "status":"pending"
                              };
                              String title="Thông báo mới ";
                              String body="Bạn có lời mời kết bạn từ $myName";
                              DatabaseMethods().addFriends(myId, widget.idProfileUser, friendInfoMap);
                              print("token lenghth ${tokens.length}");
                              for(int i=0; i<tokens.length;i++) {
                                NotificationDetail().sendAndroidNotification(
                                    tokens[i], body,title);
                                print(tokens[i]);
                              }
                              DateTime now = DateTime.now();
                              Timestamp timestamp = Timestamp.fromDate(now);
                              String timeNow = DateFormat('h:mma').format(now);
                              await FirebaseFirestore.instance.collection("notification").doc(widget.idProfileUser).collection("detail").doc().set({
                                  "ID":myId,
                                  "content":body,
                                  "ts": timeNow,
                                  "timestamp":timestamp,
                                  "check":false
                              });
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
                   GestureDetector(
                     onTap: (){
                       showMaterialModalBottomSheet(
                           context: context, builder: (context)=>Container(
                         height: MediaQuery.of(context).size.height/3.4,
                         child: Column(
                           children: [
                             TextButton(onPressed: ()async{
                               if(followed){

                               }else{
                                 List temp=[];
                                 DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(myId)
                                     .collection("advance").doc(myId).get();
                                 temp = data.get("unfollow");
                                 temp.remove(widget.idProfileUser);
                                 Map<String ,dynamic> dataInfo ={
                                   "unfollow":temp,
                                 };
                                 await FirebaseFirestore.instance.collection("user").doc(myId)
                                     .collection("advance").doc(myId).update(dataInfo);

                                 setState(() {
                                   followed =true;
                                 });
                               }
                               Navigator.of(context).pop();
                             }, child: Row(
                               children: [
                                 Text("Theo dõi"),
                                 followed? Icon(Icons.check):SizedBox(),
                               ],
                             )),
                             TextButton(onPressed: ()async{
                               if(!followed){

                               }else{
                                 List temp=[];
                                 DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(myId)
                                 .collection("advance").doc(myId).get();
                                 if(data.exists){
                                   try{
                                     temp = data.get("unfollow");
                                   }catch(e){
                                     temp=[];
                                   }
                                   temp.add(widget.idProfileUser);
                                   Map<String ,dynamic> dataInfo ={
                                     "unfollow":temp,
                                   };
                                   await FirebaseFirestore.instance.collection("user").doc(myId)
                                       .collection("advance").doc(myId).update(dataInfo);
                                 }else{
                                   temp.add(widget.idProfileUser);
                                   Map<String ,dynamic> data ={
                                     "unfollow":temp,
                                   };
                                   await FirebaseFirestore.instance.collection("user").doc(myId)
                                       .collection("advance").doc(myId).set(data);
                                 }

                                 setState(() {
                                   followed =false;
                                 });
                               }
                               Navigator.of(context).pop();
                             }, child: Row(
                               children: [
                                 Text("Bỏ theo dõi"),
                                 !followed? Icon(Icons.check):SizedBox(),
                               ],
                             )),
                           ],
                         ),
                       ));
                     },
                     child: Container(
                       margin: EdgeInsets.only(top: 10,left: 20),
                       width: MediaQuery.of(context).size.width/2.7,
                       height: 40,
                       decoration: BoxDecoration(
                         color: Colors.grey.shade300,
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child:
                       Row(
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
                check!=2?TextButton(
                  onPressed: ()async{
                      if(follower.contains(myId)){
                        setState(() {
                          follower.remove(myId);
                          follow.remove(widget.idProfileUser);
                        });

                      }else{
                        setState(() {
                          follower.add(myId);
                          follow.add(widget.idProfileUser);
                        });
                      }
                      Map<String , dynamic> dataInfoFollower ={
                        "data":follower
                      };
                      await FirebaseFirestore.instance.collection("relationship").doc(widget.idProfileUser)
                      .collection("follower").doc(widget.idProfileUser).update(dataInfoFollower);
                      Map<String , dynamic> dataInfoFollow ={
                        "data":follow
                      };
                      await FirebaseFirestore.instance.collection("relationship").doc(myId)
                          .collection("follow").doc(myId).update(dataInfoFollow);
                  },
                  child:  Container(
                    margin: EdgeInsets.only(top: 10,left: 10),
                    width: MediaQuery.of(context).size.width/1.6,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                    Center(child: Text(
                      follower.contains(myId)?
                      "Hủy theo dõi":"Theo dõi",

                      style: TextStyle(fontSize: 16,color: Colors.black),)),
                  ),
                ):SizedBox(),

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
                  address!=""? Row(
                    children: [
                      Icon(Icons.home_sharp , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Sống tại ",style: TextStyle(fontSize: 16),),
                      Text(address,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  born!=""? Row(
                    children: [
                      Icon(Icons.location_pin , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Đến từ ",style: TextStyle(fontSize: 16),),
                      Text(born,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  since!=""? Row(
                    children: [
                      Icon(Icons.access_time_filled_outlined , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Tham gia vào ",style: TextStyle(fontSize: 16),),
                      Text(since,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  relationship!=""? Row(
                    children: [
                      Icon(CupertinoIcons.heart , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Đang",style: TextStyle(fontSize: 16),),
                      Text(relationship,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ):SizedBox(),
                  SizedBox(height: 8,),
                  address!="" && born!="" && since!="" && relationship !="" ? Row(
                    children: [
                      Icon(Icons.list , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Xem thêm thông tin giới thiệu",style: TextStyle(fontSize: 16),),
                    ],
                  ):Center(
                    child: Text("Người dùng hiện không có thông tin chi tiết",
                      style: TextStyle(fontSize: 16),

                    ),
                  ),
                  SizedBox(height: 4,),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bạn bè",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  TextButton(onPressed: (){
                    print(privateFriend);
                  }, child: Text("Tìm bạn bè",style: TextStyle(fontSize: 16,color: Colors.blue),)),
                ],
              ),
            ),
            Container(
              padding:EdgeInsets.only(left: 20,right: 20),
              height:privateFriend? 10: temp.length>3? 300 :150,
              child: !privateFriend ? GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return FriendDetail(id: temp[index]);
                },
                itemCount: temp.length, // Tổng số item trong grid
              ):SizedBox(),
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
          image!=""?Expanded(
            child: Image(image: Image.network(image).image,
              fit: BoxFit.fitHeight,
            ),
          ):SizedBox(),
          Text(name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
        ],
      ),
    );

  }


}