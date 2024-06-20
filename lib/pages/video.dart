import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'comment2.dart';

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late QuerySnapshot? listvideo;
  VideoPlayerController? currentController;
  String? currentPlayingUrl,idMyUser;

  Map<String, VideoPlayerController> videoControllers = {};
  List<Map<String,dynamic>> listUser=[];
  bool clicked=false;
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

  Future<void> onLoad() async {
    idMyUser=await SharedPreferenceHelper().getIdUser();
    listvideo = await DatabaseMethods().getAllVideo();
    if (listvideo != null && listvideo!.docs.isNotEmpty) {
      await initializeVideoControllers();
      setState(() {});
      await getUser(listvideo!);
      var firstVideoData = listvideo!.docs[0].data() as Map<String, dynamic>;
      currentPlayingUrl = firstVideoData['urlvideo'];
      await playVideo(currentPlayingUrl!);
    }
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
      body: listvideo != null
          ? SingleChildScrollView(
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
              var user=listUser[index];
              return VisibilityDetector(
                key: Key(index.toString()),
                onVisibilityChanged: (info) {
                  handleVisibilityChange(info, videoUrl);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.45,
                  child: Column(
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
                        height: 70,
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
                      Padding(
                        padding: EdgeInsets.only(left: 20 , right: 20,top: 20),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: ()async{
                                await DatabaseMethods().updateLikeVideo(user['idvideo'],idMyUser! );
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
                                    context: context, builder: (context)=>Comment2( idPoster:user['idUserposter'] ,idComment:idMyUser!,idNewsfeed: user['idvideo'] ,));
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
              );
            },
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
