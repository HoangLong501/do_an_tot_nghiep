import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int picked=4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.only(top: 40,left: 20,right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Menu",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                SizedBox(
                  width: MediaQuery.of(context).size.width/6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings),
                      Icon(Icons.search_outlined),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20,left: 8,right: 8,bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                        },
                        child: SizedBox(
                          width:MediaQuery.of(context).size.width/2.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,),
                              Text("Name user",style: TextStyle(
                                fontSize: 18
                              ),),
                            ],
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_circle_outlined,size: 30,color: Colors.grey.shade700,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(CupertinoIcons.plus_circle_fill,color: Colors.grey.shade700,size: 30,),
                      Text("Tạo trang cá nhân hoặc Trang mới",
                      style: TextStyle(fontSize: 20,color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.groups,size: 30,color: Colors.blueAccent,),
                        Text("Nhóm",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.settings_backup_restore,size: 30,color: Colors.teal,),
                        Text("Kỷ niệm",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.flag,size: 30,color: Colors.orange,),
                        Text("Trang",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.people_alt_rounded,size: 30,color: Colors.lightBlue,),
                        Text("Bạn bè",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.bookmark,size: 30,color: Colors.pinkAccent,),
                        Text("Đã lưu",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.ondemand_video,size: 30,color: Colors.greenAccent,),
                        Text("Video",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.pages_rounded,size: 30,color: Colors.blueAccent,),
                        Text("Bảng feed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.emoji_people_rounded,size: 30,color: Colors.redAccent,),
                        Text("Hẹn hò",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                print("Đăng xuất");
              },
              child: Container(
                margin: EdgeInsets.only(top: 100),
                width: 400,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Đăng xuất",style: TextStyle(
                    color: Colors.grey.shade700,fontSize: 20,fontWeight: FontWeight.w500
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 500),
                          type: PageTransitionType.rightToLeft,
                          isIos: true,
                          child: Home(),
                        ),
                      );

                    },
                    child: Icon(Icons.home_outlined ,
                      color: Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.ondemand_video ,
                      color:  Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.people ,
                      color: Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.notifications_none_outlined ,
                      color:  Colors.grey,
                    )),

              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                      });
                    },
                    child: Icon(Icons.menu ,
                      color:  Colors.blueAccent,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
