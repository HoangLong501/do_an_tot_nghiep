import 'package:do_an_tot_nghiep/pages/profile_friend.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/database.dart';
class FriendDetail extends StatefulWidget {
  final String idFriend;
  const FriendDetail({super.key,required this.idFriend});

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
String id="",username="",image="";

Future<void> getData() async {
  try {
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(
        widget.idFriend);
    username = querySnapshot.docs[0]["Username"];
    image = querySnapshot.docs[0]["imageAvatar"];

  }catch(error){
    print("Lỗi khi lấy dữ liệu người dùng");
  }
}
onLoad()async{

  id=(await SharedPreferenceHelper().getIdUser())!;

  await  getData();
  setState(() {

  });
}
@override
 initState()  {
  super.initState();
  onLoad();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(widget.idFriend);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileFriend(idProfileUser: widget.idFriend)));


      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5,bottom: 10),
        child: Row(
          children: [
            Container(
              height: 70,
              child: image !=""? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(image,
                ),
              ):CircleAvatar(radius: 50 ,
              backgroundColor: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 3),
                    alignment:Alignment.centerLeft,
                    child: Text(
                      textAlign: TextAlign.left,
                      username,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "... bạn chung",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
