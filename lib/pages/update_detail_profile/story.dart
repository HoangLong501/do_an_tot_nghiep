import 'dart:async';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Story extends StatefulWidget {
  final String idUser;
  final String idStory;
  final bool type;
  const Story({super.key, required this.idUser, required this.idStory, required this.type});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  String image="https://firebasestorage.googleapis.com/v0/b/do-an-tot-nghiep-afd66.appspot.com/o/Bach_202405161625%2Fstory_image%2FCI89Bh590Y.jpg?alt=media&token=c91efcc6-5c57-4acb-9d6a-906ad364674a",
      audio="",idUserStory="";
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Timer? timer;
  double progress=0.0;
  Color progressColor=Colors.grey.shade200;
  VideoPlayerController? videoPlayerController;
  String flyingIcon = '';
  double flyingTop = 0;
  double flyingLeft = 0;
  bool isFlying = false, runAudio=false;
  QuerySnapshot? listSeeStory,imageAvata;
  List<String> listicon=['assets/images/heart.png'];

  Future<void> getData() async {
    try {
      QuerySnapshot  querySnapshot=await DatabaseMethods().getStoryById(widget.idStory);
      setState(() {
        image=querySnapshot.docs[0]["urlstory_image"];
        audio=querySnapshot.docs[0]["urlstory_audio"];
        idUserStory=querySnapshot.docs[0]["iduser"];
      });
    } catch(error) {
      print("lỗi lấy thông tin người dùng $error");
    }
  }

  Future<void> playAudio() async {
    await audioPlayer.play(UrlSource(audio));
    timer = Timer(Duration(seconds: 10), () async {
      await audioPlayer.stop();
      Navigator.pop(context);
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });
  }

  void updateProgress() {
    setState(() {
      progress += 0.1;
      if (progress >= 1.0) {
        progress = 1.0;
        timer?.cancel();
        Navigator.pop(context);
      }
    });
  }

  Future<void> onLoad() async {
    await getData();
    if (widget.type) {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(image));
      await videoPlayerController!.initialize();
      videoPlayerController!.play();
    }

    imageAvata = await DatabaseMethods().getUserById(idUserStory);
    if(widget.idUser==idUserStory){
      listSeeStory=await DatabaseMethods().getSeeStory(widget.idStory);
    }
    if(audio!=""){
      playAudio();
    }
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        updateProgress();
      });

    });


  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    timer?.cancel();
  }

  void onIconTap(String icon, Offset position) {
    setState(() {
      flyingIcon = icon;
      flyingTop = position.dy;
      flyingLeft = position.dx;
      isFlying = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        flyingTop -= 300;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isFlying = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Stack(
            children: [
              if(image=="")
                CircularProgressIndicator(),
              Positioned.fill(
                  child: Image(
                    image: Image.network(image).image,
                    fit: BoxFit.cover,
                  )
              ),
              Positioned(
                top: 80,
                left: 20,
                right: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 5,
                  ),
                ),
              ),
              if(widget.idUser==idUserStory)
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: listSeeStory==null?
                       Text("0 Người xem",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                          ),
                        ):Positioned(
                          left: 10,
                          bottom: 10,
                          child: GestureDetector(
                            onTap: (){
                              audioPlayer.pause();
                              showUserSeeStory(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  child: Text(
                                    "${listSeeStory!.docs.length} Người xem",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    )
                    else
                Positioned(
                    left: 10,
                    bottom: 10,
                    right: 10,
                    child:Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade200,
                            ),
                            width: MediaQuery.of(context).size.width-110,
                            height: 40,
                            child: TextFormField(
                              maxLines: 200,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                border: InputBorder.none,
                                hintText: "Gửi lời nhắn...",
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: 40,
                            width: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listicon.length,
                              itemBuilder:(context, index) {
                                return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 40,
                                    width: 40,
                                    child: GestureDetector(
                                      onTapDown: (details){
                                        onIconTap(listicon[index], details.globalPosition);
                                        Map<String,dynamic> infoMap={
                                          "type": true
                                        };
                                        DatabaseMethods().updateReaction(widget.idStory, widget.idUser, infoMap);
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(listicon[index]),
                                      ),
                                    )
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              Positioned(
                top: MediaQuery.of(context).size.height/9,
                left: 20,
                child: imageAvata == null
                    ? CircularProgressIndicator()
                    : imageAvata!.docs.isEmpty
                    ? Text("Rỗng")
                    : Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          imageAvata!.docs.first["imageAvatar"],
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      child: Text(
                        imageAvata!.docs.first["Username"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isFlying)
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  left: flyingLeft,
                  top: flyingTop,
                  child: Image.asset(
                    flyingIcon,
                    width: 40,
                    height: 40,
                  ),
                  onEnd: () {
                    setState(() {
                      isFlying = false;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showUserSeeStory(BuildContext context) async {
    List<Map<String, dynamic>> viewers = [];
    for (var doc in listSeeStory!.docs) {
      QuerySnapshot userDoc = await DatabaseMethods().getUserById(doc['iduser']);
      if (userDoc.docs.isNotEmpty) {
        var userData = userDoc.docs[0].data() as Map<String, dynamic>;
        userData['type'] = doc['type'];
        viewers.add(userData);
      }
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: (){
            audioPlayer.resume();
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
                  child: viewers.isEmpty
                      ? Center(child: Text('Không có người xem nào'))
                      : ListView.builder(
                    itemCount: viewers.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> user = viewers[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user['imageAvatar']),
                        ),
                        title: Text(
                          user['Username'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: user['type']
                            ? Container(
                          height: 40,
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/images/heart.png",
                            height: 40,
                          ),
                        )
                            : Container(height: 0),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
