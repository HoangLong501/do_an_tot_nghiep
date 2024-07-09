import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'itemProvider.dart';

class MenuNewsfeed extends StatefulWidget {
  final String idNewsfeed;
  const MenuNewsfeed({super.key ,required this.idNewsfeed});

  @override
  State<MenuNewsfeed> createState() => _MenuNewsfeedState();
}

class _MenuNewsfeedState extends State<MenuNewsfeed> {
  String? myId;
  bool myNewsfeed =false;
  String nameUserNews="";


  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("newsfeed").doc(widget.idNewsfeed).get();
    myNewsfeed = myId == data.get("UserID");
    nameUserNews = data.get("userName");
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
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10,top: 10),
        decoration: BoxDecoration(

        ),
        child: Column(
          children: [
            !myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.add_circled_solid ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Quan tâm",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                        Text("Bạn sẽ nhìn thấy nhiều bài viết tương tự hơn" ,style: TextStyle(color: Colors.grey ,fontSize: 14 ,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            !myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.minus_circle_fill ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Không quan tâm",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                        Text("Bạn sẽ nhìn thấy ít bài viết tương tự hơn" ,style: TextStyle(color: Colors.grey ,fontSize: 14 ,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.bookmark_fill ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lưu bài viết",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                        Text("Thêm vào danh sách các mục đã lưu" ,style: TextStyle(color: Colors.grey ,fontSize: 14 ,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            !myNewsfeed? TextButton(
              onPressed: ()async{
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Hãy xác nhận" ,style: TextStyle(
                        fontSize: 20,fontWeight: FontWeight.w600
                    ),),
                    content: Text("Bạn thực sự muốn ẩn bài viết này khỏi bảng tin ? "),
                    actions: [
                      TextButton(onPressed: ()async{
                        List temp=[];
                        DocumentSnapshot docu = await FirebaseFirestore.instance.collection("user")
                            .doc(myId).collection("advance").doc(myId).get();
                        if(docu.exists){
                          temp = docu.get("newsfeed");
                        }
                        temp.add(widget.idNewsfeed);
                        Map<String , dynamic> data = {
                          "hideNewsfeed":temp
                        };
                        await FirebaseFirestore.instance.collection("user")
                            .doc(myId).collection("advance").doc(myId).set(data);
                        Provider.of<ItemProvider>(context, listen: false).hideItem(widget.idNewsfeed);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }, child: Text("Ok")),
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("Cancel")),
                    ],
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.xmark_square_fill ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ẩn bài viết",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                        Text("Ẩn bớt các bài viết tương tự" ,style: TextStyle(color: Colors.grey ,fontSize: 14 ,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            !myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.info_circle_fill ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Báo cáo bài viết",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                        Text("Chúng tôi không cho họ biết ai đã báo cáo" ,style: TextStyle(color: Colors.grey ,fontSize: 14 ,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            !myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.arrow_clockwise_circle_fill ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Xem lịch sử chỉnh sửa",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            !myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.remove_red_eye ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bỏ theo dõi $nameUserNews",style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            !myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.clock_fill ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tạm ẩn $nameUserNews trong 30 ngày" ,style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            // my newsfeed
            myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.note_alt ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Chỉnh sửa bài viết" ,style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            myNewsfeed? TextButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.lock ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Chỉnh sửa quyền riêng tư" ,style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                      ],
                    ),
                  )
                ],
              ),
            ):SizedBox(),
            myNewsfeed? TextButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Hãy xác nhận" ,style: TextStyle(
                      fontSize: 20,fontWeight: FontWeight.w600
                    ),),
                    content: Text("Bạn thực sự muốn xóa bài viết này !"),
                    actions: [
                      TextButton(onPressed: ()async{
                        Provider.of<ItemProvider>(context, listen: false).deleteItem(widget.idNewsfeed);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        print("Đã xóa  ${widget.idNewsfeed}");

                      }, child: Text("Ok")),
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("Cancel")),
                    ],
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.trash ,size: 32,color: Colors.black,),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Xóa bài viết" ,style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.w700 ,color: Colors.black),),
                      ],
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
