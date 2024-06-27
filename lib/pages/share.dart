import 'dart:io';

import 'package:do_an_tot_nghiep/pages/update_detail_profile/showpublicdialog.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Share extends StatefulWidget {
  final String idsource,image;

  const Share({super.key,required this.idsource,required this.image});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  String? idMyUser,imageMyUser,nameMyUser;
  List<Map<String,dynamic>> listFriend=[];
  TextEditingController contentController=TextEditingController();
  List<String> listViews=[];
  // getData() async {
  //   QuerySnapshot snapshot=await DatabaseMethods().getUserById(idMyUser!);
  //   imageMyUser=snapshot.docs[0]["imageAvatar"];
  //   nameMyUser=snapshot.docs[0]["Username"];
  // }
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
  onLoad()async{
    idMyUser=await SharedPreferenceHelper().getIdUser();
    nameMyUser=await SharedPreferenceHelper().getUserName();
    imageMyUser=await SharedPreferenceHelper().getImageUser();
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
                            Container(
                              width: 130,
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(7)
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                 List<String> listView= await showPublicDialog(context);
                               setState(() {
                                 listViews=listView;
                                 print("aaaaaaaaaaaaaaaaaaaaa$listViews");
                               });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Công khai",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            )
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

                    Container(
                        margin: EdgeInsets.only(left:170,top: 20 ),
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade800,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: GestureDetector(
                          onTap: () async {
                                DateTime now = DateTime.now();
                                String id=randomAlphaNumeric(10);
                                final refImage = FirebaseStorage.instance.ref().child(
                                    '${idMyUser}/images_newsfeed/$id.jpg');
                                final taskSnapshotImage = await refImage.putFile(File(widget.image));
                                final imageUrl = await taskSnapshotImage.ref.getDownloadURL();
                                Timestamp timestamp = Timestamp.fromDate(now);
                                String timeNow = DateFormat('h:mma').format(now);
                                Map<String, dynamic> newsInfoMap = {
                                  "ID":id,
                                  "UserID":idMyUser,
                                  "userName": nameMyUser,
                                  "content": contentController.text,
                                  "image": imageUrl,
                                  "idsource":widget.idsource,
                                  "ts": timeNow,
                                  "newTimestamp":timestamp,
                                  "react": [],
                                  "viewers":listViews
                                };
                                List<String>list=[];
                                list.add(idMyUser!);
                                Map<String, dynamic> infoShare = {
                                  "shared":list
                                };
                                DatabaseMethods().addNewFeed(id, newsInfoMap);
                                DatabaseMethods().updateVideo(widget.idsource, infoShare);
                                Navigator.pop(context);

                          },
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
                          itemCount: listFriend!.length,
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
