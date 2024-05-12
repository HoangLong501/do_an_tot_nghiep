import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
class CreateNewsFeed extends StatefulWidget {
  const CreateNewsFeed({super.key});

  @override
  State<CreateNewsFeed> createState() => _CreateNewsFeedState();
}

class _CreateNewsFeedState extends State<CreateNewsFeed> {
  File? _selectedImage;
  bool typed=false;
  String? idUser , username , newsFeedId , urlImage;


  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnImage!.path);
      print(_selectedImage);
    });
  }
  Future uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(20);
    final ref = FirebaseStorage.instance.ref().child('$username/images/$nameImage.jpg');
    final taskSnapshot = await ref.putFile(image);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    urlImage = imageUrl;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SingleChildScrollView(
            child: Padding(
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
                               onTap: (){
                                 print("1");
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
                              backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,
                              radius: 24,
                            ),
                            SizedBox(width: 14,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name user",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
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
                      _selectedImage!=null ? Container(
                        child: Image(
                          image: Image.file(_selectedImage!).image,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width/1,
                          height: 700,
                        ),
                      ):
                      SizedBox(),
                    ],
                  ),
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
