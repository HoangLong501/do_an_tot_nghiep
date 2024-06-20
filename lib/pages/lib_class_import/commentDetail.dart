import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CommentDetail extends StatefulWidget {
  final String idUser , content,time , idNews , idComment;
  const CommentDetail({super.key,
   required this.idUser,
    required this.content,
    required this.time,
    required this.idNews,
    required this.idComment,
  });
  @override
  State<CommentDetail> createState() => _CommentDetailState();
}


class _CommentDetailState extends State<CommentDetail> {
  TextEditingController replyController=TextEditingController();
  String nameUser ="", imageAvatar="" ,content="" , time="";
  String? myId;
  bool showReplies = false;
  Stream<QuerySnapshot>? streamReplyComment;
  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    streamReplyComment = DatabaseMethods().getReplyCommentStream(widget.idNews, widget.idComment);
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("user").doc(widget.idUser).get();
    nameUser = documentSnapshot.get("Username");
    imageAvatar = documentSnapshot.get("imageAvatar");

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
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10 ,top: 10),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                 child: imageAvatar==""?CircleAvatar(
                   backgroundColor: Colors.white30,
                 ): CircleAvatar(
                  radius: 30,
                 // backgroundImage: Image.network(imageAvatar ,).image,),
                  backgroundImage: Image.network(imageAvatar,).image,),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nameUser , style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      Text(content ,style: TextStyle(fontSize: 16 , ), softWrap: true,),
                    ],
                  ),
              ),
            ],
          ),
          StreamBuilder(
              stream: streamReplyComment,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SizedBox();
                }
                return Container(
                  //height: showReplies? 500: 50 ,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (showReplies)
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: snapshot.data!.docs.map((document){
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              return ReplyCommentDetail(content: data["content"], idUserComment: data["id_user_comment"]);
                          }).toList(),
                        ),
                        // Container(
                        //   height: 400,
                        //   child: ListView.builder(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     shrinkWrap: true,
                        //     itemCount: snapshot.data!.size,
                        //     itemBuilder: (context, replyIndex) {
                        //       var replyData = snapshot.data!.docs[replyIndex];
                        //       return ReplyCommentDetail(content: replyData["content"], idUserComment: replyData["id_user_comment"]);
                        //     },
                        //   ),
                        // ),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            showReplies = !showReplies;
                          });
                        },
                        child: Text(
                          showReplies ? "Ẩn phản hồi" : "Hiển thị phản hồi",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ReplyCommentDetail extends StatefulWidget {
  final String content,idUserComment;
  const ReplyCommentDetail({super.key , required this.content , required this.idUserComment});

  @override
  State<ReplyCommentDetail> createState() => _ReplyCommentDetailState();
}

class _ReplyCommentDetailState extends State<ReplyCommentDetail> {
  String imageAvatar="",nameUser="";
  onLoad()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(widget.idUserComment).get();
    imageAvatar= data.get("imageAvatar");
    nameUser = data.get("Username");
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
    return Container(
      width: MediaQuery.of(context).size.width/1.4,
      color: Colors.grey.shade200,
      margin: EdgeInsets.only(left: 20,top: 10,bottom: 10),
      padding: EdgeInsets.only(left: 0 ,top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: imageAvatar==""?CircleAvatar(
                  backgroundColor: Colors.white30,
                ): CircleAvatar(
                  radius: 30,
                  // backgroundImage: Image.network(imageAvatar ,).image,),
                  backgroundImage: Image.network(imageAvatar,).image,),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nameUser , style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    Text(widget.content ,style: TextStyle(fontSize: 16 , ), softWrap: true,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
