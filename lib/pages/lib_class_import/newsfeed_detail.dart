import 'package:do_an_tot_nghiep/pages/comment.dart';
import 'package:do_an_tot_nghiep/pages/comment2.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/menu_newsfeed.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

import '../share.dart';
import '../share1.dart';

class WidgetNewsfeed extends StatefulWidget {
  final String  idUser,username ,time , content ,image, id  ;
  final  DateTime date;
  const WidgetNewsfeed({super.key ,
    required this.idUser,
    required this.id,
    required this.username,
    required this.content,
    required this.time,
    required this.date,
    required this.image,

  });
  @override
  State<WidgetNewsfeed> createState() => _WidgetNewsfeedState();
}

class _WidgetNewsfeedState extends State<WidgetNewsfeed> {
  String? date;
  String idUserReact="" ,imageUser="";
  bool clicked =true;
  bool? reacted;
  int sumReact=0;
  List react=[];
  Stream<int>? totalReact;
  bool shared=false;
  DateTime _dateShare = DateTime.now();
  String   idUserShare="",imageUserShare="", idNewsFeedShare="", nameShare="" , contentShare="" , imageShare="" ,dateShare="" , timeShare="";

  onLoad()async{
    idUserReact = (await SharedPreferenceHelper().getIdUser())!;
    DocumentSnapshot dataUser = await FirebaseFirestore.instance.collection("user").doc(widget.idUser).get();
    try{
      imageUser = dataUser.get("imageAvatar");
    }catch(e){
      imageUser="";
    }

    date ="${widget.date.day} \/ ${widget.date.month} \/ ${widget.date.year}";
    reacted = await DatabaseMethods().checkUserReact(widget.id, widget.idUser, idUserReact);
    totalReact = DatabaseMethods().getReactStream(widget.idUser, widget.id);

    if(reacted!=null){
      clicked=reacted!;
    }
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("newsfeed").doc(widget.id).collection("share").get();
    if(snapshot.docs.isNotEmpty){
      shared=true;
      idNewsFeedShare = snapshot.docs[0]["ID"];
      DocumentSnapshot data = await FirebaseFirestore.instance.collection("newsfeed").doc(idNewsFeedShare).get();
      if(data.exists){
        idUserShare = data.get("UserID");
        nameShare = data.get("userName");
        contentShare = data.get("content");
        imageShare = data.get("image");
        _dateShare = data.get("newTimestamp").toDate();
        dateShare ="${_dateShare.day} \/ ${_dateShare.month} \/ ${_dateShare.year}";
        timeShare = data.get("ts");
        DocumentSnapshot dataUserShare = await FirebaseFirestore.instance.collection("user").doc(idUserShare).get();
        imageUserShare = dataUserShare.get("imageAvatar");
      }else{
        idUserShare="";
      }


    }


    if (mounted) {
      setState(() {
        // cập nhật trạng thái
      });
    }
  }
  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return
      shared?Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10 ,left: 20,right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  imageUser!="" ? CircleAvatar(backgroundImage: Image.network(imageUser).image,
                    radius: 24,
                  ):CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        Row(
                          children: [
                            Text(widget.time,style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                            SizedBox(width: 10,),
                            Text(date??"",style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextButton(
                    onPressed: (){
                      showMaterialModalBottomSheet(
                          context: context, builder: (context)=>MenuNewsfeed(idNewsfeed: widget.id,));
                    },
                    child: Icon(CupertinoIcons.ellipsis,size: 20,color: Colors.grey,),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(top: 16,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text(widget.content ,style: TextStyle(fontSize: 18),),
                ),
                SizedBox(height: 4,),
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(width: 0.4)
                  ),
                  child: idUserShare!="" ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10 ,left: 20,right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                imageUserShare!="" ? CircleAvatar(backgroundImage: Image.network(imageUserShare).image,
                                  radius: 22,
                                ):CircleAvatar(
                                  backgroundColor: Colors.grey,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(nameShare,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                                      Text(timeShare,style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(dateShare??"",style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20,right: 20 , top: 20 , bottom: 20),
                        child: Text(contentShare ,style: TextStyle(fontSize: 18 ,color: Colors.grey.shade600),),
                      ),
                      imageShare!=""? Image(image: Image.network(imageShare).image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width/1,
                      ):SizedBox(),
                    ],
                  ):SizedBox(
                      height: 100,
                      child: Center(child: Text("Bài viết hiện không khả dụng"),)),
                ),
                StreamBuilder<int>(
                  stream: totalReact,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Hiển thị indicator khi đang tải dữ liệu
                    } else if (snapshot.hasError) {
                      return SizedBox();// Hiển thị thông báo lỗi nếu có lỗi xảy ra
                    } else {
                      if(snapshot.hasData){
                        return snapshot.data! >0 ? Container(
                          margin: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.hand_thumbsup ,color: Colors.blue,),
                              SizedBox(width: 8,),
                              Text("${snapshot.data}" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey),),
                            ],
                          ),
                        ):SizedBox();
                      }else{
                        return SizedBox();
                      }
                      // Hiển thị số lượng sản phẩm từ snapshot
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6,left: 20 , right: 20),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: ()async{
                          await DatabaseMethods().updateNewsfeedReact(widget.id,widget.idUser,idUserReact);
                          setState(()  {
                            if(clicked==true){
                              clicked=false;
                            }else {
                              clicked=true;
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.thumb_up_alt_outlined ,color: clicked ? Colors.blue :Colors.grey.shade600,),
                            SizedBox(width: 6,),
                            Text("Thích" , style: TextStyle(color:clicked ? Colors.blue : Colors.grey.shade600,fontSize: 18),),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          showMaterialModalBottomSheet(
                              context: context, builder: (context)=>Comment2( idPoster: widget.idUser,idNewsfeed: widget.id));
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.comment_bank_outlined ,color: Colors.grey.shade600,),
                              SizedBox(width: 6,),
                              Text("Bình luận" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: ()async{
                          showMaterialModalBottomSheet(
                              context: context, builder: (context)=>Share1(idNewsFeed: widget.id,));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.turn_slight_right_outlined ,color: Colors.grey.shade600,),
                            SizedBox(width: 6,),
                            Text("Chia sẽ" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
          ),
        ),
      ],
    ):

    Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10 ,left: 20,right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  imageUser!="" ? CircleAvatar(backgroundImage: Image.network(imageUser).image,
                    radius: 24,
                  ):CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        Row(
                          children: [
                            Text(widget.time,style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                            SizedBox(width: 10,),
                            Text(date??"",style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextButton(
                    onPressed: (){
                      showMaterialModalBottomSheet(
                          context: context, builder: (context)=>MenuNewsfeed(idNewsfeed: widget.id,));
                    },
                    child: Icon(CupertinoIcons.ellipsis,size: 20,color: Colors.grey,),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(top: 16,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text(widget.content ,style: TextStyle(fontSize: 18),),
                ),
                SizedBox(height: 4,),
               widget.image!=""? Image(image: Image.network(widget.image).image,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width/1,
                ):SizedBox(),
                StreamBuilder<int>(
                  stream: totalReact,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Hiển thị indicator khi đang tải dữ liệu
                    } else if (snapshot.hasError) {
                      return SizedBox();// Hiển thị thông báo lỗi nếu có lỗi xảy ra
                    } else {
                      if(snapshot.hasData){
                        return snapshot.data! >0 ? Container(
                          margin: EdgeInsets.only(left: 20,right: 20,bottom: 4),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.hand_thumbsup ,color: Colors.blue,),
                              SizedBox(width: 8,),
                              Text("${snapshot.data}" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey),),
                            ],
                          ),
                        ):SizedBox();
                      }else{
                        return SizedBox();
                  }
                     // Hiển thị số lượng sản phẩm từ snapshot
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6,left: 20 , right: 20),
                  child:
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: ()async{
                            await DatabaseMethods().updateNewsfeedReact(widget.id,widget.idUser,idUserReact);
                            setState(()  {
                              if(clicked==true){
                                clicked=false;
                              }else {
                                clicked=true;
                              }
                            });
                          },
                          child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.thumb_up_alt_outlined ,color: clicked ? Colors.blue :Colors.grey.shade600,),
                                    SizedBox(width: 6,),
                                    Text("Thích" , style: TextStyle(color:clicked ? Colors.blue : Colors.grey.shade600,fontSize: 18),),
                                  ],
                                ),
                        ),
                       TextButton(
                         onPressed: (){
                           showMaterialModalBottomSheet(
                               context: context, builder: (context)=>Comment2( idPoster: widget.idUser,idNewsfeed: widget.id));
                         },
                         child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.comment_bank_outlined ,color: Colors.grey.shade600,),
                                    SizedBox(width: 6,),
                                    Text("Bình luận" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                                  ],
                                ),
                            ),
                       ),
                        TextButton(
                          onPressed: ()async{
                            showMaterialModalBottomSheet(
                                context: context, builder: (context)=>Share1(idNewsFeed: widget.id,));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.turn_slight_right_outlined ,color: Colors.grey.shade600,),
                              SizedBox(width: 6,),
                              Text("Chia sẽ" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                            ],
                          ),
                        ),
                      ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
