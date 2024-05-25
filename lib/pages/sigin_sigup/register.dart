
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'choosegender.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime? selectedDate = DateTime.now();
  String surName="",name="",birthDate="";

  TextEditingController surnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  void _continuePressed() {
    String surname = surnameController.text.trim();
    String name = nameController.text.trim();
    String birthDate = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : '';

    if (surname.isNotEmpty && name.isNotEmpty && birthDate.isNotEmpty) {
      // Nếu các trường đều được điền, điều hướng đến trang tiếp theo và truyền thông tin
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChooseGender(
          surname: surname,
          name: name,
          birthDate: birthDate,
        )),
      );
    } else {
      // Nếu có trường nào đó để trống, hiển thị thông báo hoặc xử lý khác
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Vui lòng điền đầy đủ thông tin'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng dialog
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    }
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
              begin: Alignment.centerLeft, // Bắt đầu từ trái
              end: Alignment.centerRight, // Kết thúc ở phải
              colors: [
                Colors.yellow.shade50, // Màu vàng
                Colors.red.shade50, // Màu đỏ
                Colors.lightBlue.shade50, // Màu xám
              ],
              stops: [0.0, 0.1, 1.0],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Text(
                    'Bạn tên gì?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'nhập tên bạn sử dụng trong đời thực.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ]),
       
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          validator: (value){
                            if(value==null||value.isEmpty){
                              return "Họ không được để trống!";
                            }
                            return null;
                          },
                          controller: surnameController,
                          scrollPadding: EdgeInsets.all(
                              10), // Điền vào scrollPadding nếu cần
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Họ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorStyle: TextStyle(fontSize: 14), // Đặt kích thước văn bản của lỗi
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 1), // Khoảng cách giữa hai TextField
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          validator: (value){
                            if(value==null||value.isEmpty){
                              return "Tên không được để trống!";
                            }
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Tên',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorStyle: TextStyle(fontSize: 14), // Đặt kích thước văn bản của lỗi
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
       
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Text(
                    'Ngày sinh của bạn là khi nào?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                SizedBox(height: 20),
                Container(
                  width: 390,
                  height: 80,
                  child: TextFormField(

                    validator: (value){
                      int yer=DateTime.now().year-selectedDate!.year;
                      if(yer<12){
                        return "bạn chưa đủ tuổi vui lòng quay lại khi đủ tuổi!";
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : '',
                    ),
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ngày sinh',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorStyle: TextStyle(fontSize: 14), // Đặt kích thước văn bản của lỗi
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  width: 390,
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          setState(() {

                            surName=surnameController.text;
                            name=nameController.text;
                            birthDate=selectedDate.toString();
                            _continuePressed();
                          });
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
       
                SizedBox(height: 200),
                TextButton(
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
              ],
            ),
          ),
        ),
     ),
      )
    );

  }
}
