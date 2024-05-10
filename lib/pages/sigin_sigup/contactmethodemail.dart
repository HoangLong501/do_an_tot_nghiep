
import 'package:flutter/material.dart';

import '../../service/shared_pref.dart';
import 'contactmethodstd.dart';
import 'createpassword.dart';
import 'login.dart';

class ContactMethodEmail extends StatefulWidget {
  final String surname;
  final String name;
  final String birthDate;
  final String sex;
  const ContactMethodEmail(
      {super.key,
      required this.surname,
      required this.name,
      required this.birthDate,
      required this.sex});

  @override
  State<ContactMethodEmail> createState() => _ContactMethodEmailState();
}

class _ContactMethodEmailState extends State<ContactMethodEmail> {
  TextEditingController emailcontroller = TextEditingController();
  RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$');
  final _formKey = GlobalKey<FormState>();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Form(
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
                            'Email bạn là gì?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Nhập email có thể dùng để liên hệ với bạn. Thông tin này sẽ không hiện thị với ai khác trên trang cá nhân của bạn.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              bool checkemail = emailRegex.hasMatch(value.toString());
                              if (value == null || value.isEmpty || checkemail !=true) {
                                return 'email trống hoặc không hợp lệ!';
                              }
                              return null;
                            },
                            controller: emailcontroller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Bạn sẽ nhận được email của chúng tôi và bạn cũng có thể chọn không nhận bất cứ lúc nào.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 45,
                            width: 390,
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    email = emailcontroller.text;

                                    // Thực hiện tác vụ bất đồng bộ ở đây
                                    String tam="2";
                                    SharedPreferenceHelper().savesigup(tam).then((result) {
                                      if (result) {
                                        print(result);
                                        // Cập nhật UI bên trong hàm callback của setState
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CreatePassWord(
                                              surname: widget.surname,
                                              name: widget.name,
                                              birthDate: widget.birthDate,
                                              sex: widget.sex,
                                              phone: email,
                                            )),
                                          );
                                        });
                                      }
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade800),
                                ),
                                child: Text(
                                  'Tiếp tục',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContactMethodSTD(
                                            surname: widget.surname,
                                            name: widget.name,
                                            birthDate: widget.birthDate,
                                            sex: widget.sex,
                                          )),
                                );
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(
                                        color: Colors.deepPurpleAccent
                                            .shade200)), // Màu viền
                              ),
                              child: Text(
                                'Đăng kí bằng số điện thoại',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: 120),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()),
                                );
                              },
                              child: Text(
                                'Bạn đã có tài khoản ư?',
                                style: TextStyle(
                                    color: Colors.blue.shade900, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ))));
  }
}

