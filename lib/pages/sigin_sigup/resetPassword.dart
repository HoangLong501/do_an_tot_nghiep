import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back_rounded)),
            Text("Lấy lại mật khẩu")
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
            child: Container(
              padding: EdgeInsets.only(top: 10,left: 20,right: 20),
              height: MediaQuery.of(context).size.height/3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hãy cho chúng tôi biết email mà bạn đã đăng ký , chúng tôi sẽ giúp cài đặt lại mật khẩu thông qua email đó",style: TextStyle(
                    fontSize: 20 , color: Colors.black45 ,fontWeight: FontWeight.w600
                  ),),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email không được để trống!';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Email không hợp lệ!';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email đã đăng ký của bạn ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                    ),
                  ),
                  TextButton(onPressed: ()async{
                    if (_formKey.currentState!.validate()) {
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text("Lấy lại mật khẩu"),
                              content: Text("Chúng tôi xác nhận tin đến email của bạn , hãy kiểm tra "
                                  "email và đặt lại mật khẩu mới"),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: Text("Ok"))
                              ],
                            );
                          });
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: emailController.text);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                    }
                  }, child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text("Xác nhận" ,style: TextStyle(fontSize: 20 ,color: Colors.black),)),
                  ))
                ],
              ),
            ),
        ),
      ),
    );
  }
}
