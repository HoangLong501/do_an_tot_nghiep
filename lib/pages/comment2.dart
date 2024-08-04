import 'package:do_an_tot_nghiep/pages/lib_class_import/commentDetail.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:intl/intl.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

import 'notifications/noti.dart';
class Comment2 extends StatefulWidget {
 final String  idNewsfeed , idPoster;
  const Comment2({super.key ,required this.idNewsfeed , required this.idPoster});
  @override
  State<Comment2> createState() => _CommentState();
}
class _CommentState extends State<Comment2> {
  TextEditingController contentController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  List react=[];
  int sumReact=0;
  String? idUserComment;
  Stream<QuerySnapshot>? streamComment;
  String myName="", myImageAvatar="";
  bool reply=false;
  List<bool> showCustomWidget=[];
  String idOwner="";
  onLoad()async{
    idUserComment = await SharedPreferenceHelper().getIdUser();
    streamComment = DatabaseMethods().getCommentStream(widget.idNewsfeed);
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("newsfeed").doc(widget.idNewsfeed).get();
    react=data.get("react") ;
    idOwner=data.get("UserID");
    sumReact= react.length;

    DocumentSnapshot documentSnapshot1 = await FirebaseFirestore.instance.collection("user").doc(idUserComment).get();
    myName = documentSnapshot1.get("Username");
    myImageAvatar = documentSnapshot1.get("imageAvatar");
    if (mounted) {
      setState(() {});
    }
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
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
        body:  Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width/1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child:StreamBuilder(
                            stream: streamComment,
                            builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator());
                              }
                              if(!snapshot.hasData){
                                return Center(child: Text("Chưa có comment"));
                              }
                              if (snapshot.hasData) {
                                if (showCustomWidget.length != snapshot.data!.docs.length) {
                                  showCustomWidget =
                                  List<bool>.filled(snapshot.data!.docs.length, false);
                                }
                                return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.size,
                                      itemBuilder: (context ,index){
                                        return Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          margin: EdgeInsets.only(top: 10,bottom: 20,left: 20,right: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child:Column(
                                              children: [
                                                CommentDetail(key: ValueKey(snapshot.data), idComment: snapshot.data!.docs[index]["id_comment"],idNews: widget.idNewsfeed ,idUser: snapshot.data!.docs[index]["id_user_comment"], content: snapshot.data!.docs[index]["content"], time: snapshot.data!.docs[index]["time"]),
                                                Container(
                                                  margin:EdgeInsets.only(left: 100 ,),
                                                  child: Row(children: [
                                                    TextButton(onPressed: (){},child: Text("thích",style: TextStyle(color: Colors.blue),)),
                                                    TextButton(onPressed: (){
                                                      setState(() {
                                                        // Reset tất cả các phần tử về false
                                                        for (int i = 0; i < showCustomWidget.length; i++) {
                                                          showCustomWidget[i] = false;
                                                        }
                                                        // Chỉ bật phần tử được chọn
                                                        showCustomWidget[index] = true;
                                                      });
                                                    },child: Text("Trả lời",style: TextStyle(color: Colors.blue),)),
                                                  ],),
                                                ),
                                                if (showCustomWidget[index])
                                                  Container(
                                                    margin: EdgeInsets.only(top: 10,bottom: 10,left: 40),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 10),
                                                          child: myImageAvatar==""?CircleAvatar(
                                                            backgroundColor: Colors.white30,
                                                          ): CircleAvatar(
                                                            radius: 24,
                                                            // backgroundImage: Image.network(imageAvatar ,).image,),
                                                            backgroundImage: Image.network(myImageAvatar,).image,),
                                                        ),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(myName , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                              Container(
                                                                  width: MediaQuery.of(context).size.width/1.6,
                                                                  padding: EdgeInsets.only(left: 10),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey.shade100,
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  child: TextField(
                                                                    onTap: (){
                                                                        setState(() {
                                                                          reply=true;
                                                                        });
                                                                    },
                                                                    onTapOutside: (e){
                                                                      setState(() {
                                                                        reply=false;
                                                                      });
                                                                    },
                                                                    controller: replyController,
                                                                    maxLines: null,
                                                                    decoration: InputDecoration(
                                                                      hintText: "Viết bình luận",
                                                                      hintStyle: TextStyle(color: Colors.grey),
                                                                      border: InputBorder.none,
                                                                      suffixIcon: IconButton(onPressed: ()async{
                                                                        DateTime now = DateTime.now();
                                                                        String timeNow = DateFormat('h:mma').format(now);
                                                                        Timestamp timestamp = Timestamp.fromDate(now);
                                                                        Map<String, dynamic> commentInfoMap = {
                                                                          "id_comment": snapshot.data!.docs[index]["id_comment"],
                                                                          "id_user_comment": idUserComment,
                                                                          "content": replyController.text,
                                                                          "timestamp":timestamp,
                                                                          "time": timeNow,
                                                                        };
                                                                        await DatabaseMethods().addReplyCommentDetail(widget.idNewsfeed, snapshot.data!.docs[index]["id_comment"], commentInfoMap);
                                                                        replyController.clear();
                                                                        NotificationDetail().sendNotificationToAnyDevice(idUserComment!,
                                                                            "$myName vừa trả lời 1 bình luận của bạn ở một bài viết",
                                                                            "Bạn có thông báo mới");
                                                                        await FirebaseFirestore.instance.collection("notification").doc(idUserComment).collection("detail").doc().set({
                                                                          "ID":idUserComment,
                                                                          "content":"$myName vừa bình luận ở 1 bài viết của bạn",
                                                                          "ts": timeNow,
                                                                          "timestamp":timestamp,
                                                                          "check":false
                                                                        });
                                                                        setState(() {
                                                                          showCustomWidget[index] = false;
                                                                        });
                                                                      }, icon: Icon(Icons.send)),
                                                                    ),
                                                                  )),
                                                            ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            ),
                                        );
                                  });
                              }else{
                                return Center(child: Text(" Dòng 306 Invalid data format"));
                              }
                            },
                          ),
                  ),
                ),
                Offstage()
              ],
        ),
        bottomNavigationBar: !reply? Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            margin: EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade400.withOpacity(0.4),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextField(
                onTap: () {
                  print("Tap vao input");
                },
                controller: contentController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Viết bình luận",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (contentController.text == "" ||
                          contentController.text.isEmpty) {
                      } else {
                        DateTime now = DateTime.now();
                        String timeNow = DateFormat('h:mma').format(now);
                        String id = randomAlphaNumeric(10);
                        Timestamp timestamp = Timestamp.fromDate(now);
                        Map<String, dynamic> commentInfoMap = {
                          "id_comment":id,
                          "id_user_comment": idUserComment,
                          "content": contentController.text,
                          "time": timeNow,
                          "timestamp":timestamp
                        };
                        await DatabaseMethods()
                            .addCommentDetail(widget.idNewsfeed,id, commentInfoMap);
                        contentController.clear();
                        NotificationDetail().sendNotificationToAnyDevice(idOwner,
                            "$myName vừa bình luận ở 1 bài viết của bạn",
                            "Bạn có thông báo mới");
                        await FirebaseFirestore.instance.collection("notification").doc(idOwner).collection("detail").doc().set({
                          "ID":idUserComment,
                          "content":"$myName vừa bình luận ở 1 bài viết của bạn",
                          "ts": timeNow,
                          "timestamp":timestamp,
                          "check":false
                        });
                      }
                      setState(() {
                       // showCustomWidget.add(false);
                      });
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ),
        ):SizedBox(),
      ),
    );
  }
}
