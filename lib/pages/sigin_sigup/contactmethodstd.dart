
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'contactmethodemail.dart';
import 'createpassword.dart';
import 'login.dart';


class ContactMethodSTD extends StatefulWidget {
  final String surname;
  final String name;
  final String birthDate;
  final String sex;
  const ContactMethodSTD({super.key, required this.surname,required this.name,
                          required this.birthDate,required this.sex});

  @override
  State<ContactMethodSTD> createState() => _ContactMethodSTDState();
}

class _ContactMethodSTDState extends State<ContactMethodSTD> {
  TextEditingController phonecontroller= TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String phoneNumbwr="";
  RegExp phoneNumberRegex = RegExp(r'^0\d{9}$');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
        body: SingleChildScrollView(
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
        child:  Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 20),
          Text(
            'Số điện thoại bạn là gì?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Nhập số điẹn thoại có thể dùng để liên hệ với bạn. Thông tin này sẽ không hiện thị với ai khác trên trang cá nhân của bạn.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            validator: (value) {
              bool checkPhone = phoneNumberRegex.hasMatch(value.toString());
              if (value == null || value.isEmpty || checkPhone !=true) {
                return 'Số điện thoại không được để trống!';
              }
              return null;
            },
            controller: phonecontroller,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho phép nhập số
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Số điện thoại',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          SizedBox(height: 20),
          Text(
            'Chúng tôi sẽ gửi thông báo cho bạn qua SMS.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
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
                        phoneNumbwr=phonecontroller.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>CreatePassWord(
                          surname:widget.surname,
                          name: widget.name,
                          birthDate:widget.birthDate,
                          sex: widget.sex,
                          phone: phoneNumbwr

                        )),
                      );
                    });
                  }
                  // Xử lý đăng nhập ở đây

                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.blue.shade800),
                ),
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>ContactMethodEmail(
                    surname:widget.surname,
                    name: widget.name,
                    birthDate:widget.birthDate,
                    sex: widget.sex,
                  )),
                );
              },
              style: ButtonStyle(

                side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.deepPurpleAccent.shade200)), // Màu viền
              ),
              child: Text('Đăng kí bằng email',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
            ),
          ),
          SizedBox(height: 140),
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
        ]),
      ),
      )
    )));
  }
}
