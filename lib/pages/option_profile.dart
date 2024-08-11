import 'package:do_an_tot_nghiep/pages/lib_class_import/report_user.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/database.dart';
class OptionProfile extends StatefulWidget {
  final String idProfile;
  const OptionProfile({super.key,required this.idProfile});

  @override
  State<OptionProfile> createState() => _OptionProfileState();
}

class _OptionProfileState extends State<OptionProfile> {
  String username="";
  String? myId;
  bool checkFriend = false;
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(
          widget.idProfile);
      print(querySnapshot.docs[0].data());
      username = querySnapshot.docs[0]["Username"];
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }
  }
  getCheckFriend()async{
    QuerySnapshot data = await FirebaseFirestore.instance.collection("relationship").doc(widget.idProfile).collection("friend")
        .where("status" , isEqualTo: "friend").get();
    for(var value in data.docs){
      if(value.id == myId){
        checkFriend = true;
      }
    }
  }
  onLoad() async {
    myId =await SharedPreferenceHelper().getIdUser();
    await getData();
    await getCheckFriend();
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoad();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "$username",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: (){
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  barrierColor: Colors.black45,
                  transitionDuration: Duration(milliseconds: 200),
                  pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                    return ReportUser(idUser: widget.idProfile,);
                  },
                  transitionBuilder: (context, a1, a2, widget) {
                    return Transform.scale(
                      scale: a1.value,
                      child: Opacity(
                        opacity: a1.value,
                        child: widget,
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.report_gmailerrorred,
                    size: 35,

                ),
                  SizedBox(width: 10,),
                  Text("Báo cáo trang cá nhân",
                    style: TextStyle(
                      fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 58),
              child: Divider(color: Colors.grey,),
            ),
            TextButton(
              onPressed: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.block_outlined,
                    size: 35,
                  ),
                  SizedBox(width: 10,),
                  Text("Chặn",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 58),
              child: Divider(color: Colors.grey,),
            ),
            TextButton(
              onPressed: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.search_outlined,
                    size: 35,
                  ),
                  SizedBox(width: 10,),
                  Text("Tìm kiếm",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 58),
              child: Divider(color: Colors.grey,),
            ),
            TextButton(
              onPressed: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.add_to_photos_outlined,
                    size: 35,
                  ),
                  SizedBox(width: 10,),
                  Text("Mời bạn bè",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 58),
              child: Divider(color: Colors.grey,),
            ),
            TextButton(
              onPressed: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.screen_share_outlined,
                    size: 35,
                  ),
                  SizedBox(width: 10,),
                  Text("Chia sẽ trang cá nhân",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 58),
              child: Divider(color: Colors.grey,),
            ),
            TextButton(
              onPressed: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 35,
                  ),
                  SizedBox(width: 10,),
                  Text("Liên kết đến trang cá nhân",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 58),
              child: Divider(color: Colors.grey,),
            ),
            checkFriend ? TextButton(
              onPressed: ()async{
                print(widget.idProfile);
                print(myId);
                await FirebaseFirestore.instance.collection("relationship").doc(widget.idProfile)
                .collection("friend").doc(myId).delete();
                await FirebaseFirestore.instance.collection("relationship").doc(myId)
                    .collection("friend").doc(widget.idProfile).delete();
                //Navigator.of(context).pop(0);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.person_off,
                    size: 35,
                  ),
                  SizedBox(width: 10,),
                  Text("Hủy bạn bè",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }
}
