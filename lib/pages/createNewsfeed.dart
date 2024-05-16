import 'dart:io';
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
  String idUser="" , username="" , newsFeedId="" , urlImage="";


  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnImage!.path);
      print(_selectedImage);
    });
  }
  Future uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(10);
    final ref = FirebaseStorage.instance.ref().child('$username/images/$nameImage.jpg');
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
      List react=[0,0,0] ;
      Map<String, dynamic> newsInfoMap = {
        "ID":id,
        "UserID":idUser,
        "userName": username,
        "content": contentController.text,
        "image": urlImage,
        "ts": timeNow,
        "newTimestamp":timestamp,
        "react": react,
        "id_comment":idComment,
      };
      Map<String, dynamic> commentInfoMap = {
        "ID":idComment,
      };
      await DatabaseMethods().addNews(idUser, id, newsInfoMap);
      await DatabaseMethods().initComment(idComment, commentInfoMap);
    }
  }


  onLoad()async{
      username=(await SharedPreferenceHelper().getUserName())!;
      idUser =(await SharedPreferenceHelper().getIdUser())!;
      print(idUser);
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
                                     Icon(Icons.arrow_back,size: 30,),
                                     SizedBox(width: 10,),
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
                                CircleAvatar(
                                  backgroundImage: Image.network("https://www.dolldivine.com/rinmaru/cartoon-avatar-creator-thumbnail.jpg").image,
                                  radius: 24,
                                ),
                                SizedBox(width: 14,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Colors.lightBlueAccent.shade100
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                              children: [
                                                Icon(Icons.lock,size: 16,color: Colors.blue.shade600,),
                                                Text("Chỉ mình tôi",style: TextStyle(color:Colors.blue.shade600, ),),
                                                Icon(Icons.arrow_drop_down,size: 16,color: Colors.blue.shade600,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
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
