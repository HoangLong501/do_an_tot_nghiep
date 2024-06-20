import 'dart:io';
import 'dart:ui';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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
  bool showDelete = false, showColer = true, showItem = true,
      showPaintDetail = false,showDeleteGird=false,
      isPlaying=false,showDeleteMusic=false,type=false;
  double fontsize=16;
  TextEditingController textConTroller = TextEditingController();
  Offset offsetText  = Offset(50, 50);
  Offset offsetGirt=Offset(50, 50);
  Offset offsetMusic=Offset(50, 50);
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
  String gird="",nameMusic="",urlMusic="",imageMusic="",saveVideo="",videoUlr="";
  GlobalKey imageKey = GlobalKey();
  List<Map<String,dynamic>>? listMusic;
   int selectedRadio = 1,selecteRadioFriend=-1;
   ValueNotifier<List<String>> selectedFriendsNotifier = ValueNotifier([]);

   Future<void> cutVideo(File videoToCut) async {
     FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
     String outputPath = videoToCut.path;

     try {
       final arguments = ['-i', videoToCut.path, '-ss', '0', '-t','15', '-async','1', outputPath,];

       await flutterFFmpeg.executeWithArguments(arguments);
       File outpushFile = File(outputPath);
       setState(() {
         videoFile = VideoPlayerController.file(outpushFile);
         type = true;
       });
       videoFile!.play();
     } catch (e) {
       print('Error: $e');
     }
   }
   Future<void> getImage() async {
     final returnImage = await ImagePicker().pickMedia();
     if (returnImage != null) {
       File file = File(returnImage.path);
       String extension = returnImage.path.split('.').last.toLowerCase();
       setState(() {
         if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic', 'tiff']
             .contains(extension)) {
           imageFile=file;
           type=false;
         } else if (['mp4', 'mkv', 'mov', 'avi', 'wmv', 'flv', 'webm']
             .contains(extension)) {
           cutVideo(file);
         } else {
           print("không biết");
         }
       });
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
       RenderRepaintBoundary boundary = imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
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
   Future<void> uploadStory(String image,File audio) async {
    try {
      DateTime now = DateTime.now();
      String  idStory = DateFormat('yyyyMMddHHmm').format(now);
      String nameStory = randomAlphaNumeric(10);
        final refImage =type? FirebaseStorage.instance.ref().child('${widget.idUser}/story_image/$nameStory.mp4')
        :FirebaseStorage.instance.ref().child('${widget.idUser}/story_image/$nameStory.jpg');
        final refAudio = FirebaseStorage.instance.ref().child('${widget.idUser}/story_audio/$nameStory.mp3');
        final taskSnapshotImage = await refImage.putFile(File(image));
        final taskSnapshotAudio = await refAudio.putFile(audio);
        final audioUrl = await taskSnapshotAudio.ref.getDownloadURL();
        final imageUrl = await taskSnapshotImage.ref.getDownloadURL();
        final status;
        if(selectedRadio==1){
          status= "public";
        }else if(selectedRadio==2){
          status="friend";
        }else if(selectedRadio==3){
          status="private";
        }else{
          status=selectedFriendsNotifier;
        }
        Map<String, dynamic> userInfoMap = {
          "idstory": "story_$idStory",
          "iduser":widget.idUser,
          "urlstory_image": imageUrl,
          "urlstory_audio": audioUrl,
          "status":status,
          "times":DateTime.now().millisecondsSinceEpoch
        };
        DatabaseMethods().addStory("story_$idStory", userInfoMap);
    } catch (e) {
      print('Lỗi khi tải lên video: $e');
    }
  }
   Future<void> uploadStoryNotMusic(String image) async {
     try {
       DateTime now = DateTime.now();
       String  idStory = DateFormat('yyyyMMddHHmm').format(now);
       String nameStory = randomAlphaNumeric(10);
       final refImage =type? FirebaseStorage.instance.ref().child('${widget.idUser}/story_image/$nameStory.mp4')
           :FirebaseStorage.instance.ref().child('${widget.idUser}/story_image/$nameStory.jpg');
       final taskSnapshotImage = await refImage.putFile(File(image));
       final imageUrl = await taskSnapshotImage.ref.getDownloadURL();
       final status;
       if(selectedRadio==1){
         status= "public";
       }else if(selectedRadio==2){
         status="friend";
       }else if(selectedRadio==3){
         status="private";
       }else{
         status=selectedFriendsNotifier;
       }

       Map<String, dynamic> userInfoMap = {
         "idstory": "story_$idStory",
         "iduser":widget.idUser,
         "urlstory_image": imageUrl,
         "status":status,
         "urlstory_audio": "",
         "times":DateTime.now().millisecondsSinceEpoch
       };
       DatabaseMethods().addStory("story_$idStory", userInfoMap);
     } catch (e) {
       print('Lỗi khi tải lên video: $e');
     }
   }

  Future<void> onLoad() async {
    await getImage();
    await DatabaseMethods().getStickers();
    listMusic=await DatabaseMethods().getMusic("for you");
    List<String>? tempList = await DatabaseMethods().getStickers();
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
        key:imageKey ,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 70),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                if (imageFile != null )
                  Positioned.fill(
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )else if(videoFile !=null)
                  videoFile!.value.isInitialized
                ? Positioned.fill(
                  child: AspectRatio(
                        aspectRatio:videoFile!.value.aspectRatio,
                      child: Center(
                          child: VideoPlayer (
                            videoFile!,
                          ),
                      ),
                    ),
                ):Center(child: CircularProgressIndicator(),),

                if (showItem)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      _builderShowItem("Nhãn gián", CupertinoIcons.smiley_fill, () {
                        showGridDialog(context,listGird);
                      }),
                      SizedBox(height: 20),
                      _builderShowItem("Văn bản", CupertinoIcons.textformat, () {
                        setState(() {
                          showColer = false;
                          showItem = false;
                          showPaintDetail=false;
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
                      _builderShowItem("Hiệu ứng", CupertinoIcons.wand_stars, () {

                      }),
                      SizedBox(height: 20),
                      _builderShowItem("Quyền riêng tư", Icons.settings, () {
                        setState(() {
                          showPrivacyDialog(context);
                          print("đã mở privecy");
                        });
                      }),
                      SizedBox(height: 20),
                      _builderShowItem("Gắn thẻ", CupertinoIcons.person_2_fill, () {}),
                      SizedBox(height: 30,),
                      Container(
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/2+30,
                                                top: MediaQuery.of(context).size.height/3
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                 TextButton(
                                  onPressed: () async {
                                  setState(() {
                                  });
                                  showItem=false;
                                  if(showItem==false){
                                    if(urlMusic==""){
                                      String? image = type ?videoFiler.path:await captureAndSaveImageToTemporaryFile(imageKey);
                                      await uploadStoryNotMusic(image!);
                                      Navigator.pop(context);
                                    }else{
                                      File audio=  await _saveAudioToTempFile(urlMusic);
                                      String? image = type ?videoFiler.path:await captureAndSaveImageToTemporaryFile(imageKey);
                                      await uploadStory(image!, audio);
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
                          onDragUpdate: (details){
                            setState(() {
                              offsetText+=details.delta;
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
                          left: MediaQuery.of(context).size.width / 4,
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
                if(gird !="")
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
                                image: Image.network(gird).image,
                              ),
                            ),
                          ),
                          childWhenDragging: Container(),
                          onDragUpdate: (details){
                            setState(() {
                              offsetGirt+=details.delta;
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
                              image: Image.network(gird).image,
                            ),
                          ),
                        ),
                      ),
                      if (showDeleteGird)
                        Positioned(
                          bottom: 100,
                          left: MediaQuery.of(context).size.width / 4,
                          child: DragTarget<String>(
                            onAccept: (String data) {
                              setState(() {
                                gird ="";
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
                if(urlMusic !="")
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
                                onTap: (){
                                  setState(() {
                                  });
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
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(),
                          onDragUpdate: (details){
                            setState(() {
                              offsetMusic+=details.delta;
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
                              onTap: (){
                                setState(() {
                                });
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
                                    style: TextStyle(fontWeight: FontWeight.bold),
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
                          left: MediaQuery.of(context).size.width / 4,
                          child: DragTarget<String>(
                            onAccept: (String data) {
                              setState(() {
                                urlMusic="";
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
                          alignment: Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, 0.75),
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
                                      width: MediaQuery.of(context).size.width / 7,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(width: MediaQuery.of(context).size.width / 5),
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
                  showItem=true;
                  showPaintDetail=true;
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
                        height: MediaQuery.of(context).size.height/3,
                        width: 30,
                          child: RotatedBox(
                            quarterTurns: -1,
                             child:  Slider(
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
          height: MediaQuery.of(context).size.height * 2 / 3, // Chiều cao của bottom sheet
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
                  onTap: (){
                    setState(() {
                      gird=list[index];
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
    ValueNotifier<List<Map<String, dynamic>>> filteredListNotifier = ValueNotifier([]);

    // Fetch the initial "for you" list
    List<Map<String, dynamic>>? initialList = await DatabaseMethods().getMusic("for you");
    filteredListNotifier.value = initialList ?? [];

    searchController.addListener(() async {
      String query = searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        List<Map<String, dynamic>>? filteredList = await DatabaseMethods().getMusic(query);
        filteredListNotifier.value = filteredList ?? [];
      } else {
        List<Map<String, dynamic>>? filteredList = await DatabaseMethods().getMusic("for you");
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
              bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
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
                              onTap: (){
                                setState(() {
                                  imageMusic=musics["picture"];
                                  nameMusic=musics["title"];
                                  urlMusic=musics["url"];
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        musics["title"],
                                        style: TextStyle(fontWeight: FontWeight.bold),
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
  void showPrivacyDialog(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Text(
                        "Ai có thể xem tin của bạn?",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Tin của bạn sẽ được hiện thị trong vòng 24h",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              FontAwesomeIcons.globe,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Công khai",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                "Bất kì ai trên Facebook",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Spacer(),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio,
                            onChanged: (int? value) {
                              setModalState(() {
                                selectedRadio = value!;
                              });
                              setState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 60),
                        child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              CupertinoIcons.person_2,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bạn bè",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                "Chỉ bạn bè trên FaceBook",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Spacer(),
                          Radio(
                            value: 2,
                            groupValue: selectedRadio,
                            onChanged: (int? value) {
                              setModalState(() {
                                selectedRadio = value!;
                              });
                              setState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 60),
                        child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              CupertinoIcons.person,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chỉ mình tôi",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                "Chỉ mình bạn trên FaceBook",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Spacer(),
                          Radio(
                            value: 3,
                            groupValue: selectedRadio,
                            onChanged: (int? value) {
                              setModalState(() {
                                selectedRadio = value!;
                              });
                              setState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 60),
                        child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: (){
                          showCustom(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                CupertinoIcons.person_add,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tùy chỉnh",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                selectedFriendsNotifier==[]?
                                Text(
                                  "Chỉ những người bạn chọn trên FaceBook",
                                  style: TextStyle(fontSize: 16),
                                ):
                                Text(
                                  "Chỉ ${selectedFriendsNotifier.value.length} người bạn chọn trên FaceBook",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Spacer(),
                            Radio(
                              value: 4,
                              groupValue: selectedRadio,
                              onChanged: (int? value) {
                                setModalState(() {
                                  selectedRadio = value!;
                                });
                                setState(() {
                                  selectedRadio = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 60),
                        child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                    SizedBox(height: 50,),
                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Lưu",style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,

                        ),),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),

            );
          },
        );
      },
    );
  }
  void showCustom(BuildContext context) async {
     TextEditingController searchController = TextEditingController();
     ValueNotifier<List<Map<String, dynamic>>> filteredListNotifier = ValueNotifier([]);
     // Lấy danh sách bạn bè ban đầu
     List<String> listFriend = await DatabaseMethods().getFriends(widget.idUser);
     List<Map<String, dynamic>> initialFriendData = await Future.wait(
       listFriend.map((friendId) async {
         var userSnapshot = await DatabaseMethods().getUserById(friendId);
         var user = userSnapshot.docs.first;
         return {
           'friendId': friendId,
           'Username': user['Username'],
           'imageAvatar': user['imageAvatar'],
         };
       }),
     );
     filteredListNotifier.value = initialFriendData;
     searchController.addListener(() async {
       String query = searchController.text.toLowerCase();
       if (query.isNotEmpty) {
         List<Map<String, dynamic>> filteredList = initialFriendData
             .where((user) => user['Username'].toLowerCase().contains(query))
             .toList();
         filteredListNotifier.value = filteredList;
       } else {
         filteredListNotifier.value = initialFriendData;
       }
     });

     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       builder: (BuildContext context) {
         return StatefulBuilder(
           builder: (BuildContext context, StateSetter setModalState) {
             return SingleChildScrollView(
               child: Container(
                 padding: EdgeInsets.only(
                   bottom: MediaQuery.of(context).viewInsets.bottom,
                 ),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     SizedBox(height: 30),
                     Container(
                       width: MediaQuery.of(context).size.width / 1.1,
                       padding: EdgeInsets.only(left: 10),
                       decoration: BoxDecoration(
                         color: Colors.grey.shade300,
                         borderRadius: BorderRadius.circular(30),
                       ),
                       child: TextField(
                         controller: searchController,
                         decoration: InputDecoration(
                           icon: Icon(Icons.search),
                           hintText: "Tìm kiếm...",
                           border: InputBorder.none,
                         ),
                       ),
                     ),
                     Divider(color: Colors.grey.shade400, thickness: 1.5),
                     Container(
                       height: MediaQuery.of(context).size.height / 1.5,
                       child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                         valueListenable: filteredListNotifier,
                         builder: (context, filteredList, _) {
                           if (filteredList.isEmpty) {
                             return Center(child: Text('Không tìm thấy bạn bè'));
                           }
                           return ValueListenableBuilder<List<String>>(
                             valueListenable: selectedFriendsNotifier,
                             builder: (context, selectedFriends, _) {
                               return ListView.builder(
                                 itemCount: filteredList.length,
                                 itemBuilder: (context, index) {
                                   var user = filteredList[index];
                                   bool isSelected = selectedFriends.contains(user['friendId']);
                                   return ListTile(
                                     leading: CircleAvatar(
                                       backgroundImage: NetworkImage(user['imageAvatar']),
                                     ),
                                     title: Text(user['Username']),
                                     trailing: Checkbox(
                                       value: isSelected,
                                       onChanged: (bool? value) {
                                         setModalState(() {
                                           if (value != null && value) {
                                             selectedFriendsNotifier.value = List.from(selectedFriends)..add(user['friendId']);
                                           } else {
                                             selectedFriendsNotifier.value = List.from(selectedFriends)..remove(user['friendId']);
                                           }
                                         });
                                       },
                                     ),
                                   );
                                 },
                               );
                             },
                           );
                         },
                       ),
                     ),
                     Container(
                       width: MediaQuery.of(context).size.width / 1.2,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.blue,
                       ),
                       child: TextButton(
                         onPressed: () {
                           print(selectedFriendsNotifier.value);
                           Navigator.pop(context);
                         },
                         child: Text(
                           "Chọn người bạn",
                           style: TextStyle(
                             fontSize: 20,
                             color: Colors.white,
                           ),
                         ),
                       ),
                     ),
                     SizedBox(height: 20),
                   ],
                 ),
               ),
             );
           },
         );
       },
     );
   }
}

