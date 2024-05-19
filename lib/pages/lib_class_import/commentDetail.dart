import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CommentDetail extends StatefulWidget {
  final String idUser , content,time;
  const CommentDetail({super.key,
   required this.idUser,
    required this.content,
    required this.time,
  });
  @override
  State<CommentDetail> createState() => _CommentDetailState();
}


class _CommentDetailState extends State<CommentDetail> {
  String nameUser ="", imageAvatar="",content="" , time="";
  onLoad()async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("user").doc(widget.idUser).get();
    nameUser = documentSnapshot.get("Username");
    imageAvatar = documentSnapshot.get("imageAvatar");
    print(imageAvatar);
    print(imageAvatar.substring(8));
    content =widget.content;
    time =widget.time;
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
    return Padding(
      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: Image.network(imageAvatar ,).image,),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nameUser , style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                Text(content ,style: TextStyle(fontSize: 16), ),
                Row(children: [
                  Text("Thích" ,style: TextStyle(color: Colors.blue),),
                  SizedBox(width: 20,),
                  Text("Trả lời",style: TextStyle(color: Colors.blue),),
                ],)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
