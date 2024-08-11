import 'dart:io';
import 'package:do_an_tot_nghiep/pages/notifications/noti.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/database.dart';
class CreateNewsFeed extends StatefulWidget {
  const CreateNewsFeed({super.key});

  @override
  State<CreateNewsFeed> createState() => _CreateNewsFeedState();
}

class _CreateNewsFeedState extends State<CreateNewsFeed> {
  TextEditingController contentController =TextEditingController();
  File? _selectedImage;
  bool typed=false;
  String idUser="" , username="",avatar="" , newsFeedId="" , urlImage="";
  int _selectedValue = 1;
  String status="";
  List viewers =[] , custom=[];
   Map<String, bool> _selectedViewer = {};

  Future<List> getSelectedKeys()async{
    return  _selectedViewer.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
  }
  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnImage!.path);
      print(_selectedImage);
    });
  }
  Future uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(10);
    final ref = FirebaseStorage.instance.ref().child('$idUser/images_newsfeed/$nameImage.jpg');
    final taskSnapshot = await ref.putFile(image);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    urlImage = imageUrl;
    print(urlImage);
  }

  Future<void> addNews(bool send) async {
    if (contentController.text != "" ) {
      DateTime now = DateTime.now();
      String id=randomAlphaNumeric(10);
      String idComment=randomAlphaNumeric(16);
      Timestamp timestamp = Timestamp.fromDate(now);
      String timeNow = DateFormat('h:mma').format(now);
      List followers=[];
      if(_selectedValue==1){
        viewers.add(idUser);
      }else if(_selectedValue==2){
        viewers =await DatabaseMethods().getFriends(idUser);
        viewers.add(idUser);
      }else if(_selectedValue==4){
        custom.add(idUser);
        viewers = custom;
      }else{
        List friends = await DatabaseMethods().getFriends(idUser);
        try{
          DocumentSnapshot data = await FirebaseFirestore.instance.collection("relationship")
              .doc(idUser).collection("follower").doc(idUser).get();
          followers = data.get("data");
        }catch(e){
          followers=[];
        }
        viewers = [...friends, ...followers];
        viewers.add(idUser);
      }
      print(viewers);
      Map<String, dynamic> newsInfoMap = {
        "ID":id,
        "UserID":idUser,
        "userName": username,
        "content": contentController.text,
        "image": urlImage,
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
            "$username vừa đăng một tin mới",
            "Bạn có thông báo mới");
        DateTime now = DateTime.now();
        Timestamp timestamp = Timestamp.fromDate(now);
        String timeNow = DateFormat('h:mma').format(now);
        await FirebaseFirestore.instance.collection("notification").doc(follower).collection("detail").doc().set({
          "ID":idUser,
          "content":"$username vừa đăng một tin mới",
          "ts": timeNow,
          "timestamp":timestamp,
          "check":false
        });
      }



    }
  }


  onLoad()async{
      idUser =(await SharedPreferenceHelper().getIdUser())!;
      username=(await SharedPreferenceHelper().getUserName())!;
      DocumentSnapshot data1 = await FirebaseFirestore.instance.collection("user")
          .doc(idUser).get();
      avatar = data1.get("imageAvatar");
      List followers=[];
        DocumentSnapshot data = await FirebaseFirestore.instance.collection("relationship")
            .doc(idUser).collection("follower").doc(idUser).get();
        followers = data.get("data");
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
      body:
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 40 ,left: 20 , right: 20),
                    child: Column(
                        children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Row(
                                   children: [
                                     IconButton(
                                         onPressed:(){
                                            Navigator.of(context).pop();
                                         },
                                         icon: Icon(Icons.arrow_back,size: 30,)),
                                     Text("Tạo bài viết",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                   ],
                                 ),
                                 GestureDetector(
                                   onTap: ()async{
                                     print("Press Button Đăng");
                                     print(typed);
                                     if (_selectedImage != null) {
                                       await uploadImage(_selectedImage!); // Tải hình ảnh lên trước khi thêm bài viết
                                     }
                                     addNews(typed);
                                     Navigator.of(context).pop();
                                   },
                                   child: Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(4),
                                        color: typed ? Colors.blue.shade200 :Colors.grey.shade300
                                     ),
                                     child: Padding(
                                       padding:  EdgeInsets.all(4),
                                       child: Center(child: Text("ĐĂNG",style: TextStyle(
                                           color: typed ? Colors.blueAccent :Colors.grey.shade500,
                                        fontSize: 20
                                       ),)),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                avatar==""? CircleAvatar(
                                  backgroundImage: Image.network("https://www.dolldivine.com/rinmaru/cartoon-avatar-creator-thumbnail.jpg").image,
                                  radius: 30,
                                ):CircleAvatar(
                                  backgroundImage: Image.network(avatar).image,
                                  radius: 30,
                                ),
                                SizedBox(width: 14,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                    Row(
                                      children: [
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
                                                            List friends = await DatabaseMethods().getFriends(idUser);
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
                                        TextButton(
                                          onPressed: (){
                                            _pickImageGallery();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: Colors.lightBlueAccent.shade100
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.add,size: 16,color: Colors.blue.shade600,),
                                                  Text("Album",style: TextStyle(color:Colors.blue.shade600, ),),
                                                  Icon(Icons.arrow_drop_down,size: 16,color: Colors.blue.shade600,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),
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
                                  hintText: "Bạn đang nghĩ gì ?",
                                  hintStyle: TextStyle(fontSize: 24),
                                ),
                                onChanged: (value){
                                  if(value==""){
                                    setState(() {
                                      typed=false;
                                    });
                                  }else{
                                    setState(() {
                                      typed=true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          // Ảnh được chọn ở đây ở đây
                        ],
                      ),
                ),
                _selectedImage!=null ? Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width/1,
                  child: Image(
                    image: Image.file(_selectedImage!).image,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width/1,
                    height: 700,
                  ),
                ):
                SizedBox(),
              ],
            ),
          ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      _pickImageGallery();
                      print(_selectedImage);
                    },
                    child: Icon(Icons.photo_library_outlined ,
                      color: Colors.green,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.people_alt_rounded ,
                      color:  Colors.blueAccent,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.emoji_emotions_outlined ,
                      color: Colors.deepOrange,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                      });
                    },
                    child: Icon(Icons.location_pin ,
                      color:  Colors.red,
                    )),
              ],
            ),
          ],
        ),
      ),
      );

  }
}
class ViewerDialog extends StatefulWidget {
  final List friends;
  ViewerDialog({super.key, required this.friends});

  @override
  _ViewerDialogState createState() => _ViewerDialogState();
}

class _ViewerDialogState extends State<ViewerDialog> {
  Map<String, bool> selectedViewer = {};
  Future<Map<String, dynamic>> fetchFriendData(String id) async {
    // Giả sử bạn sử dụng Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user').doc(id).get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  void initState() {
    super.initState();
    for (var item in widget.friends) {
      selectedViewer[item] = false;
    }
  }

  void _closeDialog() {
    Navigator.of(context).pop(selectedViewer);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.height - 200,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView(
                  children: widget.friends.map((id) {
                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchFriendData(id),
                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text("No data found"));
                        } else {
                          String image = snapshot.data!['imageAvatar'];
                          String name = snapshot.data!['Username'];
                          return CheckboxListTile(
                            title: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: Image.network(image).image,
                                  radius: 30,
                                ),
                                SizedBox(width: 20),
                                Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            value: selectedViewer[id] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                selectedViewer[id] = value!;
                              });
                            },
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              TextButton(
                onPressed: _closeDialog,
                child: Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

