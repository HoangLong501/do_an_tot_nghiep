import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/createNewsfeed.dart';
import 'package:do_an_tot_nghiep/pages/menu.dart';
import 'package:do_an_tot_nghiep/pages/reels_fanpage.dart';
import 'package:do_an_tot_nghiep/pages/search.dart';
import 'package:do_an_tot_nghiep/pages/notifications/noti.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'lib_class_import/newsfeed_detail.dart';
import 'lib_class_import/swipe.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? myNewsfeedStream;

  final ScrollController _controller = ScrollController();
  bool isScrollDown =false;
  String? username, idUser;
  int picked = 0;
  List itemCount=[];
  Future<List<String>>? listNewFeed;

  String? idUserDevice;



  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("User nhan vao noti");
  }




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
    print("Token : $token");
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
    idUserDevice = await SharedPreferenceHelper().getIdUser();
    listNewFeed= DatabaseMethods().getFriends(idUserDevice!);
    await setupToken();
    controlScroll();
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
         FutureBuilder<List<String>>(
               future: listNewFeed,
                builder: (context , snapshot){
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }else if(snapshot.connectionState==ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }else if(snapshot.data==null || snapshot.data!.isEmpty){
                    return Text("không có bài viết nào");
                  }
                  List<String> friendIds = snapshot.data!;
                  List<Stream<QuerySnapshot>> friendNewsfeedStreams = friendIds.map((friendId) {
                    return FirebaseFirestore.instance
                        .collection('newsfeed')
                        .doc(friendId)
                        .collection('myNewsfeed')
                        .orderBy('newTimestamp', descending: true)
                        .snapshots();
                  }).toList();
                    return StreamBuilder(
                          stream: CombineLatestStream.list(friendNewsfeedStreams),
                          builder: (context, snapshot){
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            else if(snapshot.connectionState==ConnectionState.waiting){
                              return CircularProgressIndicator();
                            }else if(snapshot.data==null || snapshot.data!.isEmpty){
                              return CircularProgressIndicator();
                            }
                            List<DocumentSnapshot> allPosts = [];
                            for (var querySnapshot in snapshot.data!) {
                              allPosts.addAll(querySnapshot.docs);
                            }
                            allPosts.sort((a, b) => (b['newTimestamp'] as Timestamp).compareTo(a['newTimestamp'] as Timestamp));
                            // return Container(
                            //   child: Column(
                            //     children:allPosts.map((data){
                            //       //Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            //       return  WidgetNewsfeed(idUser: data["UserID"]??"",date: data["newTimestamp"].toDate()??DateTime.now(),id: data["ID"]??"", username: data["userName"]??"", content: data["content"]??"", time: data["ts"]??"", image: data["image"]??"",idComment: data["id_comment"]??"",);
                            //     }).toList(),
                            //   ),
                            // );
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
                          });
                },
              ),
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
                      setState(() {
                        picked = 0;
                      });
                    },
                    splashColor: Colors.blueAccent.withOpacity(0.2), // Màu sắc của hiệu ứng splash
                    borderRadius: BorderRadius.circular(25), // Bo tròn viền của hiệu ứng splash
                    child: Icon(
                      Icons.home_outlined,
                      color: picked == 0 ? Colors.blueAccent : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ReelFanPage()));
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
