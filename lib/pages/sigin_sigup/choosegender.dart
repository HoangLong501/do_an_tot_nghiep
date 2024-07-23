
import 'package:do_an_tot_nghiep/pages/sigin_sigup/contactmethodemail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'contactmethodstd.dart';
import 'login.dart';

class ChooseGender extends StatefulWidget {
  final String surname;
  final String name;
  final String birthDate;
  const ChooseGender({super.key , required this.surname,required this.name,required this.birthDate});

  @override
  State<ChooseGender> createState() => _ChooseGenderState();
}

class _ChooseGenderState extends State<ChooseGender> {
  String? selectedGender="";

  bool seleted=false;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Giới tính của bạn là gì?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Chọn giới tính của bạn để xưng hô với người khác.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text('Nam'),
                            value: 'Nam',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing, // Di chuyển radio button sang phải
                          ),
                          Divider(height: 1,thickness: 1,),
                          RadioListTile<String>(
                            title: Text('Nữ'),
                            value: 'Nữ',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing, // Di chuyển radio button sang phải
                          ),
                          Divider(height: 1,thickness: 1,),
                          RadioListTile<String>(
                            title: Text('Tùy chọn khác'),
                            value: 'Khác',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing, // Di chuyển radio button sang phải
                          ),
                          seleted? SizedBox(
                            height: 20,
                            child: Text("vui lòng chọn giới tính !",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ):SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ],
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
                        // Xử lý đăng nhập ở đây
                        if (selectedGender == "") {
                          setState(() {
                            seleted=true;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                ContactMethodEmail(
                                  surname: widget.surname,
                                  name: widget.name,
                                  birthDate: widget.birthDate,
                                  sex: selectedGender!,
                                )),
                          );
                        }
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
                SizedBox(height: 160),
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
