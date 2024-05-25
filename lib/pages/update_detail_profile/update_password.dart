import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/database.dart';
import '../../service/shared_pref.dart';
class UpdatePassword extends StatefulWidget {
  final String idUser;
  const UpdatePassword({super.key,required this.idUser});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool _obscureText = true;
  bool testPassword=false;
  final _formKey = GlobalKey<FormState>();
  RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController repasswordcontroller=TextEditingController();
  TextEditingController oldpasswordcontroller=TextEditingController();
  String email="",password="",oldPassword="",rePassword="";
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(widget.idUser);
      email = querySnapshot.docs[0]["E-mail"];
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }
  }

  onLoad() async {
    await getData();
    print(email);
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
            "Mật khẩu",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      body:Form(
        key: _formKey,
      child: Container(
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
                      "Nhập mật khẩu",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Divider(height: 0.1,color: Colors.grey.shade300,),
                  SizedBox(height: 20,),
                 testPassword?
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          validator: (value){
                            bool pass = passwordRegex.hasMatch(value.toString());
                            if(value==null||value.isEmpty || pass == false){
                              return "Mật khẩu không được để trống và phải đúng định dạng!";
                            }
                            return null;
                          },
                          controller: passwordcontroller,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Nhập khẩu mới",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText?Icons.visibility:Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                              )
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          validator: (value){
                            bool p =  value.toString() != passwordcontroller.toString();
                            if(value==null||value.isEmpty || p != true ){
                              return "Mật khẩu nhập lại không đúng!";
                            }
                            return null;
                          },
                          controller: repasswordcontroller,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Nhập lại mật khẩu mới",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText?Icons.visibility:Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });

                                },
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                  password=passwordcontroller.text;
                                  rePassword=repasswordcontroller.text;
                                });
                                await updatePassword(password);
                                await sendPasswordResetEmail(email);
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
                                          content:Text('Bạn đã đổi mật khẩu thành công, vui lòng đăng nhập lại',
                                            style: TextStyle(
                                                fontSize: 16
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () async {
                                                await logout();
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
                    ],
                  ):
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: oldpasswordcontroller,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Nhập khẩu hiện tại của bạn",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                              ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                              onPressed: (){
                                setState(() {
                                  _obscureText=!_obscureText;
                                });
                              },
                            )
                          ),
                        ),
                      ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          oldPassword = oldpasswordcontroller.text;
                          testPassword =await checkPassword(email,oldPassword);
                          if(testPassword){
                            testPassword==true;
                          }else{
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
                                      content:Text('Mật khẩu bạn nhập không đúng',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            oldpasswordcontroller.text="";
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

                          setState(() {

                          });
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
                          "Nhập",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(

                        onPressed: (){

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
  Future<bool> checkPassword(String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      // Nếu đăng nhập thành công thì trả về true
      if(userCredential.user != null) {
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
  // Hàm này dùng để cập nhật mật khẩu của người dùng đã đăng nhập
  Future<void> updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt lại mật khẩu thành công')),
        );
      } catch (e) {
        print("Lỗi: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đặt lại mật khâ: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt lại mật khẩu thất bại')),
      );
    }
  }
// Hàm này gửi email đặt lại mật khẩu cho người dùng
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã gửi email đặt lại mật khẩu')),
      );
    } catch (e) {
      print("lỗi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('lỗi gửi email đặt lại mật khẩu')),
      );
    }
  }
Future<void> logout() async {
  await SharedPreferenceHelper().saveUserName("");
  await SharedPreferenceHelper().saveIdUser("");
  await SharedPreferenceHelper().saveUserPhone("");
  await SharedPreferenceHelper().saveImageUser("");
  await SharedPreferenceHelper().saveSex("");
  await SharedPreferenceHelper().saveBirthDate("");
  Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
}

}

