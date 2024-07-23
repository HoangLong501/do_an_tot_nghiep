import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/userDetailProvider.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_address.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_birthday.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_born.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_email.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_password.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_phone.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_relationship.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_sex.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_username.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../service/database.dart';
import 'package:random_string/random_string.dart';
class EditProfileDetail extends StatefulWidget {
  final String idUser;
  const EditProfileDetail({super.key,required this.idUser});

  @override
  State<EditProfileDetail> createState() => _EditProfileDetailState();
}

class _EditProfileDetailState extends State<EditProfileDetail> {
  String urlImage="";
  final picker = ImagePicker();
  File? imageFile,imageFileBackground;

  String convertToStars(String text) {
    return '*' * text.length;
  }
   getImage() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(returnImage!=null){
       imageFile = File(returnImage.path);
     }

  }
   getImageBackground() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnImage!=null){
      imageFileBackground = File(returnImage.path);
    }

  }
   uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(10);
    final ref = FirebaseStorage.instance.ref().child('${widget.idUser}/images/$nameImage.jpg');
    final taskSnapshot = await ref.putFile(image);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    urlImage = imageUrl;
  }

  onLoad() async {
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
      appBar: AppBar(
        title: Center(
          child: Text(
            "Chỉnh sửa trang cá nhân",
            style: TextStyle(
                fontSize:18,
                fontWeight:FontWeight.bold
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(height: 0.1,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(left: 20,bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Ảnh đại diện",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await getImage();
                          if(imageFile!=null){
                            await uploadImage(imageFile!);
                            Map<String,dynamic> imageInfoMap={
                              "imageAvatar":urlImage,
                            };
                            await DatabaseMethods().updateUser(widget.idUser, imageInfoMap);
                            userDetailProvider.updateAvatar(urlImage);
                            // print("đã thay đổi ảnh thành công");
                            // setState(() {
                            //   imageAvatar = urlImage;
                            // });
                          }
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text("Thông báo"),
                              content: Text("Bạn đã thay đổi ảnh đại diện thành công"),
                            );
                          });

                        },
                        child: Text(
                          "Chỉnh sửa",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Container(
                    height: 160,
                    child: userDetailProvider.avatar!=""? CircleAvatar(
                      radius: 80,
                      backgroundImage:Image.network(userDetailProvider.avatar).image,
                    ):CircleAvatar(backgroundColor: Colors.blueAccent,),
                  ),
                ],
              ),
            ),
            Divider(height: 0.1,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(left: 20,bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Ảnh bìa",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await getImageBackground();
                          if(imageFileBackground!=null){
                            await uploadImage(imageFileBackground!);
                            Map<String,dynamic> imageInfoMap={
                              "imageBackground":urlImage,
                            };
                            await DatabaseMethods().updateUserInfo(widget.idUser, imageInfoMap);
                            userDetailProvider.updateBackground(urlImage);
                            // setState(() {
                            //   imageBackground = urlImage;
                            // });
                          }

                        },
                        child: Text(
                          "Chỉnh sửa",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Container(
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child:userDetailProvider.background!=""? Image(
                          image: Image.network(userDetailProvider.background,).image
                        ):Image(image: Image.asset("assets/images/backgroundEmpty.png").image)
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 0.1,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(left: 20,bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Chi tiết",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Chỉnh sửa",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                          onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserName(idUser: widget.idUser)));
                      }, child: Row(
                        children: [
                          Icon(Icons.account_circle ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tên" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.name, style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePassword(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.lock ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Password" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(convertToStars("Lybach12345@"), style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateRelationShip(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.favorite ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mối quan hệ" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.relationship!=""?userDetailProvider.relationship:"Chưa có thông tin", style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAddress(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.home_outlined ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Địa chỉ" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.address!=""?userDetailProvider.address:"Chưa có thông tin", style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBorn(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.location_on_outlined ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quê quán" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.born!=""?userDetailProvider.born:"Chưa có thông tin", style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                           // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePhone(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.phone ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Số điện thoại" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.phone!=""?userDetailProvider.phone:"Chưa có thông tin", style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSex(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.person ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Giới tính" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.sex!=""?userDetailProvider.sex:"Chưa có thông tin", style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBirthDay(idUser: widget.idUser)));
                          }, child: Row(
                        children: [
                          Icon(Icons.cake ,size: 32,),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ngày sinh" , style: TextStyle(color: Colors.grey.shade600 , fontSize: 18 ,fontWeight:FontWeight.w600 ),),
                              Text(userDetailProvider.birthday!=""?userDetailProvider.birthday:"Chưa có thông tin", style: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight:FontWeight.w500 ),),
                            ],
                          )
                        ],
                      )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon, Function() onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 20,
                child: Icon(icon, color: Colors.black, size: 26),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Text(
                      value,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    child: Text(
                      title,
                      style:
                      TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 9),
          child: Divider(height: 0.1, color: Colors.grey.shade300),
        ),
      ],
    );
  }
}