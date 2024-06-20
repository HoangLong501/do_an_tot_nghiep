import 'package:do_an_tot_nghiep/pages/profile_friend.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MemberDetail extends StatefulWidget {
  final String idUser , idChatRoom;
  const MemberDetail({super.key , required this.idUser , required this.idChatRoom});

  @override
  State<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  String image="" , name ="" , id="";
  List admin=[] , leader=[] , owner=[];
  String? myId;
  int _selectedValue = 1;

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user")
    .doc(widget.idUser).get();
    image = data.get("imageAvatar");
    name = data.get("Username");
    id = data.get("IdUser");

    DocumentSnapshot data1 = await FirebaseFirestore.instance.collection("groupChat")
        .doc(widget.idChatRoom).collection("info").doc(widget.idChatRoom).get();
    admin = data1.get("admin");
    try{
      leader = data1.get("leader");
    }
    catch(e){
      leader =[];
    }
    try{
      owner = data1.get("owner");
    }
    catch(e){
      owner =[];
    }

    
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
    return ElevatedButton(
      onPressed: (){
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          // barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: MediaQuery.of(context).size.height -  200,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Đóng",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: Image.network(image).image,
                      radius: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.black, fontSize: 24),
                        child: Text(name),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileFriend(idProfileUser: id)));
                        },
                        child:  DefaultTextStyle(
                          style: TextStyle(color: Colors.black45, fontSize: 18),
                          child: Text("Thông tin cá nhân"),
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            child: Text("Chức vụ"),
                          ),
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                            child: admin.contains(id)? Text("Quản trị viên") : leader.contains(id)?Text("Trưởng nhóm"): Text("Thành viên") ,
                          )
                        ],
                      ),
                    ),
                    admin.contains(myId)&&!admin.contains(id)?  Padding(
                        padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                        child: TextButton(
                          onPressed: (){
                            showDialog(context: context, builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text("Dieu chinh", style: TextStyle(fontSize: 20)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text('Thành viên'),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: _selectedValue,
                                            onChanged: (int? value) {
                                              setState(() {
                                                _selectedValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Trưởng nhóm'),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: _selectedValue,
                                            onChanged: (int? value) {
                                              setState(() {
                                                _selectedValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Quản trị viên'),
                                          leading: Radio(
                                            value: 3,
                                            groupValue: _selectedValue,
                                            onChanged: (int? value) {
                                              setState(() {
                                                _selectedValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(onPressed: ()async{
                                        if(_selectedValue==1){
                                          print(id);
                                          if(leader.contains(id)){
                                            leader.remove(id);
                                          }
                                          Map<String , dynamic> infoMap={
                                            "leader" :leader,
                                          };
                                          await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom)
                                          .collection("info").doc(widget.idChatRoom).update(infoMap);
                                          Navigator.of(context).pop();
                                          print(leader);
                                        }else if (_selectedValue==2){
                                          leader.add(id);
                                          Map<String , dynamic> infoMap={
                                            "leader" :leader,
                                          };
                                          await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom)
                                              .collection("info").doc(widget.idChatRoom).update(infoMap);
                                          Navigator.of(context).pop();
                                          print(leader);
                                          print("Trưởng nhóm");
                                        }else{
                                          print(admin);
                                          if(leader.contains(id)){
                                            leader.remove(id);
                                            Map<String , dynamic> infoMap={
                                              "leader" :leader,
                                            };
                                            await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom)
                                                .collection("info").doc(widget.idChatRoom).update(infoMap);
                                          }
                                          admin.add(id);
                                          Map<String , dynamic> infoMap={
                                            "admin" :admin,
                                          };
                                          await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom)
                                              .collection("info").doc(widget.idChatRoom).update(infoMap);
                                          Navigator.of(context).pop();
                                          print(admin);
                                          print("QTV");
                                        }

                                      }, child: Text("Oke"))
                                    ],
                                  );
                                },
                              );
                             }).then((e){
                              Navigator.of(context).pop(); // Close the dialog
                              // if (mounted) {
                              //   Navigator.of(context).pop(); // Close the widget
                              // }
                            });

                          },
                          child:  DefaultTextStyle(
                            style: TextStyle(color: Colors.red, fontSize: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                  child: Text("Điều chỉnh chức vụ"),
                                ),
                              ],
                            ),
                          ),
                        )
                    ): SizedBox() ,
                    admin.contains(myId)?  Padding(
                        padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                        child: TextButton(
                          onPressed: ()async{
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    title: Text("Xác nhận xóa"),
                                    content: Text("Bạn muốn xóa thành viên này ra khỏi nhóm chat"),
                                    actions: [
                                      TextButton(onPressed: ()async{
                                        Navigator.of(context).pop();
                                      }, child: Text("Cancel")),
                                      TextButton(onPressed: ()async{
                                        if(!owner.contains(id)){
                                          List temp =[];
                                          DocumentSnapshot data = await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).get();
                                          temp = data.get("user");
                                          temp.remove(id);
                                          Map<String , dynamic> infoMap={
                                            "user":temp
                                          };
                                          await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).update(infoMap);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        }else{
                                          showDialog(context: context, builder: (context){
                                            return AlertDialog(
                                              title: Text("Cảnh báo ! "),
                                              content: Text("Bạn không thể xóa người này ra khỏi nhóm chat"),
                                              actions: [
                                                TextButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                }, child: Text("Ok"))
                                              ],
                                            );
                                          });
                                        }

                                      }, child: Text("Ok")),
                                    ],
                                  );
                                });
                          },
                          child:  DefaultTextStyle(
                            style: TextStyle(color: Colors.red, fontSize: 18),
                            child: Row(
                              children: [
                                Icon(Icons.remove_circle_outline_outlined ,color: Colors.red,),
                                SizedBox(width: 10,),
                                Text("Xóa khỏi nhóm"),
                              ],
                            ),
                          ),
                        )
                    ): SizedBox() ,
                  ],
                ),
              ),
            );
          },
        );
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        elevation: WidgetStateProperty.all(0.0),
      ),

      child: Container(
        decoration: BoxDecoration(
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
              image==""? CircleAvatar(
                backgroundColor: WidgetStateColor.resolveWith((states) => Colors.grey,),
              ):CircleAvatar(
                backgroundImage: Image.network(image).image,
                radius: 30,
              ),
            SizedBox(width: 20,),
            Text(name , style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }


}

