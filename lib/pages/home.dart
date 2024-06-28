import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/createNewsfeed.dart';
import 'package:do_an_tot_nghiep/pages/menu.dart';
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
import 'package:rxdart/rxdart.dart';
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
            Container(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              height: 240,
              child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods().getAllStory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditStory(idUser:idUserDevice! )));
                        },
                      child: Container(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 2),
                        height: 200,
                        child: SizedBox(
                          width: 160.0,
                          height: 200,
                          child: Card(
                            child: Center(
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  List<DocumentSnapshot> allStories = snapshot.data!.docs;
                  List<DocumentSnapshot> userStories=[];

                  // Phân loại story theo iduser
                  for (var doc in allStories) {
                    List<dynamic> status = doc['status'];
                    if (status.isEmpty) {
                      userStories.add(doc);
                    } else if (status.contains(idUserDevice)) {
                      userStories.add(doc);
                    }
                  }
                  // Xây dựng danh sách Stream từ list userStories
                  List<Stream<QuerySnapshot>> streams = [
                    for (var story in userStories)
                      DatabaseMethods().getWatchedStory(story.id, idUserDevice!)
                  ];
                  // Sử dụng Future.wait để chờ lấy tất cả dữ liệu từ các Stream
                  return FutureBuilder(
                    future: Future.wait(streams.map((stream) => stream.first)),
                    builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshots) {
                      if (snapshots.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshots.hasError) {
                        return Text('Lỗi: ${snapshots.error}');
                      }
                      List<DocumentSnapshot> listWatched = [];
                      List<DocumentSnapshot> listWatch = [];
                      // Xử lý dữ liệu sau khi đã có kết quả từ các Stream
                      for (int i = 0; i < snapshots.data!.length; i++) {
                        bool watched = snapshots.data![i].docs.isNotEmpty && snapshots.data![i].docs.first['watched'];
                        if (watched) {
                          listWatched.add(userStories[i]);
                        } else {
                          listWatch.add(userStories[i]);
                        }
                      }
                      listWatch.addAll(listWatched); // Đưa các story đã xem xuống cuối danh sách
                      // for(var wacht in listWatch){
                      //   print("aaaaaaaaaaaa${wacht.data()}");
                      // }
                      listWatch.sort((a, b) {
                        String idA = a['iduser'];
                        String idB = b['iduser'];

                        if (idA == idUserDevice && idB != idUserDevice) {
                          return -1; // Đưa phần tử có iduser là idUserDevice lên trước
                        } else if (idA != idUserDevice && idB == idUserDevice) {
                          return 1; // Đưa phần tử có iduser khác idUserDevice xuống sau
                        } else {
                          return 0; // Giữ nguyên thứ tự của các phần tử khác
                        }
                      });

                      return buildStoryCard(listWatch); // Hiển thị danh sách story đã được sắp xếp
                    },
                  );
                },
              ),
            ),
            FutureBuilder<List<String>>(
              future: listNewFeed,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
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
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<DocumentSnapshot> allPosts = [];
                    for (var querySnapshot in snapshot.data!) {
                      allPosts.addAll(querySnapshot.docs);
                    }
                    allPosts.sort((a, b) => (b['newTimestamp'] as Timestamp).compareTo(a['newTimestamp'] as Timestamp));
                    return ListView.builder(
                      controller: _controller,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Avoid nested scrolling
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
                );
              },
            ),
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
  Widget buildStoryCard(List<DocumentSnapshot> liststoryDoc) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: liststoryDoc.length+1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Đây là mục "Thêm mới"
          return Container(
            height: 200,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>EditStory(idUser: idUserDevice!)));
              },
              child: Center(
                child: Icon(Icons.add),
              ),
            ),
          );

        }
        else{
          int newIndex=index-1;
          String imageUrl = liststoryDoc[newIndex]["urlstory_image"];
          String videoUrl = liststoryDoc[newIndex]["urlstory_video"];
          String idUserStory=liststoryDoc[newIndex]["iduser"];
          int time = DateTime.now().millisecondsSinceEpoch;
          int retime = liststoryDoc[newIndex]['times'];
          print("aaaaaaaaaaaaaaa${idUserStory}");
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
                    if(idUserStory!=idUserDevice){
                      Map<String, dynamic> useIdMap = {
                        "watched": true,
                        "iduser":idUserDevice,
                        "type": false
                      };
                      DatabaseMethods().addReaction(liststoryDoc[newIndex]["idstory"], idUserDevice!, useIdMap);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Story(
                          idUser: idUserDevice!,
                          type: videoUrl == "" ? false : true,
                          idStory: liststoryDoc[newIndex]["idstory"],
                        ),
                      ),
                    ).then((_) {
                      setState(() {
                        if (liststoryDoc[newIndex]['idstory'] !=idUserDevice) {
                          currentStoryIndex[liststoryDoc[newIndex]['iduser']] = (currentStoryIndex[liststoryDoc[newIndex]['iduser']] ?? 0) + 1;
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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      FutureBuilder(
                        future: DatabaseMethods().getUserById(liststoryDoc[newIndex]['iduser']),
                        builder: (BuildContext context, AsyncSnapshot spt) {
                          if (spt.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (spt.hasError) {
                            return Text('Lỗi: ${spt.error}');
                          } else if (!spt.hasData || spt.data!.docs.isEmpty) {
                            return Text("data");
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
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        return Container(); // Trả về một Container rỗng nếu story đã hết hạn
      },

    );

  }
}
