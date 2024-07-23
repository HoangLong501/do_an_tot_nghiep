import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../service/database.dart';
import '../lib_class_import/userDetailProvider.dart';
import 'package:provider/provider.dart';
class UpdateSex extends StatefulWidget {
  final String idUser;
  const UpdateSex({super.key, required this.idUser});

  @override
  State<UpdateSex> createState() => _UpdateSexState();
}

class _UpdateSexState extends State<UpdateSex> {
  String? selectedGender="";

  onLoad() async {
    print(widget.idUser);
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
    final userDetailProvider = Provider.of<UserDetailProvider>(context);
    userDetailProvider.getUser();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Giới tính",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      body: Container(
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
                      "Chọn giới tính",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Divider(height: 0.1,color: Colors.grey.shade300,),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Map<String,dynamic> userInfoMap={
                            "Sex":selectedGender
                          };
                          await DatabaseMethods().updateUser(widget.idUser, userInfoMap);
                          userDetailProvider.updateSex(selectedGender!);
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
                                    content:Text('Bạn đã đổi giới tính thành công',
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
                                    content:Text('Bạn chắc hủy thảy đổi chứ?',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
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

      ),
    );
  }
}
