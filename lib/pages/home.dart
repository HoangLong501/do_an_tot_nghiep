import 'package:do_an_tot_nghiep/pages/menu.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib_class_import/swipe.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _controller = ScrollController();
  bool isScrollDown =false;
  String? username, idUser;
  int picked = 0;
  List itemCount=[];

  getvaluefromfirebase()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("test").get();
    print(querySnapshot.size);

  }
  controlScroll(){
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        isScrollDown=true;
        setState(() {

        });
      } else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        isScrollDown=false;
        setState(() {

        });
      }
    });
  }
  onLoad()async{
    controlScroll();
    await getvaluefromfirebase();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Text("facebook" ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,color: Colors.blue),),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: GestureDetector(
                      onTap: (){
                      },
                      child: Icon(Icons.add_circle_outline ,size: 30,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: GestureDetector(
                      onTap: (){
                      },
                      child: Icon(Icons.search_outlined,size: 30,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: GestureDetector(
                      onTap: (){
                      },
                      child: Icon(Icons.messenger_outline,size: 30,)),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,


      body:SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8,left: 8 , right: 8),
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      print(index);
                    },
                    child: SizedBox(
                      width: 160.0,
                      child: Card(
                        child: Center(
                          child: Text('Card ${index + 1}'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SwipeDetector(
              onSwipeLeft: (){
                setState(() {
                  if(picked==4){
                    picked=4;
                  }else{
                    picked=picked+1;
                  }
                });
              },
              onSwipeRight: (){
                setState(() {
                  if(picked==0){
                    picked=0;
                  }else{
                    picked=picked-1;
                  }
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                    SizedBox(
                      height: 400,
                      child: Center(child: Text("Test cuon")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isScrollDown==false? BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 0;
                      });
                    },
                    child: Icon(Icons.home_outlined ,
                      color: picked==0? Colors.blueAccent:Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 1;
                      });
                    },
                    child: Icon(Icons.ondemand_video ,
                      color: picked==1? Colors.blueAccent:Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 2;
                      });
                    },
                    child: Icon(Icons.people ,
                      color: picked==2? Colors.blueAccent:Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                        picked = 3;
                      });
                    },
                    child: Icon(Icons.notifications_none_outlined ,
                      color: picked==3? Colors.blueAccent:Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 400),
                          type: PageTransitionType.topToBottom,
                          child: Menu(),
                        ),
                      );

                    },
                    child: Icon(Icons.menu ,
                      color: Colors.grey,
                    )),
              ],
            ),
          ],
        ),
      ):SizedBox(),
    );
  }
}
