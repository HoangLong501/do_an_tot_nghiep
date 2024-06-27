import 'dart:io';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../service/database.dart';

class EditVideo extends StatefulWidget {
  final String idFanpage;
  const EditVideo({super.key,required this.idFanpage});

  @override
  State<EditVideo> createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  TextEditingController contentController =TextEditingController();
  VideoPlayerController? videoController;
  bool type=false;
  File? videoFile;
  Future<void> pickVideo() async {
    final pickFile=await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(pickFile!=null){
      setState(() {
        videoFile=File(pickFile.path);
          videoController=VideoPlayerController.file(videoFile!)
        ..initialize().then((_) {
          setState(() {
            videoController!.play();
          });
        });
      });
      videoController!.play();
    }

  }
  Future<void> uploadVideo(String video) async {
    try {
      DateTime now = DateTime.now();
      String  idVideo = DateFormat('yyyyMMddHHmm').format(now);
      String nameStory = randomAlphaNumeric(10);
      final refVideo = FirebaseStorage.instance.ref().child('${widget.idFanpage}/video_fanpage/$nameStory.mp4');
      final taskSnapshotVideo = await refVideo.putFile(File(video));
      final videoUrl = await taskSnapshotVideo.ref.getDownloadURL();
      String text=contentController.text;
      Map<String, dynamic> userInfoMap = {
        "idvideo": "video_$idVideo",
        "idfanpage":widget.idFanpage,
        "content":text,
        "urlvideo": videoUrl,
        "react":[],
        "shared":[],
        "times":DateTime.now().millisecondsSinceEpoch
      };
      DatabaseMethods().addVideo("video_$idVideo", userInfoMap);
      print("Đăng video thành công");
    } catch (e) {
      print('Lỗi khi tải lên video: $e');
    }
  }
  onLoad() async {
   await pickVideo();
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
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40 ,left: 20 , right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_back,size: 30,),
                          SizedBox(width: 10,),
                          Text("Tạo bài viết",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        ],
                      ),
                      GestureDetector(
                        onTap: ()async{
                          if (videoController != null) {
                            uploadVideo(videoFile!.path);
                          }
                          //Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: type ? Colors.blue.shade200 :Colors.grey.shade300
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(4),
                            child: Center(child: Text("ĐĂNG",style: TextStyle(
                                color: type ? Colors.blueAccent :Colors.grey.shade500,
                                fontSize: 20
                            ),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: Image.network("https://www.dolldivine.com/rinmaru/cartoon-avatar-creator-thumbnail.jpg").image,
                          radius: 24,
                        ),
                        SizedBox(width: 14,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("username",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.lightBlueAccent.shade100
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.lock,size: 16,color: Colors.blue.shade600,),
                                        Text("Chỉ mình tôi",style: TextStyle(color:Colors.blue.shade600, ),),
                                        Icon(Icons.arrow_drop_down,size: 16,color: Colors.blue.shade600,),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.lightBlueAccent.shade100
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      pickVideo();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,size: 16,color: Colors.blue.shade600,),
                                          Text("Album",style: TextStyle(color:Colors.blue.shade600, ),),
                                          Icon(Icons.arrow_drop_down,size: 16,color: Colors.blue.shade600,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/1,
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          helperMaxLines: 1,
                          hintText: "Viết mô tả cho video ?",
                          hintStyle: TextStyle(fontSize: 24),
                        ),
                        onChanged: (value){
                          if(value==""){
                            setState(() {
                              type=false;
                            });
                          }else{
                            setState(() {
                              type=true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  // Ảnh được chọn ở đây ở đây
                ],
              ),
            ),
              videoController!=null ? Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width/1,
              child: videoController!.value.isInitialized?
                  AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                  ) :
                 Center(child: CircularProgressIndicator(),),
              ):Center(child: CircularProgressIndicator(),),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                    },
                    child: Icon(Icons.photo_library_outlined ,
                      color: Colors.green,
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
                    child: Icon(Icons.people_alt_rounded ,
                      color:  Colors.blueAccent,
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
                    child: Icon(Icons.emoji_emotions_outlined ,
                      color: Colors.deepOrange,
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
                    child: Icon(Icons.location_pin ,
                      color:  Colors.red,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
