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
  String imageAvata="",imageBackground="",username="",relationship="",address=""
          ,born="",phone="",sex="",birthday="",email="",urlImage="";
  final picker = ImagePicker();
  File? imageFile,imageFileBackground;
  String convertToStars(String text) {
    return '*' * text.length;
  }
  Future<void> getUserInfo() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfoById(widget.idUser);
      imageBackground = querySnapshot.docs[0]["imageBackground"];
      relationship = querySnapshot.docs[0]["relationship"];
      born = querySnapshot.docs[0]["born"];
      address = querySnapshot.docs[0]["address"];
    }catch(error){
      print("lỗi lấy thông tin người dùng info");
    }
  }
  Future<void> getUser() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(widget.idUser);
      username = querySnapshot.docs[0]["Username"];
      imageAvata = querySnapshot.docs[0]["imageAvatar"];
      phone = querySnapshot.docs[0]["Phone"];
      email = querySnapshot.docs[0]["E-mail"];
      birthday = querySnapshot.docs[0]["Birthdate"];
      sex = querySnapshot.docs[0]["Sex"];
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }
  }
  Future getImage() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = File(returnImage!.path);
    setState(()  {

    });
  }
  Future getImageBackground() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFileBackground = File(returnImage!.path);
    setState(()  {

    });
  }
  Future uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(10);
    final ref = FirebaseStorage.instance.ref().child('${widget.idUser}/images/$nameImage.jpg');
    final taskSnapshot = await ref.putFile(image);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    urlImage = imageUrl;
    setState(() {

    });
  }

  onLoad() async {
    await getUser();
    await getUserInfo();
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
                          await uploadImage(imageFile!);
                          Map<String,dynamic> imageInfoMap={
                            "imageAvatar":urlImage,
                          };
                          await DatabaseMethods().updateUser(widget.idUser, imageInfoMap);
                          print("đã thay đổi ảnh thành công");
                          showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                scale: a1.value,
                                child: Opacity(
                                  opacity: a1.value,
                                  child: AlertDialog(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    title: Column(
                                      children: [
                                        Text('Thông báo'),
                                        Divider(height: 0.1,color: Colors.grey.shade400,),
                                      ],
                                    ),
                                    content:Text('Bạn đã đổi ảnh đại diện thành công',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {
                              return SizedBox.shrink();
                            },
                          );
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
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:imageFile==null?NetworkImage(imageAvata):Image.file(imageFile!).image,
                        ),
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
                          await uploadImage(imageFileBackground!);
                          Map<String,dynamic> imageInfoMap={
                            "imageBackground":urlImage,
                          };
                          await DatabaseMethods().updateUserInfo(widget.idUser, imageInfoMap);
                          print("đã thay đổi ảnh thành công");
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
                      child:Image(
                        image:imageFileBackground==null? Image.network(imageBackground,).image
                            :Image.file(imageFileBackground!).image,
                      )
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
                      _buildDetailItem("Tên", username, Icons.account_circle, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserName(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Password", convertToStars("Lybach12345@"), Icons.lock, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePassword(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Mối quan hệ", relationship, Icons.favorite, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateRelationShip(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Địa chỉ", address, Icons.home_outlined, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAddress(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Quê quán", born, Icons.location_on_outlined, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBorn(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Số điện thoại", phone, Icons.phone, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePhone(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Giới tính", sex, Icons.person, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSex(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Ngày sinh", birthday, Icons.cake, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBirthDay(idUser: widget.idUser)));
                      }),
                      _buildDetailItem("Email", email, Icons.alternate_email_rounded, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEmail(idUser: widget.idUser)));
                      }),
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
