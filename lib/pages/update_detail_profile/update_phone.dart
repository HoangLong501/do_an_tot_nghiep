import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../service/database.dart';
class UpdatePhone extends StatefulWidget {
  final String idUser;
  const UpdatePhone({super.key,required this.idUser});

  @override
  State<UpdatePhone> createState() => _UpdatePhoneState();
}

class _UpdatePhoneState extends State<UpdatePhone> {
  TextEditingController phoneController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String phone="",oldPhone="";
  RegExp phoneNumberRegex = RegExp(r'^0\d{9}$');

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(widget.idUser);
      oldPhone = querySnapshot.docs[0]["Phone"];
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }
  }
  Future<bool>testPhone() async {
    QuerySnapshot querySnapshot= await DatabaseMethods().getUserByPhone(phone);
    if(querySnapshot.docs.length!=0){
      return true;
    }
    return false;
  }
  onLoad(){
    getData();
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Số điện thoại",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      body: Form(
    key: _formKey,
      child:Container(
        height: MediaQuery.of(context).size.height/1.75,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Nhập số điện thoại ",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Divider(height: 0.1,color: Colors.grey.shade300,),
                  SizedBox(height: 20,),
                  Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLength: 10,
                      validator: (value) {
                        bool checkPhone = phoneNumberRegex.hasMatch(value.toString());
                        if (value == null || value.isEmpty || checkPhone !=true) {
                          return 'Số điện thoại không được để trống!';
                        }
                        return null;
                      },
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho phép nhập số
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: oldPhone,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          phone = phoneController.text;
                          bool phoneTest=await testPhone();
                          if(phoneTest){
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
                                      content:Text(' $phone đã được dùng vui lòng dùng dùng số điện thoại khác',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            phoneController.text="";
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

                          }else{
                            Map<String,dynamic> userInfoMap={
                              "Phone":phone
                            };
                            await DatabaseMethods().updateUser(widget.idUser, userInfoMap);
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
                                      content:Text('Bạn đã đổi số điện thoại $oldPhone thành $phone',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
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

                          }
                        }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue.shade600,),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )
                            )
                        ),
                        child: Text(
                          "Xác nhận",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
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
                                    content:Text('Bạn muốn hủy thay đổi và thoát ra ngoài chứ',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text("Cancel"))
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey.shade300,),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )
                            )
                        ),
                        child: Text(
                          "Hủy",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ),
                  )
                ]

            ),
          ),
        ),
      )
      ),
    );
  }
}
