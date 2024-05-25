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

import '../../service/database.dart';
class EditProfileDetail extends StatefulWidget {
  final String idUser;
  const EditProfileDetail({super.key,required this.idUser});

  @override
  State<EditProfileDetail> createState() => _EditProfileDetailState();
}

class _EditProfileDetailState extends State<EditProfileDetail> {
  String imageAvata="",imageBackground="",username="",relationship="",address=""
          ,born="",phone="",sex="",birthday="",email="";
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
                   Container(
                      height: 160,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:NetworkImage(imageAvata),
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
                  Padding(
                      padding: EdgeInsets.only(right: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child:Image(
                        image: Image.network(imageBackground,).image,
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
                      Container(
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateUserName(idUser: widget.idUser)));
                            },
                            child:   Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 20,
                                      child: Icon(
                                        Icons.account_circle,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    )
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width/1.3,
                                      child: Text(username,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text("Tên",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePassword(idUser: widget.idUser)));
                            },
                            child:   Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 20,
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    )
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width/1.3,
                                      child: Text(convertToStars("Lybach12345@"),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text("Password",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child:GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateRelationShip(idUser: widget.idUser)));
                          },
                          child:   Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child:CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 20,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.black,
                                    size: 26,
                                  ),
                                )
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width:MediaQuery.of(context).size.width/1.3,
                              child: Text(relationship==""?"mối quan hệ":relationship,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ],
                        ),
                        )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child:GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateAddress(idUser: widget.idUser)));
                          },
                          child:   Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child:CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 20,
                                  child: Icon(
                                    Icons.home_outlined,
                                    color: Colors.black,
                                    size: 26,
                                  ),
                                )
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width:MediaQuery.of(context).size.width/1.3,
                              child: Text(address==""?"Tỉnh /Thành phố hiện tại":address,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ],
                        ),
                        )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),

                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child:GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateBorn(idUser: widget.idUser)));

                          },
                          child:   Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child:CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 20,
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 26,
                                  ),
                                )
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width:MediaQuery.of(context).size.width/1.3,
                              child: Text(born==""?"Quê quán":born,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ],
                        ),
                        )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePhone(idUser: widget.idUser)));
                            },
                            child:   Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child:CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 20,
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    )
                                ),
                                SizedBox(width: 20,),
                                Container(
                                  width:MediaQuery.of(context).size.width/1.3,
                                  child: Text(phone==""?"Số điện thoại":phone,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateSex(idUser: widget.idUser)));
                            },
                            child:   Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child:CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 20,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                  )
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width/1.3,
                                      child: Text("Nam",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(sex,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateBirthDay(idUser: widget.idUser)));
                            },
                            child:   Row(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 20,
                                    child: Icon(
                                      Icons.cake,
                                      color: Colors.black,
                                      size: 26,
                                    ),
                                  )
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width/1.3,
                                      child: Text(birthday,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text("Ngày sinh",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateEmail(idUser: widget.idUser)));
                            },
                            child:   Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 20,
                                      child: Icon(
                                        Icons.alternate_email_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    )
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width/1.3,
                                      child: Text(email==""?"Email":email,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text("Email",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/9),
                          child: Divider(height: 0.1,color: Colors.grey.shade300,)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
