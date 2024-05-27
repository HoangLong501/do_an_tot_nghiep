import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
class Message extends StatefulWidget {
  final String name , image , chatRoomId;
  const Message({super.key,
    required this.name,
    required this.image,
    required this.chatRoomId,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController messController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  Stream<QuerySnapshot>? messRoom;
  String? myId ,messageId,_audioPath;
  final _scrollController = ScrollController();
  File? _selectedImage;
  bool _isRecording = false,haveContent =false,_emojiShowing = false;
  AudioPlayer player = AudioPlayer();

  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = File(returnImage!.path);
        haveContent=_selectedImage!.isAbsolute;
      });
  }

  Future<String> uploadImage(File image) async {
    String nameImage = randomAlphaNumeric(10);
    final ref = FirebaseStorage.instance.ref().child('$myId/images_message/$nameImage.jpg');
    final taskSnapshot = await ref.putFile(image);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
  Future<void> startRecording() async {
    await Permission.microphone.request();
    if (await Permission.microphone.isGranted) {
      print("Đã cấp quyền và thực hiện record ");
      String filePath = 'audio_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _recorder.startRecorder(toFile: filePath);
      setState(() {
        _isRecording = true;
      });
    }
  }
  Future<void> stopRecording() async {
    String? filePath = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _audioPath = await uploadFileAudio(filePath!);
    print(_audioPath);
    await _recorder.deleteRecord(fileName: filePath);
    print("Them vao database");
  }
  Future<String?> uploadFileAudio(String filePath) async {
    File file = File(filePath);
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = storageRef.child('$myId/audio/${DateTime.now().millisecondsSinceEpoch}.mp4').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }


  onLoad()async{
    messRoom = DatabaseMethods().getChatRoomMessage(widget.chatRoomId);
    myId = await SharedPreferenceHelper().getIdUser();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    _recorder.openRecorder();
    onLoad();
  }
  @override
  void dispose() {
    messController.dispose();
    _recorder.closeRecorder();
    player.dispose();
    super.dispose();
  }
  addMessage(bool sendMess ){
    if(messController.text!=""){
      String mess = messController.text;
      messController.text="";

      DateTime now = DateTime.now();
      String timeNow =DateFormat('h:mma').format(now);

      Map<String,dynamic> messInfoMap ={
        "message":mess,
        "sendBy":myId,
        "ts":timeNow,
        "time":FieldValue.serverTimestamp(),
      };
      DatabaseMethods().addMessage(widget.chatRoomId, messInfoMap).then((value){
        Map<String,dynamic> lastMessageInfoMap={
          "LastMessage":mess,
          "LastMessageSendTs":timeNow,
          "Time":DateTime.now().toString(),
          "LastMessageSendBy":myId,
        };
        DatabaseMethods().updateLastMessageSend(widget.chatRoomId, lastMessageInfoMap);
        if(sendMess){
          messageId=null;
        }
      });
    }
  }
  addImage(bool sendImage )async{
    if(_selectedImage!=null){
      DateTime now = DateTime.now();
      String timeNow =DateFormat('h:mma').format(now);
      String urlImage=await uploadImage(_selectedImage!);
      Map<String,dynamic> messInfoMap ={
        "image":urlImage,
        "sendBy":myId,
        "ts":timeNow,
        "time":FieldValue.serverTimestamp(),
      };
      DatabaseMethods().addMessage(widget.chatRoomId, messInfoMap).then((value){
        Map<String,dynamic> lastMessageInfoMap={
          "LastMessage":"Đã gửi 1 ảnh",
          "LastMessageSendTs":timeNow,
          "Time":DateTime.now().toString(),
          "LastMessageSendBy":myId,
        };
        DatabaseMethods().updateLastMessageSend(widget.chatRoomId, lastMessageInfoMap);
        if(sendImage){
          _selectedImage=null;
          setState(() {

          });
        }
      });
    }
  }

  addAudio(String audioPath )async{
    if(_audioPath!=null){
      DateTime now = DateTime.now();
      String timeNow =DateFormat('h:mma').format(now);
      Map<String,dynamic> messInfoMap ={
        "audio":audioPath,
        "sendBy":myId,
        "ts":timeNow,
        "time":FieldValue.serverTimestamp(),
      };
      print(messInfoMap);
      DatabaseMethods().addMessage(widget.chatRoomId, messInfoMap).then((value){
        Map<String,dynamic> lastMessageInfoMap={
          "LastMessage":"Đã gửi 1 đoạn ghi âm",
          "LastMessageSendTs":timeNow,
          "Time":DateTime.now().toString(),
          "LastMessageSendBy":myId,
        };
        DatabaseMethods().updateLastMessageSend(widget.chatRoomId, lastMessageInfoMap);
      });
    }
  }


  Widget chatMessageTitle(String message ,String imageUrl, String audioUrl,bool sendByMe , String time){
    return Row(
      mainAxisAlignment: sendByMe? MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
              bottomRight: sendByMe?Radius.circular(0):Radius.circular(24),topRight: Radius.circular(24),
              bottomLeft: sendByMe ? Radius.circular(24):Radius.circular(0),),
              color: sendByMe? Colors.blue.shade400.withOpacity(0.2):Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: sendByMe ?CrossAxisAlignment.end: CrossAxisAlignment.start,
              children: [
                if(message!="")
                  Text(message, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),),
                if(imageUrl!="")
                  Image(image: Image.network(imageUrl).image,height: 400,width: MediaQuery.of(context).size.width/2,),
                if(audioUrl!="")
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                   child: Row(
                     children: [
                       IconButton(
                           onPressed: ()async{
                             // await player.setSourceUrl(audioUrl);
                             //  print(player.setSourceUrl(audioUrl,mimeType: acc));
                             await player.play(UrlSource(audioUrl));
                             //duration= await player.getDuration();
                           },
                           icon: Icon(Icons.play_arrow)),
                       Expanded(child: LinearProgressIndicator(
                         value: 1,
                       )),
                       // Text(duration.toString()),
                     ],
                   ),
                  ),
                Text(time,style: TextStyle(color: Colors.black38),),
              ],
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_rounded, size: 30,)),
                  CircleAvatar(
                    backgroundImage: Image.network(widget.image).image,
                    radius: 20,
                  ),
                  Text(widget.name),
                ],
              ),
            ),
            Icon(Icons.info),
          ],
        ),
      ),





      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: messRoom ,
          builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
            print(snapshot.hasData);
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData){
              return Center(child: Text("Các bạn hiện đã là bạn bè , hãy gửi lời nhắn cho nhau"),);
            }
            return ListView.builder(
                reverse: true,
                itemCount:  snapshot.data!.size,
                itemBuilder: (context , index){
                    DocumentSnapshot ds=snapshot.data!.docs[index];
                    String image;
                    String mess;
                    String audio;
                    try {
                      image = ds.get("image");
                    } catch (e) {
                      image = ""; // gán giá trị mặc định nếu không tồn tại trường image
                    }
                    try {
                      mess=ds.get("message");
                    } catch (e) {
                      mess = ""; // gán giá trị mặc định nếu không tồn tại trường image
                    }
                    try {
                      audio=ds.get("audio");
                    } catch (e) {
                      audio = ""; // gán giá trị mặc định nếu không tồn tại trường image
                    }
                    return chatMessageTitle(mess,image, audio ,myId==snapshot.data!.docs[index]["sendBy"],snapshot.data!.docs[index]["ts"]);
                },
            );
          },
        ),
      ),





      bottomNavigationBar: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: MediaQuery.of(context).viewInsets.bottom+20,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:Colors.white
              ),
              child: Column(
                children: [
                  _selectedImage!=null?Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width/1,
                    child: Image(
                      image: Image.file(_selectedImage!).image,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width/1,
                      height: 400,
                    ),
                  ):
                  SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.camera_alt_outlined,size: 30,),
                     IconButton(
                          onPressed: ()async{
                              _pickImageGallery();
                          },
                          icon: Icon(Icons.photo_album_outlined,size: 30,)),
                      GestureDetector(
                        onLongPress: ()async{
                          await startRecording();
                        },
                        onLongPressEnd: (longEnd)async{
                          await stopRecording();
                          await addAudio(_audioPath!);
                        },
                        child: IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.mic_rounded,size: 30,)),
                      ),
                     Container(
                              width: MediaQuery.of(context).size.width/2.6,
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200,
                            ),
                            child: TextField(
                                onTap: (){
                                    setState(() {
                                      _emojiShowing=false;
                                    });
                                },
                                scrollController: _scrollController,
                                controller: messController,
                                onChanged: (value){
                                  if(value.length>0){
                                    setState(() {
                                      haveContent=true;
                                    });
                                  }else{
                                    setState(() {
                                      haveContent=false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  helperMaxLines: 1,
                                   // contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    border: InputBorder.none,
                                  suffixIcon: IconButton(
                                      onPressed: (){
                                        setState(() {
                                          _emojiShowing = !_emojiShowing;
                                          if (_emojiShowing) {
                                            FocusScope.of(context).unfocus(); // Ẩn bàn phím
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.emoji_emotions_outlined,size: 30,)),
                                  hintText: "Nhắn tin"
                                ),
                            ),
                          ),
                      haveContent?IconButton(
                        highlightColor: Colors.orangeAccent,
                        onPressed: (){
                          if(messController.text==""){
                            addImage(true);
                            print("Da gui hinh anh");
                          }else{
                            addMessage(true);
                            print("Da gui tin nhan");
                          }
                          setState(() {

                          });
                        },
                        icon:  Icon(Icons.send_outlined,size: 30,)) :Icon(Icons.thumb_up,size: 30,),
                    ],
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !_emojiShowing,
              child: EmojiPicker(
                onEmojiSelected: (a ,b){
                   setState(() {
                     haveContent=true;
                   });
                },
                textEditingController: messController,
                scrollController: _scrollController,
                config: Config(
                  bottomActionBarConfig: BottomActionBarConfig(showBackspaceButton: false ,showSearchViewButton: false),
                  height: 256,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    emojiSizeMax: 28 *
                        (foundation.defaultTargetPlatform ==
                            TargetPlatform.iOS
                            ? 1.2
                            : 1.0),
                  ),
                  swapCategoryAndBottomBar: true,
                  skinToneConfig: const SkinToneConfig(),
                  categoryViewConfig: const CategoryViewConfig(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
