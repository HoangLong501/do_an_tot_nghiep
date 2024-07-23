import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../service/database.dart';
import '../lib_class_import/userDetailProvider.dart';
class UpdateRelationShip extends StatefulWidget {
  final String idUser;
  const UpdateRelationShip({super.key,required this.idUser});

  @override
  State<UpdateRelationShip> createState() => _UpdateRelationShipState();
}

class _UpdateRelationShipState extends State<UpdateRelationShip> {
  String? _selectedValue;
  final List<String> _dropdownItems =
  [
    'Độc thân','Đang hẹn hò', 'Đã đính hôn',
    'Đã kết hôn','Chung sống có đăng kí','Chung sống',
    'Đang tìm hiểu','Phức tạp','Ly thân','Đã ly hôn','Góa'
 ];
  final _formKey = GlobalKey<FormState>();

  onLoad() async {
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
    userDetailProvider.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Mối quan hệ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      body: Form(
      child:Container(
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
                      "Mối quan hệ",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Divider(height: 0.1,color: Colors.grey.shade300,),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              child: ListView(
                                children: _dropdownItems.map((String value) {
                                  return ListTile(
                                    title: Text(value),
                                    onTap: () {
                                      setState(() {
                                        _selectedValue = value;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade400
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedValue ?? "Tình trạng mối quan hệ",
                                style: TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                            if(_selectedValue==""||_selectedValue==null){
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
                                        content:Text('Vui lòng chọn mối quan hệ bạn muốn thay đổi',
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
                            }else{
                              Map<String,dynamic> userInfoMap={
                                "relationship":_selectedValue,
                              };
                              await DatabaseMethods().updateUserInfo(widget.idUser, userInfoMap);
                              userDetailProvider.updateRelationship(_selectedValue!);
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
                                        content:Text('Bạn đã thay đổi mối quan hệ thành công',
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
