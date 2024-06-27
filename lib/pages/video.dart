import 'dart:io';

import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/share.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'comment2.dart';
import 'menu.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
   QuerySnapshot? listvideo;
  VideoPlayerController? currentController;
  String? currentPlayingUrl,idMyUser;
  Map<String, VideoPlayerController> videoControllers = {};
  List<Map<String,dynamic>> listUser=[];
  bool  isScrollDown =false;
   final ScrollController _controller = ScrollController();
   int picked = 0;
   List<bool> clicked = [];
   String imageVideo="";

  Future<void> initializeVideoControllers() async {
    for (var doc in listvideo!.docs) {
      var videoData = doc.data() as Map<String, dynamic>;
      String videoUrl = videoData['urlvideo'];
      VideoPlayerController controller = VideoPlayerController.network(videoUrl);
      await controller.initialize();
      videoControllers[videoUrl] = controller;
    }
  }
  Future<void> playVideo(String urlVideo) async {
    if (currentController != null) {
      currentController!.pause();
    }
    currentController = videoControllers[urlVideo];
    currentController!.play();
    setState(() {
      currentPlayingUrl = urlVideo;
    });
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
  Future<void> getUser(QuerySnapshot list)async{
    for(int i=0;i<list.docs.length;i++){
      var idUser=list!.docs[i].data() as Map<String, dynamic>;
      QuerySnapshot querySnapshot=await DatabaseMethods().getUserById(idUser['idfanpage']);
     Map<String,dynamic>infoMap={
       "idUserposter":querySnapshot.docs[0]['IdUser'],
       "idvideo":idUser["idvideo"],
       "username":querySnapshot.docs[0]['Username'],
       "userimage":querySnapshot.docs[0]['imageAvatar']
     };
    listUser.add(infoMap);
    }
  }
   Future<void> CutFromVideo(String videoPath) async {
     FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
     try {
       // Đường dẫn lưu ảnh trích xuất từ khung hình tại giây thứ 1
       Directory tempDir = await getTemporaryDirectory();
       String framePath = '${tempDir.path}/frame_at_1s.jpg';

       // Trích xuất khung hình tại giây thứ 1
       final extractFrameArgs = [
         '-i', videoPath,
         '-ss', '1',
         '-vframes', '1',
         framePath
       ];

       await flutterFFmpeg.executeWithArguments(extractFrameArgs);

       // Lưu đường dẫn ảnh vào biến imageStory
       File frameFile = File(framePath);
       imageVideo = frameFile.path;

     } catch (e) {
       print('Error: $e');
     }
   }

   Future<void> onLoad() async {
    listvideo = await DatabaseMethods().getAllVideo();
    idMyUser=await SharedPreferenceHelper().getIdUser();
    if (listvideo != null && listvideo!.docs.isNotEmpty) {
      await getUser(listvideo!);
      clicked = List.generate(listvideo!.docs.length, (index) => false);
      await initializeVideoControllers();
      setState(() {});
      var firstVideoData = listvideo!.docs[0].data() as Map<String, dynamic>;
      currentPlayingUrl = firstVideoData['urlvideo'];
      await playVideo(currentPlayingUrl!);
    }
    controlScroll();
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    videoControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void handleVisibilityChange(VisibilityInfo info, String videoUrl) {
    if (info.visibleFraction > 0.5) {
      if (currentPlayingUrl != videoUrl) {
        playVideo(videoUrl);
      }
    } else {
      if (currentPlayingUrl == videoUrl) {
        currentController?.pause();
      }
    }
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
              child: Text(
                "facebook",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.blue),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.add_circle_outline, size: 30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.search_outlined, size: 30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.messenger_outline, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ( listUser==[]||listvideo ==null)
            ? Center(
        child: CircularProgressIndicator(),
    )
          :  SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listvideo!.docs.length,
            itemBuilder: (context, index) {
              var videoData = listvideo!.docs[index].data() as Map<String, dynamic>;
              String videoUrl = videoData['urlvideo'];
              String videoContent = videoData['content'];
              List<dynamic>listReact=videoData['react'];
              Map<String,dynamic> user=listUser[index];
              String idvideo=videoData['idvideo'];
              if(listReact.contains(idMyUser)){
                clicked[index]=true;
              }
              return VisibilityDetector(
                key: Key(index.toString()),
                onVisibilityChanged: (info) {
                  handleVisibilityChange(info, videoUrl);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey.shade400, thickness: 5),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(user['userimage']),
                          ),
                          SizedBox(width: 10),
                          Text(
                            user['username'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        alignment: Alignment.topLeft,
                        height: 60,
                        child: Text(
                          videoContent,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: videoControllers.containsKey(videoUrl) &&
                            videoControllers[videoUrl]!.value.isInitialized
                            ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(videoControllers[videoUrl]!),
                        )
                            : Container(),
                      ),
                      Row(
                        children: [
                          StreamBuilder(
                            stream:DatabaseMethods().getReactVideo(idvideo) ,
                            builder:(BuildContext context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Hiển thị indicator khi đang tải dữ liệu
                              } else if (snapshot.hasError) {
                                return SizedBox();// Hiển thị thông báo lỗi nếu có lỗi xảy ra
                              } else {
                                if(snapshot.hasData){
                                  return Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "${snapshot.data}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "${snapshot.data}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue
                                      ),
                                    ),
                                  );
                                }
                                // Hiển thị số lượng sản phẩm từ snapshot
                              }
                            },
                          ),
                          SizedBox(width: 5,),
                          Text("lượt thích"),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20 , right: 20,top: 5),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: ()async{
                                await DatabaseMethods().updateLikeVideo(user['idvideo'],idMyUser! );
                                setState(()  {
                                  if(clicked[index]==true){
                                    clicked[index]=false;
                                  }else {
                                    clicked[index]=true;
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.thumb_up_alt_outlined ,color: clicked[index] ? Colors.blue :Colors.grey.shade600,),
                                  SizedBox(width: 6,),
                                  Text("Thích" , style: TextStyle(color:clicked[index] ? Colors.blue : Colors.grey.shade600,fontSize: 18),),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                showMaterialModalBottomSheet(
                                    context: context, builder: (context)=>Comment2( idPoster:user['idUserposter'] ,idNewsfeed: user['idvideo'] ,));
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
                            GestureDetector(
                              onTap: () async {
                               await CutFromVideo(videoUrl);
                                showMaterialModalBottomSheet(
                                    context: context, builder: (context)=>Share(idsource: idvideo,image: imageVideo,));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.turn_slight_right_outlined ,color: Colors.grey.shade600,),
                                  SizedBox(width: 6,),
                                  Text("Chia sẻ" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Home()));
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
                      picked = 1;
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
