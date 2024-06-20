import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileFanPage extends StatefulWidget {
  const ProfileFanPage({super.key});
  @override
  State<ProfileFanPage> createState() => _ProfileFanPageState();
}

class _ProfileFanPageState extends State<ProfileFanPage> {
    String? myId, name , description ,type;

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("fanpage").doc(myId!).get();
    name = data.get("nameFanpage");
    description = data.get("description");
    type = data.get("type");
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40,left: 20,right: 20,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap:(){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back,size: 30,)),
                  Text( "$name",style: TextStyle(
                      fontSize: 18
                  ),),
                  Icon(Icons.search_outlined,size: 30,),
                ],
              ),
            ),
            Stack(
              children: [
                Image(
                  image: Image.network("https://i.ibb.co/9WYddvb/image.png").image,
                  height: 240,
                  width: MediaQuery.of(context).size.width/1.0,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  margin: EdgeInsets.only(top: 180 , left: 20 ,right: 20),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(backgroundColor: Colors.blueGrey,
                          radius: 80,
                        ),
                        SizedBox(height: 8,),
                        Text("$name" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                      ]
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                        Text("0 lượt thích"),
                        Text(" - 0 người theo dõi"),
                      ],
                    ),
                  Text(description!=null ? description! : "",style: TextStyle(
                    fontSize: 18
                  ),),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  width: MediaQuery.of(context).size.width/2.2,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                  Center(child: Text("+ Thêm vào tin",style: TextStyle(fontSize: 18,color: Colors.white),)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,right: 10),
                  width: MediaQuery.of(context).size.width/2.2,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                  Center(child: Text("Quản cáo",style: TextStyle(fontSize: 18,color: Colors.black),)),
                ),
              ],
            ),
            GestureDetector(
                onTap: () async {
                },
                child:  Container(
                  margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                  width: MediaQuery.of(context).size.width/1,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.hammer),
                      SizedBox(width: 10,),
                      Text("Quản lý",style: TextStyle(fontSize: 18,color: Colors.black),),
                    ],
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Row(
                children: [
                  TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade100)),
                    onPressed: (){},
                    child: Text("Bài viết",style: TextStyle(color: Colors.blue.shade600,

                    ),),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text("Giới thiệu",style: TextStyle(color: Colors.grey.shade600),),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text("Ảnh",style: TextStyle(color: Colors.grey.shade600),),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text("Xem thêm",style: TextStyle(color: Colors.grey.shade600),),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
            Container(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Text("Chi tiết",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            ),
            Container(
              padding:EdgeInsets.only(top: 10,left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.info , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Trang  ",style: TextStyle(fontSize: 16),),
                      Text(type!=null ? type! : "",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(Icons.star , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Đánh giá ",style: TextStyle(fontSize: 16),),
                      Text(" born",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(Icons.list , color: Colors.grey.shade600,),
                      SizedBox(width: 10,),
                      Text("Xem thêm thông tin giới thiệu",style: TextStyle(fontSize: 16),),
                    ],
                  ),

                ],
              ),
            ),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bài viết",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  TextButton(onPressed: (){}, child: Text("Bộ lọc",style: TextStyle(color: Colors.lightBlue,fontSize: 17),))
                ],
              ),
            ),
            // Duyệt newsfeed ở đây
          ],
        ),
      ),
    );
  }
}
