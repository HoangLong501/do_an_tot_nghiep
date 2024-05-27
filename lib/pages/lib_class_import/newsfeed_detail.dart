import 'package:do_an_tot_nghiep/pages/comment.dart';
import 'package:do_an_tot_nghiep/pages/comment2.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class WidgetNewsfeed extends StatefulWidget {
  final String  idUser,username ,time , content ,image, id , idComment ;
  final  DateTime date;
  const WidgetNewsfeed({super.key ,
    required this.idUser,
    required this.id,
    required this.username,
    required this.content,
    required this.time,
    required this.date,
    required this.image,
    required this.idComment,
  });
  @override
  State<WidgetNewsfeed> createState() => _WidgetNewsfeedState();
}

class _WidgetNewsfeedState extends State<WidgetNewsfeed> {
  String? date;
  String idUserReact="";
  bool clicked =true;
  bool? reacted;
  int sumReact=0;
  List react=[];
  Stream<int>? totalReact;
  onLoad()async{
    idUserReact = (await SharedPreferenceHelper().getIdUser())!;
    date ="${widget.date.day} \/ ${widget.date.month} \/ ${widget.date.year}";
    reacted = await DatabaseMethods().checkUserReact(widget.id, widget.idUser, idUserReact);
    // DocumentSnapshot data = await FirebaseFirestore.instance.collection("newsfeed").doc(widget.idUser).collection("myNewsfeed").doc(widget.id).get();
    // react=data.get("react");
    // sumReact= react.length;
    totalReact = DatabaseMethods().getReactStream(widget.idUser, widget.id);
    if(reacted!=null){
      clicked=reacted!;
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10 ,left: 20,right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,
                    radius: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        Text(widget.time,style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Icon(Icons.linear_scale_outlined,size: 20,color: Colors.grey,),
                  ),
                  Text(date??"",style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                ],
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
                  padding: EdgeInsets.only(left: 20 , right: 20),
                  child:
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: ()async{
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
                        GestureDetector(
                          onTap: (){
                            showMaterialModalBottomSheet(
                                context: context, builder: (context)=>Comment2( idPoster: widget.idUser,idComment: widget.idComment,idNewsfeed: widget.id,));
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.chat_bubble_outline ,color: Colors.grey.shade600,),
                            SizedBox(width: 6,),
                            Text("Gửi" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.turn_slight_right_outlined ,color: Colors.grey.shade600,),
                            SizedBox(width: 6,),
                            Text("Chia sẽ" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                          ],
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
