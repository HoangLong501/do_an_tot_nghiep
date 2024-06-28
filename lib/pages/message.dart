import 'dart:io';
import 'package:do_an_tot_nghiep/pages/info_chatroom.dart';
import 'package:do_an_tot_nghiep/pages/info_mess.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/chatMessageTitle.dart';
import 'package:do_an_tot_nghiep/pages/notifications/noti.dart';
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
class Message extends StatefulWidget {
  final bool group;
  final String name , image , chatRoomId,contactUser;
  const Message({super.key,
    required this.name,
    required this.image,
    required this.chatRoomId,
    this.group=false,
    this.contactUser="",
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController messController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  Stream<QuerySnapshot>? messRoom;
  String? myId ,myName,messageId,_audioPath;
  final _scrollController = ScrollController();
  File? _selectedImage;
  bool _isRecording = false,haveContent =false,_emojiShowing = false , openKeyBroad=false;
  String avatar="" , nameSend="" , block="";
  Stream<String>? statusStream;
  Color themeColor = Colors.cyan.shade200;
  bool _isHovering = false;
  Stream<String> getStatus(String idChatRoom)async*{
    try{
      yield* FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(idChatRoom)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          // Nếu tài liệu tồn tại, trả về giá trị số lượng từ tài liệu
          return docSnapshot.data()?['block'] ?? ""; // Trả về 0 nếu không tìm thấy 'QUANTITY'
        } else {
          // Nếu tài liệu không tồn tại, trả về 0
          return "";
        }
      });
    }catch(e){
      yield* Stream.empty();
    }
  }



  Future _pickImageGallery()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = File(returnImage!.path);
        haveContent=_selectedImage!.isAbsolute;
      });
  }
  Future _pickImageCamera()async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
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
    await _recorder.deleteRecord(fileName: filePath);
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
    if(widget.group){
      messRoom = DatabaseMethods().getChatRoomMessage2(widget.chatRoomId);
    }else{
      messRoom = DatabaseMethods().getChatRoomMessage(widget.chatRoomId);
    }
    myId = await SharedPreferenceHelper().getIdUser();
    myName = await SharedPreferenceHelper().getUserName();
    DocumentSnapshot data= await FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoomId).get();
    try{
      block = data.get("block");
    }catch(e){
      block="";
    }
    try{
      themeColor = Color(int.parse(data.get("Theme")));
    }catch(e){
      themeColor = Colors.cyan.shade200;
    }
    statusStream = getStatus(widget.chatRoomId);
    
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("chatrooms")
        .doc(widget.chatRoomId).collection("chats").where("sendBy" , isNotEqualTo: myId).orderBy("time" ,descending: true).limit(1).get();
    for(var value in querySnapshot.docs){
        print(value["message"]);
        Map<String , dynamic> data ={
          "seen":true,
        };
        value.reference.update(data);
    }
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
        "seen":false,
      };
      if(widget.group){
        DatabaseMethods().addMessage2(widget.chatRoomId, messInfoMap).then((value){
          Map<String,dynamic> lastMessageInfoMap={
            "LastMessage":mess,
            "LastMessageSendTs":timeNow,
            "Time":DateTime.now().toString(),
            "LastMessageSendBy":myId,
            "userSent":myName,
          };
          DatabaseMethods().updateLastMessageSend2(widget.chatRoomId, lastMessageInfoMap);
          if(sendMess){
            messageId=null;
          }
          NotificationDetail().sendNotificationToGroupChat(widget.chatRoomId, "$myName : $mess", "Bạn có tin nhắn mới");
        });
      }else{
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
        if(widget.contactUser!=""){
          print(widget.contactUser);
          print("send noti to ${widget.contactUser}");
          NotificationDetail().sendNotificationToAnyDevice(widget.contactUser,"${widget.name}: $mess" , "Bạn có tin nhắn mới");
        }
      }
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
      if(widget.group){
        DatabaseMethods().addMessage2(widget.chatRoomId, messInfoMap).then((value){
          Map<String,dynamic> lastMessageInfoMap={
            "LastMessage":"Đã gửi 1 ảnh",
            "LastMessageSendTs":timeNow,
            "Time":DateTime.now().toString(),
            "LastMessageSendBy":myId,
          };
          DatabaseMethods().updateLastMessageSend2(widget.chatRoomId, lastMessageInfoMap);
          if(sendImage){
            _selectedImage=null;
          }
        });
      }else{
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
          }
        });
        if(widget.contactUser!=""){
          print(widget.contactUser);
          print("send noti to ${widget.contactUser}");
          NotificationDetail().sendNotificationToAnyDevice(widget.contactUser,"${widget.name}: đã gửi 1 ảnh" , "Bạn có tin nhắn mới");
        }
      }
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
      if(widget.group){
        DatabaseMethods().addMessage2(widget.chatRoomId, messInfoMap).then((value){
          Map<String,dynamic> lastMessageInfoMap={
            "LastMessage":"Đã gửi 1 đoạn ghi âm",
            "LastMessageSendTs":timeNow,
            "Time":DateTime.now().toString(),
            "LastMessageSendBy":myId,
          };
          DatabaseMethods().updateLastMessageSend2(widget.chatRoomId, lastMessageInfoMap);
        });
      }else{
        DatabaseMethods().addMessage(widget.chatRoomId, messInfoMap).then((value){
          Map<String,dynamic> lastMessageInfoMap={
            "LastMessage":"Đã gửi 1 đoạn ghi âm",
            "LastMessageSendTs":timeNow,
            "Time":DateTime.now().toString(),
            "LastMessageSendBy":myId,
          };
          DatabaseMethods().updateLastMessageSend(widget.chatRoomId, lastMessageInfoMap);
        });
        if(widget.contactUser!=""){
          print(widget.contactUser);
          print("send noti to ${widget.contactUser}");
          NotificationDetail().sendNotificationToAnyDevice(widget.contactUser,"${widget.name}: đã gửi 1 đoạn thoại" , "Bạn có tin nhắn mới");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
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
                  widget.image==""?CircleAvatar(
                    backgroundColor: Colors.blue,
                  ): CircleAvatar(
                    backgroundImage:Image.network(widget.image).image,
                    radius: 20,
                  ),
                  Text(widget.name),
                ],
              ),
            ),
            IconButton(
                onPressed: (){
                    if(widget.group){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InfoChatroom(idChatRoom: widget.chatRoomId,)));
                    }else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InfoMess(idChatRoom: widget.chatRoomId,)));
                    }

                },
                icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: MouseRegion(
        onEnter: (event) {
          setState(() {
            _isHovering = true;
          });
          print(_isHovering);
        },
        onExit: (event) {
          setState(() {
            _isHovering = false;
          });
          print(_isHovering);
        },
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: messRoom ,
            builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(!snapshot.hasData){
                return Center(child: Text("Các bạn hiện đã là bạn bè , hãy gửi lời nhắn cho nhau"),);
              }
              return ListView.builder(
                padding: EdgeInsets.only(left: 10),
                  reverse: true,
                  itemCount:  snapshot.data!.size,
                  itemBuilder: (context , index){
                      DocumentSnapshot ds=snapshot.data!.docs[index];
                      String image;
                      String mess;
                      String audio;
                      bool seen;
                      try {
                        seen = ds.get("seen");
                      } catch (e) {
                        seen = true; // gán giá trị mặc định nếu không tồn tại trường image
                      }
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
                    return ChatMessageTitle(key: ValueKey(ds.id) ,seen: seen ,theme: themeColor.value.toString() , group: widget.group,message: mess, imageUrl: image, audioUrl: audio, sendByMe: snapshot.data!.docs[index]["sendBy"], time: snapshot.data!.docs[index]["ts"]);
                  },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: StreamBuilder(stream: statusStream, builder: (context , AsyncSnapshot<String> snapshot){
          if(!snapshot.hasData){
            return Text("Khong co data");
          }
          if(snapshot.data==""){

            return SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            openKeyBroad==false? IconButton(
                                padding: EdgeInsets.all(-4),
                                onPressed: ()async{
                                  await _pickImageCamera();
                                },
                                icon: Icon(Icons.camera_alt_outlined,size: 30,)):SizedBox(),
                            openKeyBroad==false? IconButton(
                                padding: EdgeInsets.all(-4),
                                onPressed: ()async{
                                  _pickImageGallery();
                                },
                                icon: Icon(Icons.photo_album_outlined,size: 30,)):SizedBox(),
                            openKeyBroad==false? GestureDetector(
                              onLongPress: ()async{
                                await startRecording();
                              },
                              onLongPressEnd: (longEnd)async{
                                await stopRecording();
                                await addAudio(_audioPath!);
                              },
                              child: IconButton(
                                  padding: EdgeInsets.all(-4),
                                  onPressed: (){},
                                  icon: Icon(Icons.mic_rounded,size: 30,)),
                            ):SizedBox(),
                            Container(
                              width: openKeyBroad? MediaQuery.of(context).size.width/1.4:MediaQuery.of(context).size.width/2.6,
                              margin: EdgeInsets.only(top: 8,bottom: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200,
                              ),
                              child: TextField(
                                onTapOutside: (e){
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    openKeyBroad=false;
                                  });
                                },
                                onTap: (){

                                  setState(() {
                                    openKeyBroad=true;
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
                                icon: Icon(Icons.send_outlined,size: 30,)) :Icon(Icons.thumb_up,size: 30,),
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
                        height: 300,
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
            );
          }else{
            if(snapshot.data==myId){
              print("Id block :  ${snapshot.data}");
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                height: MediaQuery.of(context).size.height/11,
                child: Column(
                  children: [
                    Text(
                      "Hiện tại bạn đã chặn liên lạc từ người này!",style: TextStyle(
                        color: Colors.grey,fontWeight: FontWeight.w600 , fontSize: 18
                    ),
                    ),
                   TextButton(onPressed: ()async{
                      Map<String , dynamic> info={
                        "block":"",
                      };
                      await FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoomId).update(info);
                      setState(() {
                        block="";
                        statusStream = getStatus(widget.chatRoomId);
                      });
                    }, child: Text("Bỏ chặn")),
                  ],
                ),
              );

            }
            if(snapshot.data!=myId){
              print("Id be block :  ${snapshot.data}");
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                height: MediaQuery.of(context).size.height/11,
                child: Column(
                  children: [
                   Text(
                      "Hiện tại bạn không thể liên lạc với người này!",style: TextStyle(
                        color: Colors.grey,fontWeight: FontWeight.w600 , fontSize: 18
                    ),
                    ),
                    TextButton(onPressed: (){}, child: Text("Tìm hiểu thêm"))
                  ],
                ),
              );
            }
            return Text("Co data , co block");
          }
      })
    );

  }
}
