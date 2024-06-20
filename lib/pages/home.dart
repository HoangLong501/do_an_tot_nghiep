import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/createNewsfeed.dart';
import 'package:do_an_tot_nghiep/pages/menu.dart';
import 'package:do_an_tot_nghiep/pages/search.dart';
import 'package:do_an_tot_nghiep/pages/notifications/noti.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/edit_story.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/edit_video.dart';
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
import 'lib_class_import/swipe.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
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
VideoPlayerController? videoPlayerController;
  Map<String, int> currentStoryIndex = {};

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
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
  Future<bool> checkContentType(url) async {
    var response = await http.head(Uri.parse(url));
    var contentType = response.headers['content-type'];
    if (contentType != null) {
      if (contentType.startsWith('video/')) {
        videoPlayerController= VideoPlayerController.networkUrl(Uri.parse(url));
        await videoPlayerController!.initialize();
        return true;
      } else if (contentType.startsWith('image/')) {

        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  onLoad()async{
    idUserDevice = await SharedPreferenceHelper().getIdUser();
    listNewFeed= DatabaseMethods().getFriends(idUserDevice!);
    listFriends=await DatabaseMethods().getFriends(idUserDevice!);
    List<String> listReceiver=await DatabaseMethods().getReceivered(idUserDevice!);
    listFriends.addAll(listReceiver);
    listFriends.add(idUserDevice!);
    listStory = DatabaseMethods().getAllStory(listFriends);
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
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
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
        controller: _controller,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8,left: 8 , right: 8),
              height: 240,
              child:  StreamBuilder<QuerySnapshot>(
                stream: listStory,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("lỗi rồi");
                  }
                  else if(snapshot.connectionState==ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }else if(snapshot.data==null || snapshot.data!.docs.isEmpty){
                    return Container(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/2),
                      height: 200,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>EditStory(idUser: idUserDevice!)));
                        },
                        child: SizedBox(
                          width: 160.0,
                          height: 200,

                          child: Card(
                            child: Center(
                              child: Icon(Icons.add,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  List<DocumentSnapshot> allStories = snapshot.data!.docs;
                  Map<String, List<DocumentSnapshot>> userStories = {};
                  // Phân loại story theo iduser
                  for (var doc in allStories) {
                    String iduser = doc['iduser'];
                    if (!userStories.containsKey(iduser)) {
                      userStories[iduser] = [];
                    }
                    userStories[iduser]!.add(doc);
                  }
                  return Container(
                    height: 200,
                     child:  ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userStories.keys.length+1,
                        itemBuilder: (context, index) {
                          if(index==0){
                            return Container(
                              height: 200,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>EditStory(idUser: idUserDevice!)));
                                },
                                child: SizedBox(
                                  width: 160.0,
                                  height: 200,
                                  child: Card(
                                    child: Center(
                                      child: Icon(Icons.add,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }else{
                            int newIndex = index - 1;
                            if (newIndex < snapshot.data!.docs.length) {
                              String iduser = userStories.keys.elementAt(newIndex);
                              List<DocumentSnapshot> stories = userStories[iduser]!;
                              int storyIndex = currentStoryIndex[iduser] ?? 0;
                              // Kiểm tra nếu hết story để xem cho người dùng này
                              if (storyIndex >= stories.length) {
                                return Container(); // Hoặc một widget khác để thông báo hết story
                              }

                              var storyDoc = stories[storyIndex];
                              String imageUrl = storyDoc["urlstory_image"];
                              return FutureBuilder<bool>(
                                future: checkContentType(imageUrl),
                                builder: (context, contentSnapshot) {
                                  if (!contentSnapshot.hasData) {
                                    return Container(
                                      height: 200,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                    ); // Hoặc một chỉ báo tải dữ liệu khác
                                  }
                                  bool isVideo = contentSnapshot.data!;
                                  int time = DateTime.now().millisecondsSinceEpoch;
                                  int retime = storyDoc['times'];
                                  if (time - retime < 86400000) {
                                    return Container(
                                      height: 200,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (mounted) {

                                              Map<String, dynamic> useIdMap = {
                                                "watched": true,
                                                "iduser":idUserDevice!,
                                                "type": false
                                              };
                                              DatabaseMethods().addReaction(storyDoc["idstory"], idUserDevice!, useIdMap);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Story(
                                                  idUser: idUserDevice!,
                                                  type: isVideo,
                                                  idStory: storyDoc["idstory"],
                                                ),
                                              ),
                                            ).then((_) {
                                              setState(() {
                                                if(storyDoc['idstory']!=idUserDevice) {
                                                  currentStoryIndex[iduser] =
                                                      (currentStoryIndex[iduser] ??
                                                          0) + 1;
                                                }
                                                });
                                            });
                                          }
                                        },
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: isVideo
                                                    ? VideoPlayer(videoPlayerController!)
                                                    : Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              FutureBuilder(
                                                future: DatabaseMethods().getUserById(iduser),
                                                builder: (BuildContext context, AsyncSnapshot spt) {
                                                  if (spt.connectionState == ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else if (spt.hasError) {
                                                    return Text('Lỗi: ${spt.error}');
                                                  } else if (!spt.hasData) {
                                                    return Text("data");
                                                  } else if (spt.data!.docs.isEmpty || spt.data == null) {
                                                    return Text("rỗng");
                                                  } else {
                                                    String imageUserStory = spt.data!.docs.first["imageAvatar"];

                                                    return Positioned(
                                                      left: 10,
                                                      top: 10,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.blue,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 18, // Điều chỉnh kích thước của avatar
                                                          backgroundImage: NetworkImage(imageUserStory), // URL của hình ảnh avatar
                                                        ),
                                                      ),
                                                    ); // Hiển thị thông báo nếu không có dữ liệu
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(); // Trả về một Container rỗng nếu story đã hết hạn
                                },
                              );
                            } else {
                              return Container(
                                child: Icon(Icons.ice_skating),
                              );
                            }

                          }

                        },
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
              child: FutureBuilder<List<String>>(
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
                            return IntrinsicHeight(
                              child: Column(
                                children:allPosts.map((data){
                                  //Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  return  WidgetNewsfeed(idUser: data["UserID"]??"",date: data["newTimestamp"].toDate()??DateTime.now(),id: data["ID"]??"", username: data["userName"]??"", content: data["content"]??"", time: data["ts"]??"", image: data["image"]??"",idComment: "",);
                                }).toList(),
                              ),
                            );
                          });
                },
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
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Video()));
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
