import 'dart:io';
import 'dart:ui';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/showpublicdialog.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/paint_detail.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';


class EditStory extends StatefulWidget {
  final String idUser;
  const EditStory({Key? key, required this.idUser});

  @override
  State<EditStory> createState() => _EditStoryState();
}

class _EditStoryState extends State<EditStory> {
  File? imageFile;
  VideoPlayerController? videoFile;
  late File videoFiler;
  AudioPlayer audioPlayer = AudioPlayer();
  bool showDelete = false,
      showColer = true,
      showItem = true,
      showPaintDetail = false,
      showDeleteGird = false,
      isPlaying = false,
      showDeleteMusic = false,
      type = false;
  double fontsize = 16;
  TextEditingController textConTroller = TextEditingController();
  Offset offsetText = Offset(50, 50);
  Offset offsetGirt = Offset(50, 50);
  Offset offsetMusic = Offset(50, 50);
  List<Color> listColer = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.grey,
    Colors.amberAccent,
    Colors.lightBlue
  ];
  Color textColes = Colors.white;
  List<String> listGird = [];
  String gird = "",
      nameMusic = "",
      urlMusic = "",
      imageMusic = "",
      saveVideo = "",
      videoUlr = "",
      imageStory = "";
  GlobalKey imageKey = GlobalKey();
  List<Map<String, dynamic>>? listMusic;
  int selectedRadio = 1,
      selecteRadioFriend = -1;
  ValueNotifier<List<String>> selectedFriendsNotifier = ValueNotifier([]);
  List<String> listFriend = [];

  Future<void> getImage() async {
    final returnImage = await ImagePicker().pickMedia();
    if (returnImage != null) {
      File file = File(returnImage.path);
      String extension = returnImage.path
          .split('.')
          .last
          .toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic', 'tiff']
          .contains(extension)) {
        setState(() {
          imageFile = file;
          type = false;
        });
      } else if (['mp4', 'mkv', 'mov', 'avi', 'wmv', 'flv', 'webm']
          .contains(extension)) {
        await cutVideo(file);
      } else {
        print("Không biết");
      }
    }
  }

  Future<void> cutVideo(File videoToCut) async {
    FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
    String outputPath = videoToCut.path;
    try {
      // Đường dẫn lưu ảnh trích xuất từ khung hình tại giây thứ 1
      Directory tempDir = await getTemporaryDirectory();
      String framePath = '${tempDir.path}/frame_at_1s.jpg';
      // Khởi tạo VideoPlayerController để lấy thời lượng video
      VideoPlayerController controller = VideoPlayerController.file(videoToCut);
      Future<void> controllerInitialization = controller.initialize();
      // Trích xuất khung hình tại giây thứ 1
      final extractFrameArgs = [
        '-i', videoToCut.path,
        '-ss', '1',
        '-vframes', '1',
        framePath
      ];
      Future<void> extractFrameFuture = flutterFFmpeg.executeWithArguments(
          extractFrameArgs);

      // Chờ khởi tạo VideoPlayerController để lấy thời lượng video
      await controllerInitialization;
      int videoDurationSeconds = controller.value.duration.inSeconds;
      // Cắt video nếu cần thiết
      Future<void>? trimVideoFuture;
      if (videoDurationSeconds > 15) {
        final trimArgs = [
          '-i', videoToCut.path,
          '-ss', '0',
          '-t', '10',
          '-async', '1',
          outputPath,
        ];
        trimVideoFuture = flutterFFmpeg.executeWithArguments(trimArgs);
      }
      // Chờ hoàn tất trích xuất khung hình
      await extractFrameFuture;
      File frameFile = File(framePath);
      imageStory = frameFile.path;
      // Chờ hoàn tất cắt video nếu cần thiết
      if (trimVideoFuture != null) {
        await trimVideoFuture;
      }
      // Xác định file video cuối cùng để phát
      File finalVideoFile = videoDurationSeconds > 15
          ? File(outputPath)
          : videoToCut;

      if (mounted) {
        setState(() {
          videoFiler = finalVideoFile;
          videoFile = VideoPlayerController.file(finalVideoFile)
            ..setLooping(true);
          type = true;
        });
        await videoFile!.initialize();
        videoFile!.play();
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void playAudio() async {
    await audioPlayer.play(UrlSource(urlMusic));
    setState(() {
      isPlaying = true;
    });
  }

  void stopAudio() {
    audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  Future<String?> captureAndSaveImageToTemporaryFile(GlobalKey imageKey) async {
    try {
      RenderRepaintBoundary boundary = imageKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png);
      print("Chụp ảnh thành công");
      Uint8List? imageData = byteData?.buffer.asUint8List();
      if (imageData == null) {
        print('Không thể chuyển đổi dữ liệu ảnh.');
        return null;
      }
      Directory tempDir = await getTemporaryDirectory();
      String tempImagePath = '${tempDir.path}/temp_image.png';
      File imageFile = File(tempImagePath);
      await imageFile.writeAsBytes(imageData);
      return tempImagePath;
    } catch (e) {
      print('Lỗi khi chụp và lưu ảnh vào bộ nhớ tạm: $e');
      return null;
    }
  }

  Future<File> _saveAudioToTempFile(String urlMusic) async {
    try {
      final directory = await getTemporaryDirectory();
      final audioFilePath = '${directory.path}/temp_audio.mp3';
      final audioFile = File(audioFilePath);
      final response = await http.get(Uri.parse(urlMusic));
      if (response.statusCode == 200) {
        await audioFile.writeAsBytes(response.bodyBytes);
        return audioFile;
      } else {
        throw Exception('Lỗi khi tải âm thanh: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lưu file âm thanh tạm thời: $e');
      throw e;
    }
  }

  Future<void> uploadStory(String image, File audio, String video) async {
    try {
      DateTime now = DateTime.now();
      String idStory = DateFormat('yyyyMMddHHmm').format(now);
      String nameStory = randomAlphaNumeric(10);
      final refImage = FirebaseStorage.instance.ref().child(
          '${widget.idUser}/story_image/$nameStory.jpg');
      final refAudio = FirebaseStorage.instance.ref().child(
          '${widget.idUser}/story_audio/$nameStory.mp3');
      final taskSnapshotImage = await refImage.putFile(File(image));
      final taskSnapshotAudio = await refAudio.putFile(audio);
      final audioUrl = await taskSnapshotAudio.ref.getDownloadURL();
      final imageUrl = await taskSnapshotImage.ref.getDownloadURL();
      String videoUrl = "";
      if (type == true) {
        final refVideo = FirebaseStorage.instance.ref().child(
            '${widget.idUser}/story_video/$nameStory.mp4');
        final taskSnapshotVideo = await refVideo.putFile(File(video));
        videoUrl = await taskSnapshotVideo.ref.getDownloadURL();
      }
      Map<String, dynamic> userInfoMap = {
        "idstory": "story_$idStory",
        "iduser": widget.idUser,
        "urlstory_image": imageUrl,
        "urlstory_video": type ? videoUrl : "",
        "urlstory_audio": audioUrl,
        "status": listFriend,
        "times": DateTime
            .now()
            .millisecondsSinceEpoch
      };
      DatabaseMethods().addStory("story_$idStory", userInfoMap);
    } catch (e) {
      print('Lỗi khi tải lên video: $e');
    }
  }

  Future<void> uploadStoryNotMusic(String image, String video) async {
    try {
      DateTime now = DateTime.now();
      String idStory = DateFormat('yyyyMMddHHmm').format(now);
      String nameStory = randomAlphaNumeric(10);
      final refImage = FirebaseStorage.instance.ref().child(
          '${widget.idUser}/story_image/$nameStory.jpg');
      final taskSnapshotImage = await refImage.putFile(File(image));
      final imageUrl = await taskSnapshotImage.ref.getDownloadURL();
      String videoUrl = "";
      if (type == true) {
        final refVideo = FirebaseStorage.instance.ref().child(
            '${widget.idUser}/story_video/$nameStory.mp4');
        final taskSnapshotVideo = await refVideo.putFile(File(video));
        videoUrl = await taskSnapshotVideo.ref.getDownloadURL();
      }
      // final status;
      // if(selectedRadio==1){
      //   status= [];
      // }else if(selectedRadio==2){
      //   status=listFriend;
      // }else if(selectedRadio==3){
      //   status=[widget.idUser];
      // }else{
      //   status=selectedFriendsNotifier;
      // }
      Map<String, dynamic> userInfoMap = {
        "idstory": "story_$idStory",
        "iduser": widget.idUser,
        "urlstory_image": imageUrl,
        "urlstory_video": type ? videoUrl : "",
        "status": listFriend,
        "urlstory_audio": "",
        "times": DateTime
            .now()
            .millisecondsSinceEpoch
      };
      DatabaseMethods().addStory("story_$idStory", userInfoMap);
    } catch (e) {
      print('Lỗi khi tải lên video: $e');
    }
  }

  Future<void> onLoad() async {
    await getImage();
    await DatabaseMethods().getStickers();
    listMusic = await DatabaseMethods().getMusic("for you");
    List<String>? tempList = await DatabaseMethods().getStickers();
    // listFriend=await DatabaseMethods().getFriends(widget.idUser);
    listFriend.add(widget.idUser);
    setState(() {
      listGird = tempList!;
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

      body: RepaintBoundary(
        key: imageKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 70),
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Stack(
              children: [
                if (imageFile != null )
                  Positioned.fill(
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ) else
                  if(videoFile != null)
                    videoFile!.value.isInitialized
                        ? Positioned.fill(
                      child: AspectRatio(
                        aspectRatio: videoFile!.value.aspectRatio,
                        child: Center(
                          child: VideoPlayer(
                            videoFile!,
                          ),
                        ),
                      ),
                    ) : Center(child: CircularProgressIndicator(),),

                if (showItem)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      _builderShowItem(
                          "Nhãn gián", CupertinoIcons.smiley_fill, () {
                        showGridDialog(context, listGird);
                      }),
                      SizedBox(height: 20),
                      _builderShowItem(
                          "Văn bản", CupertinoIcons.textformat, () {
                        setState(() {
                          showColer = false;
                          showItem = false;
                          showPaintDetail = false;
                        });
                      }),
                      SizedBox(height: 20),
                      _builderShowItem("Nhạc", CupertinoIcons.music_note_2, () {
                        setState(() {
                          showMusicDialog(context);
                          print("đã mở nhạc");
                        });
                      }),
                      SizedBox(height: 20),
                      _builderShowItem(
                          "Hiệu ứng", CupertinoIcons.wand_stars, () {

                      }),
                      SizedBox(height: 20),
                      _builderShowItem(
                          "Quyền riêng tư", Icons.settings, () async {
                        List<String> listView = await showPublicDialog(context);
                        setState(() {
                          listFriend = listView;
                          print("đã mở privecy");
                        });
                      }),
                      SizedBox(height: 20),
                      _builderShowItem(
                          "Gắn thẻ", CupertinoIcons.person_2_fill, () {}),
                      SizedBox(height: 30,),
                      Container(
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(left: MediaQuery
                            .of(context)
                            .size
                            .width / 2 + 30,
                            top: MediaQuery
                                .of(context)
                                .size
                                .height / 3
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  showItem = false;
                                });
                                await Future.delayed(
                                    Duration(milliseconds: 200));
                                if (showItem == false) {
                                  if (urlMusic == "") {
                                    if (type) {
                                      videoFile!.pause();
                                    }
                                    String? video = type ? videoFiler.path : '';
                                    String? image = type
                                        ? imageStory
                                        : await captureAndSaveImageToTemporaryFile(
                                        imageKey);
                                    await uploadStoryNotMusic(image!, video);
                                    Navigator.pop(context);
                                  } else {
                                    File audio = await _saveAudioToTempFile(
                                        urlMusic);
                                    String? image = type
                                        ? imageStory
                                        : await captureAndSaveImageToTemporaryFile(
                                        imageKey);
                                    String? video = type ? videoFiler.path : '';
                                    await uploadStory(image!, audio, video);
                                    stopAudio();
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Text(
                                "Đăng",
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                if(showPaintDetail)
                  Stack(
                    children: [
                      Positioned(
                        left: offsetText.dx,
                        top: offsetText.dy,
                        child: Draggable<String>(
                          data: textConTroller.text,
                          feedback: Material(
                            type: MaterialType.transparency,
                            child: CustomPaint(
                              painter: PaintDetail(
                                  color: textColes,
                                  text: textConTroller.text,
                                  fontSize: fontsize),
                              child: Container(
                                width: 300,
                              ),
                            ),
                          ),
                          childWhenDragging: Container(),
                          onDragUpdate: (details) {
                            setState(() {
                              offsetText += details.delta;
                            });
                          },
                          onDragStarted: () {
                            setState(() {
                              showDelete = true;
                            });
                          },
                          onDragEnd: (details) {
                            setState(() {
                              showDelete = false;
                            });
                          },
                          child: GestureDetector(
                            child: CustomPaint(
                              painter: PaintDetail(
                                  color: textColes,
                                  text: textConTroller.text,
                                  fontSize: fontsize),
                              child: Container(
                                width: 300,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (showDelete)
                        Positioned(
                          bottom: 100,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width / 4,
                          child: DragTarget<String>(
                            onAccept: (String data) {
                              setState(() {
                                textConTroller.text = '';
                                showDelete = false;
                              });
                            },
                            builder: (BuildContext context,
                                List<String?> candidateData,
                                List<dynamic> rejectedData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete,
                                      size: 32, color: Colors.white),
                                  Text("Kéo vào đây để xóa",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                if(gird != "")
                  Stack(
                    children: [
                      Positioned(
                        left: offsetGirt.dx,
                        top: offsetGirt.dy,
                        child: Draggable<String>(
                          data: gird,
                          feedback: Material(
                            type: MaterialType.transparency,
                            child: GestureDetector(
                              child: Image(
                                image: Image
                                    .network(gird)
                                    .image,
                              ),
                            ),
                          ),
                          childWhenDragging: Container(),
                          onDragUpdate: (details) {
                            setState(() {
                              offsetGirt += details.delta;
                            });
                          },
                          onDragStarted: () {
                            setState(() {
                              showDeleteGird = true;
                            });
                          },
                          onDragEnd: (details) {
                            setState(() {
                              showDeleteGird = false;
                            });
                          },
                          child: GestureDetector(
                            child: Image(
                              image: Image
                                  .network(gird)
                                  .image,
                            ),
                          ),
                        ),
                      ),
                      if (showDeleteGird)
                        Positioned(
                          bottom: 100,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width / 4,
                          child: DragTarget<String>(
                            onAccept: (String data) {
                              setState(() {
                                gird = "";
                                showDeleteGird = false;
                              });
                            },
                            builder: (BuildContext context,
                                List<String?> candidateData,
                                List<dynamic> rejectedData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete,
                                      size: 32, color: Colors.white),
                                  Text("Kéo vào đây để xóa",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                if(urlMusic != "")
                  Stack(
                    children: [
                      Positioned(
                        left: offsetMusic.dx,
                        top: offsetMusic.dy,
                        child: Draggable<String>(
                          data: urlMusic,
                          feedback: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: 70,
                                      width: 70,
                                      child: Image.network(
                                        imageMusic,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      nameMusic,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(),
                          onDragUpdate: (details) {
                            setState(() {
                              offsetMusic += details.delta;
                            });
                          },
                          onDragStarted: () {
                            setState(() {
                              showDeleteMusic = true;
                            });
                          },
                          onDragEnd: (details) {
                            setState(() {
                              showDeleteMusic = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    height: 70,
                                    width: 70,
                                    child: Image.network(
                                      imageMusic,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    nameMusic,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (showDeleteMusic)
                        Positioned(
                          bottom: 100,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width / 4,
                          child: DragTarget<String>(
                            onAccept: (String data) {
                              setState(() {
                                urlMusic = "";
                                showDeleteMusic = false;
                                stopAudio();
                              });
                            },
                            builder: (BuildContext context,
                                List<String?> candidateData,
                                List<dynamic> rejectedData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete,
                                      size: 32, color: Colors.white),
                                  Text("Kéo vào đây để xóa",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),

                editText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builderShowItem(String text, IconData icon, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editText() {
    return Offstage(
      offstage: showColer,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: AlertDialog(
                          alignment: Alignment.lerp(
                              Alignment.topCenter, Alignment.bottomCenter,
                              0.75),
                          backgroundColor: Colors.transparent,
                          content: Container(
                            height: 20,
                            width: 100,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: listColer.map((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, color);
                                    },
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 7,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: color,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).then((selectedColor) {
                    if (selectedColor != null) {
                      setState(() {
                        textColes = selectedColor;
                      });
                    }
                  });
                },
                icon: Icon(Icons.palette),
              ),
              SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width / 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 90,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showColer = true;
                      showItem = true;
                      showPaintDetail = true;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    "Xong",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Positioned(
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3,
                  width: 30,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      value: fontsize,
                      min: 10,
                      max: 50,
                      onChanged: (value) {
                        setState(() {
                          fontsize = value;
                        });
                      },
                    ),

                  ),
                ),
              ),
              Positioned(
                left: offsetText.dx,
                top: offsetText.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      offsetText += details.delta;
                    });
                  },
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: textConTroller,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Nhập văn bản ',
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white,
                            fontSize: fontsize),
                      ),
                      style: TextStyle(
                        fontSize: fontsize,
                        color: textColes,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  void showGridDialog(BuildContext context, List<String> list) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 2 / 3, // Chiều cao của bottom sheet
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Số cột trong mỗi hàng
              mainAxisSpacing: 10.0, // Khoảng cách dọc giữa các item
              crossAxisSpacing: 10.0, // Khoảng cách ngang giữa các item
              childAspectRatio: 1.0, // Tỉ lệ khung hình của các item
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                width: 70,
                height: 70,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        gird = list[index];
                        print("link:$gird");
                      });
                    },
                    child: Image.network(list[index])
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showMusicDialog(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    ValueNotifier<
        List<Map<String, dynamic>>> filteredListNotifier = ValueNotifier([]);

    // Fetch the initial "for you" list
    List<Map<String, dynamic>>? initialList = await DatabaseMethods().getMusic(
        "for you");
    filteredListNotifier.value = initialList ?? [];

    searchController.addListener(() async {
      String query = searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        List<Map<String, dynamic>>? filteredList = await DatabaseMethods()
            .getMusic(query);
        filteredListNotifier.value = filteredList ?? [];
      } else {
        List<Map<String, dynamic>>? filteredList = await DatabaseMethods()
            .getMusic("for you");
        filteredListNotifier.value = filteredList ?? [];
      }
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.75,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: filteredListNotifier,
                    builder: (context, filteredList, _) {
                      if (filteredList.isEmpty) {
                        return Center(child: Text('No music found'));
                      }
                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> musics = filteredList[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageMusic = musics["picture"];
                                  nameMusic = musics["title"];
                                  urlMusic = musics["url"];
                                });
                                playAudio();
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    height: 70,
                                    width: 70,
                                    child: Image.network(
                                      musics["picture"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        musics["title"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(musics["name"]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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