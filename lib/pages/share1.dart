import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/showpublicdialog.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'createNewsfeed.dart';
import 'notifications/noti.dart';

class Share1 extends StatefulWidget {
  final String idNewsFeed;

  const Share1({super.key,  required this.idNewsFeed});

  @override
  State<Share1> createState() => _ShareState();
}

class _ShareState extends State<Share1> {
  String? idMyUser,imageMyUser,nameMyUser;
  List<Map<String,dynamic>> listFriend=[];
  TextEditingController contentController=TextEditingController();
  List<String> listViews=[];
  int _selectedValue = 1;
  String status="";
  List viewers =[] , custom=[];
  Map<String, bool> _selectedViewer = {};
  getFriends() async {
    List<String>  list= await DatabaseMethods().getFriends(idMyUser!);
    for(int i=0;i<list.length;i++){
      QuerySnapshot snapshot=await DatabaseMethods().getUserById(list[i]);
      Map<String,dynamic> infoMap={
        "name":snapshot.docs[0]["Username"],
        "image":snapshot.docs[0]["imageAvatar"]
      };
      listFriend.add(infoMap);
    }
  }
  Future<List> getSelectedKeys()async{
    return  _selectedViewer.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
  }
  onLoad()async{
    idMyUser=await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(idMyUser).get();
    nameMyUser = data.get("Username");
    imageMyUser=data.get("imageAvatar");
    await getFriends();
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
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(left: 20,top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: Image
                              .network(imageMyUser==null?"https://i.ibb.co/jzk0j6j/image.png":imageMyUser!)
                              .image,
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                nameMyUser==null?"":nameMyUser!,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                           TextButton(
                                onPressed: (){
                                  showDialog(context: context, builder: (context) {
                                    int tempValue = _selectedValue;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text("Điều chỉnh trạng thái", style: TextStyle(fontSize: 20)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: const Text('Chỉ mình tôi'),
                                                leading: Radio(
                                                  value: 1,
                                                  groupValue: tempValue,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      tempValue = value!;
                                                    });
                                                    print(tempValue);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text('Bạn bè'),
                                                leading: Radio(
                                                  value: 2,
                                                  groupValue: tempValue,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      tempValue = value!;
                                                    });
                                                    print(tempValue);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text('Công khai'),
                                                leading: Radio(
                                                  value: 3,
                                                  groupValue: tempValue,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      tempValue = value!;
                                                    });
                                                    print(tempValue);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text('Tùy chỉnh'),
                                                leading: Radio(
                                                  value: 4,
                                                  groupValue: tempValue,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      tempValue = value!;
                                                    });
                                                    print(tempValue);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                if (tempValue == 4) {
                                                  List friends = await DatabaseMethods().getFriends(idMyUser!);
                                                  Map<String, bool>? selectedViewer = await showGeneralDialog<Map<String, bool>>(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                                    transitionDuration: const Duration(milliseconds: 600),
                                                    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                                                      return ViewerDialog(friends: friends);
                                                    },
                                                  );
                                                  if (selectedViewer != null) {
                                                    // Xử lý giá trị selectedViewer
                                                    _selectedViewer = selectedViewer;
                                                    custom =await getSelectedKeys();
                                                    print(custom);
                                                  }
                                                  Navigator.of(context).pop(tempValue);
                                                } else {
                                                  Navigator.of(context).pop(tempValue);
                                                }
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },).then((value){
                                    if (value != null) {
                                      setState(() {
                                        _selectedValue = value;
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.lightBlueAccent.shade100
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.lock,size: 16,color: Colors.blue.shade600,),
                                        Text(_selectedValue==1?"Chỉ mình tôi":_selectedValue==2?"Bạn bè":_selectedValue==4?"Tùy chỉnh":"Công khai",style: TextStyle(color:Colors.blue.shade600, ),),
                                        Icon(Icons.arrow_drop_down,size: 16,color: Colors.blue.shade600,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                    IntrinsicHeight(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/1,
                        child: TextField(
                          controller: contentController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            helperMaxLines: 1,
                            hintText: "Hãy nói gì đó về nội dung này...",
                            hintStyle: TextStyle(fontSize: 20),
                          ),
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       //SizedBox(width: MediaQuery.of(context).size.width/2.6,),
                       TextButton(
                              onPressed: () async {
                                DateTime now = DateTime.now();
                                String id=randomAlphaNumeric(10);
                                String idComment=randomAlphaNumeric(16);
                                Timestamp timestamp = Timestamp.fromDate(now);
                                String timeNow = DateFormat('h:mma').format(now);
                                List followers=[];
                                if(_selectedValue==1){
                                  viewers.add(idMyUser);
                                }else if(_selectedValue==2){
                                  viewers =await DatabaseMethods().getFriends(idMyUser!);
                                  viewers.add(idMyUser);
                                }else if(_selectedValue==4){
                                  custom.add(idMyUser);
                                  viewers = custom;
                                }else{
                                  List friends = await DatabaseMethods().getFriends(idMyUser!);
                                  try{
                                    DocumentSnapshot data = await FirebaseFirestore.instance.collection("relationship")
                                        .doc(idMyUser).collection("follower").doc(idMyUser).get();
                                    followers = data.get("data");
                                  }catch(e){
                                    followers=[];
                                  }
                                  viewers = [...friends, ...followers];
                                  viewers.add(idMyUser);
                                }
                                Map<String, dynamic> newsInfoMap = {
                                  "ID":id,
                                  "UserID":idMyUser,
                                  "userName": nameMyUser,
                                  "content": contentController.text,
                                  "image": "",
                                  "ts": timeNow,
                                  "newTimestamp":timestamp,
                                  "react": [],
                                  "viewers":viewers,

                                };
                                Map<String, dynamic> commentInfoMap = {
                                  "ID":id,
                                };
                                await DatabaseMethods().addNews( id, newsInfoMap);
                                await DatabaseMethods().initComment(id, commentInfoMap);
                                for(var follower in followers){
                                  NotificationDetail().sendNotificationToAnyDevice(follower,
                                      "$nameMyUser vừa đăng một tin mới",
                                      "Bạn có thông báo mới");
                                }
                                Map<String , dynamic> data={
                                    "ID":widget.idNewsFeed,
                                    "idUser":idMyUser,
                                };
                                await FirebaseFirestore.instance.collection("newsfeed")
                                .doc(id).collection("share").doc(idMyUser).set(data);
                                print(data);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                 height: 40,
                                 width: MediaQuery.of(context).size.width/2.6,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade800,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Center(
                                  child: Text(
                                    "Chia sẻ ngay",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              ),
                            ),
                     ],
                   ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
              Container(
                height: 140,
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gửi bằng Messenger",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    if(listFriend==[])
                      Text("vui lòng kết bạn để có thể chia sẻ")
                    else
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                          itemCount: listFriend.length,
                          itemBuilder: (context, index) {
                            String name=listFriend[index]["name"];
                            String image=listFriend[index]["image"];
                                  return Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: Image.network(image).image,
                                            ),
                                            Text(
                                              name,
                                              maxLines: 40,
                                              style:TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
