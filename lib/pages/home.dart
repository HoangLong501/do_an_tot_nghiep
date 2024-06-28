import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/createNewsfeed.dart';
import 'package:do_an_tot_nghiep/pages/menu.dart';
import 'package:do_an_tot_nghiep/pages/reels_fanpage.dart';
import 'package:do_an_tot_nghiep/pages/search.dart';
import 'package:do_an_tot_nghiep/pages/notifications/noti.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/edit_story.dart';

import 'package:do_an_tot_nghiep/pages/update_detail_profile/story.dart';
import 'package:do_an_tot_nghiep/pages/video.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'lib_class_import/newsfeed_detail.dart';

import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? myNewsfeedStream;
  Stream<QuerySnapshot>? listStory;
  final ScrollController _controller = ScrollController();
  bool isScrollDown =false,type=false;
  String? username, idUser;
  int picked = 0;
  List itemCount=[];
  Future<List<String>>? listNewFeed;
  List<String> listFriends=[];
  String? idUserDevice;
  Map<String, int> currentStoryIndex = {};


  Future<void> saveTokenToDatabase(String token ) async {
    // Assume user is logged in for this example
    await FirebaseFirestore.instance
        .collection('user')
        .doc(idUserDevice)
        .update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }
  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token!);
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

  }
  Future<List<DocumentSnapshot>> fetchPosts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('newsfeed')
        .where('viewers', arrayContains: idUserDevice)
        .get();
    List<DocumentSnapshot> posts = querySnapshot.docs;
    // Sắp xếp bài viết theo thời gian
    posts.sort((a, b) => (b['newTimestamp']).compareTo(a['newTimestamp']));
    return posts;
  }

  onLoad()async{
    idUserDevice = await SharedPreferenceHelper().getIdUser();
    listNewFeed= DatabaseMethods().getFriends(idUserDevice!);
    listFriends=await DatabaseMethods().getFriends(idUserDevice!);
    // List<String> listReceiver=await DatabaseMethods().getReceivered(idUserDevice!);
    // listFriends.addAll(listReceiver);
    // listFriends.add(idUserDevice!);
    // listStory = DatabaseMethods().getAllStory(listFriends);
    await setupToken();
    setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.topCenter,
                            duration: Duration(milliseconds: 400),
                            isIos: true,
                            child: CreateNewsFeed(),
                          ),
                        );
                      },
                      child: Icon(Icons.add_circle_outline ,size: 30,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
                      },
                      child: Icon(Icons.search_outlined,size: 30,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: ChatPage(),
                          ),
                        );
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
        // controller: _controller,
        child: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.only(top: 8,left: 8 , right: 8),
            //   height: 240,
            //   child:  StreamBuilder<QuerySnapshot>(
            //     stream: listStory,
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return Text("lỗi rồi");
            //       }
            //       else if(snapshot.connectionState==ConnectionState.waiting){
            //         return CircularProgressIndicator();
            //       }else if(snapshot.data==null || snapshot.data!.docs.isEmpty){
            //         return Container(
            //           padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/2),
            //           height: 200,
            //           child: GestureDetector(
            //             onTap: () {
            //               Navigator.push(context,MaterialPageRoute(builder: (context)=>EditStory(idUser: idUserDevice!)));
            //             },
            //             child: SizedBox(
            //               width: 160.0,
            //               height: 200,
            //
            //               child: Card(
            //                 child: Center(
            //                   child: Icon(Icons.add,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //       List<DocumentSnapshot> allStories = snapshot.data!.docs;
            //       Map<String, List<DocumentSnapshot>> userStories = {};
            //       // Phân loại story theo iduser
            //       for (var doc in allStories) {
            //         String iduser = doc['iduser'];
            //         if (!userStories.containsKey(iduser)) {
            //           userStories[iduser] = [];
            //         }
            //         userStories[iduser]!.add(doc);
            //       }
            //       return Container(
            //         height: 200,
            //          child:  ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: userStories.keys.length+1,
            //             itemBuilder: (context, index) {
            //               Text("$index");
            //             },
            //           ),
            //
            //       );
            //     },
            //   ),
            // ),
            FutureBuilder<List<DocumentSnapshot>>(
              future: fetchPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Text("không có bài viết nào");
                }
                List<DocumentSnapshot> allPosts = snapshot.data!;
                return ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),  // Avoid nested scrolling
                  itemCount: allPosts.length,
                  itemBuilder: (context, index) {
                    var data = allPosts[index];
                    return WidgetNewsfeed(
                      idUser: data["UserID"] ?? "",
                      date: data["newTimestamp"].toDate() ?? DateTime.now(),
                      id: data["ID"] ?? "",
                      username: data["userName"] ?? "",
                      content: data["content"] ?? "",
                      time: data["ts"] ?? "",
                      image: data["image"] ?? "",
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: isScrollDown==false? BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {

                    },
                    splashColor: Colors.blueAccent.withOpacity(0.2), // Màu sắc của hiệu ứng splash
                    borderRadius: BorderRadius.circular(25), // Bo tròn viền của hiệu ứng splash
                    child: Icon(
                      Icons.home_outlined,
                      color:  Colors.blueAccent ,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){

                    //Navigator.push(context,MaterialPageRoute(builder: (context)=>Video()));

                    },
                    child: Icon(Icons.ondemand_video ,
                      color:Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");

                    },
                    child: Icon(Icons.people ,
                      color:Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      // setState(() {
                      //
                      // });
                    },
                    child: Icon(Icons.notifications_none_outlined ,
                      color: Colors.grey,
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
                          type: PageTransitionType.rightToLeftWithFade,
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
