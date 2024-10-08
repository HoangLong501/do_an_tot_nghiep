import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../service/database.dart';
import '../../service/shared_pref.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  TextEditingController userNameConTroller = TextEditingController();
  TextEditingController passWordConTroller = TextEditingController();
  Color facebookBlue = const Color(0xFF1877F2);
  final _formKey = GlobalKey<FormState>();
  String userName="", passWord="";
  String email="",id="",phone="",username="",image="",birthDate="",sex="";





  onLoad()async{
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
  
),
      body: SingleChildScrollView(
    child: Form(
    key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Bắt đầu từ trái
              end: Alignment.centerRight, // Kết thúc ở phải
              colors: [
                Colors.yellow.shade50, // Màu vàng
                Colors.red.shade50, // Màu đỏ
                Colors.lightBlue.shade50, // Màu xám
              ],
              stops: [0.0,0.1,1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
        
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Độ bo góc
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover, // Đảm bảo hình ảnh vừa khớp trong container
                    ),
                  ),
                ),
        
                SizedBox(height: 70),
                TextFormField(
                  validator: (value) {

                    if (value == null || value.isEmpty ) {
                      return 'Email hoặc số điẹn thoại không được đẻ trống!';
                    }
                    return null;
                  },
                  controller: userNameConTroller,
                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email hoặc số điện thoại',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
        
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {

                    if (value == null || value.isEmpty ) {
                      return 'Mật khẩu không được để trống!';
                    }
                    return null;
                  },
                  controller: passWordConTroller,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // Thay đổi icon tùy theo trạng thái ẩn hay hiện mật khẩu
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // Đảo ngược trạng thái ẩn mật khẩu
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        userName = userNameConTroller.text;
                        print(userName);
                        passWord = passWordConTroller.text;
                        _userLogin();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),                  ),
                    child: Text('Đăng nhập',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 20
                     ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Xử lý quên mật khẩu ở đây
                  },
                  child: Text('Bạn quên mật khẩu ư?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                  ),
                  ),
                ),
                SizedBox(height: 70),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý đăng nhập ở đây
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>Register()),
                      );
                    },
                    style: ButtonStyle(
        
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.deepPurpleAccent.shade200)), // Màu viền
                      ),
                    child: Text('tạo tài khoản mới',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
  Future<void> _userLogin()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: userName, password: passWord);
      QuerySnapshot querySnapshot=await DatabaseMethods().getUserByEmail(userName);
      print('Number of documents: ${querySnapshot.size}');
      print(userName);
      birthDate="${querySnapshot.docs[0]["Birthdate"]}";
      email="${querySnapshot.docs[0]["E-mail"]}";
      id="${querySnapshot.docs[0]["IdUser"]}";
      phone="${querySnapshot.docs[0]["Phone"]}";
      sex= "${querySnapshot.docs[0]["Sex"]}";
      username="${querySnapshot.docs[0]["Username"]}";
      image="${querySnapshot.docs[0]["imageAvatar"]}";
      await SharedPreferenceHelper().saveUserName(username);
      await SharedPreferenceHelper().saveIdUser(id);
      await SharedPreferenceHelper().saveUserPhone(phone);
      await SharedPreferenceHelper().saveImageUser(image);
      await SharedPreferenceHelper().saveSex(sex);
      await SharedPreferenceHelper().saveBirthDate(birthDate);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    }on FirebaseAuthException catch(e){
      if(e.code=='tài khoản không tồn tại'){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("mail không tồn tại",style: TextStyle(fontSize: 18),),backgroundColor: Colors.orange,));
      }else if(e.code=='sai mật khẩu'){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("sai mật khẩu",style: TextStyle(fontSize: 18),),backgroundColor: Colors.orange,));
      }
    }
  }
}

