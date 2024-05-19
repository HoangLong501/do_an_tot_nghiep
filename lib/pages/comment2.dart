import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Comment2 extends StatefulWidget {
 final String idComment , idNewsfeed , idPoster;
  const Comment2({super.key ,required this.idComment,required this.idNewsfeed , required this.idPoster});
  @override
  State<Comment2> createState() => _CommentState();
}
class _CommentState extends State<Comment2> {
  TextEditingController contentController = TextEditingController();
  List react=[];
  int sumReact=0;
  onLoad()async{
    print(widget.idNewsfeed);
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("newsfeed").doc(widget.idPoster).collection("myNewsfeed").doc(widget.idNewsfeed).get();
    react=data.get("react") ;
    sumReact= react.reduce((value,e){
      return value+e;
    });
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
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.emoji_emotions_outlined),
                    Text("$sumReact",style: TextStyle(fontSize: 22),),
                    Icon(Icons.arrow_forward_ios_outlined,size: 20,)
                  ],
                ),
              ),
              Icon(Icons.thumb_up_alt_outlined),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child:  Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height/1.3,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        height:600,
                        child: Text("ngu"),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 500,
                //   child: Text("BINH LUAN"),
                // ),
              ],
            ),
        ),
        bottomNavigationBar: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: MediaQuery.of(context).viewInsets.bottom+20,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade400.withOpacity(0.4)
            ),
            child: Container(
              margin: EdgeInsets.only(left: 20 ),
              child:  TextField(
                  onTap: (){
                    print("Tap vao input");
                  },
                  controller: contentController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Viết bình luận"
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
