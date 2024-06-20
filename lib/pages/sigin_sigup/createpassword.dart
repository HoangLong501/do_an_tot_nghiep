
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../service/shared_pref.dart';
import '../lib_class_import/user.dart';
import 'login.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
class CreatePassWord extends StatefulWidget {
  final String surname;
  final String name;
  final String birthDate;
  final String sex;
  final String phone;
  const CreatePassWord({super.key, required this.surname,required this.name,
                        required this.birthDate,required this.sex,required this.phone});

  @override
  State<CreatePassWord> createState() => _CreatePassWordState();
}

class _CreatePassWordState extends State<CreatePassWord> {
  List<Person> listUser=[];
  bool _obscureText = true;
  String passWord ="",rePassWord="",date="";
  RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController repasswordcontroller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  getvaluefromfirebase()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("test").get();
    print("do dai: ${querySnapshot.size}" );
  }
  String generateID(String email) {
    return email.replaceAll("@gmail.com", "");
  }

onLoad()async{
  listUser= await DatabaseMethods().getUserLimit10();
  date ="Ngày ${DateTime.now().day} Tháng ${DateTime.now().month} Năm ${DateTime.now().year}";
  setState(() {

  });
}
  @override
   initState()  {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
        body: SingleChildScrollView(
        child:  Form(
        key: _formKey,
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.yellow.shade50,
                      Colors.red.shade50,
                      Colors.lightBlue.shade50,
                    ],
                    stops: [0.0, 0.1, 1.0],
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),

                          Text(
                            'Tạo mật khẩu của bạn',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tạo mật khẩu gồm ít nhất 8 chữ cái hoặc chữ số. Bao gồm chữ hoa, chữ thường, chữ số và kí tự đặt biệt. ',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
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
                          TextFormField(
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
                              hintText: 'Nhập lại mật khẩu',
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
                          SizedBox(height: 20,),
                          Container(
                            height: 45,
                            width: 390,
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(_formKey.currentState!.validate()){
                                    setState(() {
                                        passWord=passwordcontroller.text;
                                        rePassWord=repasswordcontroller.text;
                                        _SignUpState();


                                    });
                                  }
                                  // Xử lý đăng nhập ở đây

                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.blue.shade800),
                                ),
                                child: Text(
                                  'Tạo tài khoản',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 190),
                          Center(
                            child: TextButton(

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>Login()),
                                );
                              },
                              child: Text(
                                'Bạn đã có tài khoản ư?',
                                style: TextStyle(color: Colors.blue.shade900, fontSize: 16),
                              ),
                            ),
                          ),
                        ]
                    )
                )
            )
        )
        )
    );
  }
  Future<void> _SignUpState() async {
    String userName = "",
        birthDate = "",
        sex = "",
        phone = "",
        email = "",
        image = "";
    String? resualString = await SharedPreferenceHelper().getUerSinup();
    int resual = int.parse(resualString.toString());
    if (resual == 1) {

      phone = widget.phone;
    } else {
      //print("else 1");
      email = widget.phone;
    }
    userName = "${widget.surname} ${widget.name}";
    birthDate = widget.birthDate;
    sex = widget.sex;

      if (passWord != null ) {
       // print("dong 216");
        if (resual == 2) {
          //print("vao if");
          try {
            print(email);
            print(passWord);
            UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: email, password: passWord);
            String id = generateID(email);

            Map<String, dynamic> userInfoMap = {
              "IdUser": id,
              "Username": userName,
              "SearchKey":widget.name,
              "E-mail": email,
              "Sex": sex,
              "Birthdate": birthDate,
              "Phone": "",
              "imageAvatar": "https://i.ibb.co/jzk0j6j/image.png",
              "News": [],
              "Search":[]
            };
            print("UserInfoMap before adding: $userInfoMap");
            DatabaseMethods().addUserDetail(id, userInfoMap);
            // Map<String, dynamic> relaInfoMap = {
            //   "ID":id,
            // };
            //DatabaseMethods().addRelationship(id,relaInfoMap );
            for(int i=0;i<listUser.length;i++){
              if(listUser[i].id==id){
                continue;
              }
              Map<String , dynamic> statusInfoMap={
                "id":listUser[i].id,
                "check":0
              };
              await DatabaseMethods().addHints(id, listUser[i].id, statusInfoMap);
            }
            Map<String,dynamic> userInfoMap1={
              "id":id,
              "relationship":"",
              "born":"",
              "address":"",
              "since": date,
              "imageBackground":"https://i.ibb.co/9WYddvb/image.png"
            };
            await DatabaseMethods().addUserInfo(id, userInfoMap1);
            await SharedPreferenceHelper().saveUserName(userName);
            await SharedPreferenceHelper().saveIdUser(id);
            await SharedPreferenceHelper().saveUserPhone(phone);
            await SharedPreferenceHelper().saveUserEmail(email);
            await SharedPreferenceHelper().saveImageUser(image);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đăng kí tài khoản thành công!"),));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
          } on FirebaseAuthException catch (e) {
            print("lỗi code FirebaseAuth: ${e.code}");
            if (e.code == 'Mật khẩu yếu') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text("Mật khẩu quá yếu "),
                ),
              );
            } else if (e.code == 'email đã được sử dụng') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Tài khoản đã tồn tại"),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } catch (ex) {
            print(ex);
          }
        }else{
          print("else");
        }

    }
  }
}
