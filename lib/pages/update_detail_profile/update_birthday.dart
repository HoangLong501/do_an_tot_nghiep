import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/database.dart';
class UpdateBirthDay extends StatefulWidget {
  final String idUser;
  const UpdateBirthDay({super.key, required this.idUser});

  @override
  State<UpdateBirthDay> createState() => _UpdateBirthDayState();
}

class _UpdateBirthDayState extends State<UpdateBirthDay> {
  DateTime? selectedDate ;
 String? birthday;
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
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(widget.idUser);
      birthday = querySnapshot.docs[0]["Birthdate"];
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }
  }
  onLoad() async {
    await getData();
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
            "Ngày sinh",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
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
                      "Chọn ngày sinh của bản ",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Divider(height: 0.1,color: Colors.grey.shade300,),
                  SizedBox(height: 20,),
                  Container(
                    height: 90,
                   padding: EdgeInsets.only(left:20,top: 10,bottom: 20,right: 20),
                    child: TextFormField(
                      validator: (value){
                        int yer=DateTime.now().year-selectedDate!.year;
                        if(yer<12){
                          return "vui lòng nhập đúng số tuổi của bạn!";
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
                        hintText: "$birthday",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        errorStyle: TextStyle(fontSize: 14), // Đặt kích thước văn bản của lỗi
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              birthday=DateFormat("dd/MM/yyyy").format(selectedDate!).toString();

                            });
                            Map<String,dynamic> userInfoMap={
                              "Birthdate":birthday
                            };
                            await DatabaseMethods().updateUser(widget.idUser, userInfoMap);
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
                                      content:Text(' Bạn đã đổi ngày sinnh thành công',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
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
                                    content:Text('Bạn muốn hủy thay đổi và thoát ra ngoài chứ',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text("Cancel"))
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
}
