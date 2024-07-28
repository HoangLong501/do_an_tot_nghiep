import 'dart:math';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/resetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/database.dart';
import '../../service/shared_pref.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Color facebookBlue = const Color(0xFF1877F2);
  final _formKey = GlobalKey<FormState>();
  String userName="", passWord="";
  String email="",id="",phone="",username="",image="",birthDate="",sex="";
  onLoad()async{
    if (!mounted) return;
    setState(() {
      // Update state
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
    // appBar: AppBar(
    //   automaticallyImplyLeading: false,
    // ),
      body: SingleChildScrollView(
    child: Form(
    key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
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
              mainAxisAlignment: MainAxisAlignment.end,
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
                      return 'Email không được đẻ trống!';
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
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      return 'Mật khẩu không được để trống!';
                    }
                    return null;
                  },
                  controller: passwordController,
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
                        _formKey.currentState!.save();
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
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    children: [
                    Text("Đăng nhập bằng google "),
                    TextButton(
                      onPressed: (){
                        print("đã nhấn vaào google");
                        signInWithGoogle();
                      },
                      child: Text("Sign in"))
                    ],
                  ),
                ),
                TextButton(
                  onPressed: ()async{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ResetPassword()));
                    // Xử lý quên mật khẩu ở đây
                  },
                  child: Text('Bạn quên mật khẩu ư?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                  ),
                  ),
                ),
                 SizedBox(height: MediaQuery.of(context).size.height/4,),
                 Container(
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

  Future<void> _userLogin() async {
    List<String> accountTest =["tieuviem@gmail.com","trungnhan@gmail.com" , "longhoang@gmail.com",
    "hoaphat@gmail.com","mocnha@gmail.com" , "phamtruong@gmail.com" , "lybach@gmail.com" ,
      "luclyly@gmail.com" , "thienvuquach@gmail.com" , "laphong@gmail.com" , "mimi@gmail.com",
      "meocon@gmail.com" ,"luchi@gmail.com" ,"atu@gmail.com" , "moclan@gmail.com" , "lyhao@gmail.com"
    ];
    if(accountTest.contains(emailController.text)){
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserByEmail(emailController.text);
      birthDate = "${querySnapshot.docs[0]["Birthdate"]}";
      email = "${querySnapshot.docs[0]["E-mail"]}";
      id = "${querySnapshot.docs[0]["IdUser"]}";
      phone = "${querySnapshot.docs[0]["Phone"]}";
      sex = "${querySnapshot.docs[0]["Sex"]}";
      username = "${querySnapshot.docs[0]["Username"]}";
      image = "${querySnapshot.docs[0]["imageAvatar"]}";
      await SharedPreferenceHelper().saveUserName(username);
      await SharedPreferenceHelper().saveIdUser(id);
      await SharedPreferenceHelper().saveUserPhone(phone);
      await SharedPreferenceHelper().saveImageUser(image);
      await SharedPreferenceHelper().saveSex(sex);
      await SharedPreferenceHelper().saveBirthDate(birthDate);
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
                content:Text(' Bạn có muốn lưu Mật khẩu để lần sau đăng nhập thuận tiện hơn không!',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () async {
                      Map<String,dynamic> infoMap={
                        "id":id,
                        "email":email,
                        "password":passWord,
                        "name":username,
                        "avata":image
                      };
                      List<Map<String,dynamic>> listinfoMap=[];
                      listinfoMap.add(infoMap);
                      List<Map<String, dynamic>>? userInfoList = await SharedPreferenceHelper().getUserInfoList();
                      if(userInfoList==null){
                        await SharedPreferenceHelper().saveUserInfoListUser(listinfoMap);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                      }else{
                        for(var userInfo in userInfoList){
                          if(userInfo["id"]==infoMap["id"]){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                            return;
                          }
                        }
                        await SharedPreferenceHelper().addUserInfo(infoMap);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                      }
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    }else{
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        User? user = userCredential.user;
        if (user != null && user.emailVerified) {

          QuerySnapshot querySnapshot = await DatabaseMethods().getUserByEmail(emailController.text);
          birthDate = "${querySnapshot.docs[0]["Birthdate"]}";
          email = "${querySnapshot.docs[0]["E-mail"]}";
          id = "${querySnapshot.docs[0]["IdUser"]}";
          phone = "${querySnapshot.docs[0]["Phone"]}";
          sex = "${querySnapshot.docs[0]["Sex"]}";
          username = "${querySnapshot.docs[0]["Username"]}";
          image = "${querySnapshot.docs[0]["imageAvatar"]}";
          await SharedPreferenceHelper().saveUserName(username);
          await SharedPreferenceHelper().saveIdUser(id);
          await SharedPreferenceHelper().saveUserPhone(phone);
          await SharedPreferenceHelper().saveImageUser(image);
          await SharedPreferenceHelper().saveSex(sex);
          await SharedPreferenceHelper().saveBirthDate(birthDate);
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
                    content:Text(' Bạn có muốn lưu Mật khẩu để lần sau đăng nhập thuận tiện hơn không!',
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () async {
                          Map<String,dynamic> infoMap={
                            "id":id,
                            "email":email,
                            "password":passWord,
                            "name":username,
                            "avata":image
                          };
                          List<Map<String,dynamic>> listinfoMap=[];
                          listinfoMap.add(infoMap);
                          List<Map<String, dynamic>>? userInfoList = await SharedPreferenceHelper().getUserInfoList();
                          if(userInfoList==null){
                            await SharedPreferenceHelper().saveUserInfoListUser(listinfoMap);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                          }else{
                            for(var userInfo in userInfoList){
                              if(userInfo["id"]==infoMap["id"]){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                                return;
                              }
                            }
                            await SharedPreferenceHelper().addUserInfo(infoMap);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                          }
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Email chưa được xác thực'),
              content: Text('Hãy xác thực email của bạn trước khi đăng nhập'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Đã có lỗi xảy ra'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
  String generateID(String email) {
    return email.replaceAll("@gmail.com", "");
  }
  List<String> generateSearchKeys(String fullName) {
    List<String> names = fullName.split(" ");
    Set<String> searchKeys = {};

    // Tạo các tổ hợp con của mỗi từ
    for (String name in names) {
      for (int i = 0; i < name.length; i++) {
        for (int j = i + 1; j <= name.length; j++) {
          searchKeys.add(name.substring(i, j).toUpperCase());
        }
      }
    }

    // Tạo các tổ hợp con của các cụm từ
    for (int i = 0; i < names.length; i++) {
      String combinedName = "";
      for (int j = i; j < names.length; j++) {
        combinedName = (combinedName.isEmpty ? names[j] : "$combinedName ${names[j]}");
        for (int k = 0; k < combinedName.length; k++) {
          for (int l = k + 1; l <= combinedName.length; l++) {
            searchKeys.add(combinedName.substring(k, l).toUpperCase());
          }
        }
      }
    }

    return searchKeys.toList();
  }

  Future<bool> signInWithGoogle() async {
    try {
      await googleSignIn.signOut();
      // Yêu cầu người dùng chọn tài khoản Google
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng chọn huỷ đăng nhập
        print('Đăng nhập bị huỷ bỏ.');
        return false;
      }
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      String email = googleUser.email ?? '';
      String name = googleUser.displayName??'';
      String avata=googleUser.photoUrl??'https://i.ibb.co/jzk0j6j/image.png';
     String id= generateID(email);
     List<String> searchKey=generateSearchKeys(name);
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Đăng nhập vào Firebase với credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        QuerySnapshot userExist=await DatabaseMethods().getUserById(id);
        if(userExist.docs.isEmpty){
          String date ="Ngày ${DateTime.now().day} Tháng ${DateTime.now().month} Năm ${DateTime.now().year}";
          List listUser= await DatabaseMethods().getUserLimit10();
          Map<String, dynamic> userInfoMap = {
            "IdUser": id,
            "Username": name,
            "SearchKey":searchKey,
            "E-mail": email,
            "Sex": "",
            "Birthdate": "",
            "Phone": "",
            "imageAvatar": avata,
            "News": [],
            "Search":[]
          };
          Map<String,dynamic> userInfoMap1={
            "id":id,
            "relationship":"",
            "born":"",
            "address":"",
            "since": date,
            "imageBackground":"https://i.ibb.co/9WYddvb/image.png"
          };
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

          DatabaseMethods().addUserInfo(id, userInfoMap1);
          DatabaseMethods().addUserDetail(id, userInfoMap);
        }
        QuerySnapshot querySnapshot = await DatabaseMethods().getUserByEmail(email);
        birthDate = "${querySnapshot.docs[0]["Birthdate"]}";
        id = "${querySnapshot.docs[0]["IdUser"]}";
        phone = "${querySnapshot.docs[0]["Phone"]}";
        sex = "${querySnapshot.docs[0]["Sex"]}";
        username = "${querySnapshot.docs[0]["Username"]}";
        image = "${querySnapshot.docs[0]["imageAvatar"]}";
        await SharedPreferenceHelper().saveUserName(username);
        await SharedPreferenceHelper().saveIdUser(id);
        await SharedPreferenceHelper().saveUserPhone(phone);
        await SharedPreferenceHelper().saveImageUser(image);
        await SharedPreferenceHelper().saveSex(sex);
        await SharedPreferenceHelper().saveBirthDate(birthDate);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Home()));
        print('Đăng nhập với tài khoản: ${user.displayName}');
        return true;
      } else {
        // Đăng nhập thất bại
        print('Đăng nhập thất bại.');
        return false;
      }
    } catch (e) {
      // Xử lý các lỗi khi đăng nhập
      print('Lỗi đăng nhập với Google: $e');
      return false;
    }
  }
}




