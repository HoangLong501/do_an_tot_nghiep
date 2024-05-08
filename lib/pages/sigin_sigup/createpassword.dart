
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';

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
  bool _obscureText = true;
  String passWord ="",rePassWord="";
  RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController repasswordcontroller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _creatacc(){
    String password = passwordcontroller.text;
    Map<String,dynamic> infoUser={
      "surName": "${widget.surname}",
      "name": "${widget.name}",
      "birthData": "${widget.birthDate}",
      "sex": "${widget.sex}",

    };

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


                                    });
                                  }
                                  // Xử lý đăng nhập ở đây
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context)=>login()),
                                  // );
                                 // _creatacc();
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
                                  MaterialPageRoute(builder: (context)=>login()),
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
}
