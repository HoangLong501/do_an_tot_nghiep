import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';


class EditStory extends StatefulWidget {
  const EditStory({Key? key});

  @override
  State<EditStory> createState() => _EditStoryState();
}

class _EditStoryState extends State<EditStory> {
  late File imageFile;
  bool showtext = false;
  Offset offset = Offset(50,50);
  List<Color> listColer=[Colors.black,Colors.red,Colors.blue,Colors.grey,Colors.amberAccent,Colors.lightBlue];
  Color textColes= Colors.black;

  Future<void> getImage() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage != null) {
      setState(() {
        imageFile = File(returnImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  Future<void> onLoad() async {
    await getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            if (imageFile != null)
              Positioned.fill(
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            Column(
              children: [
                SizedBox(height: 20),
                _builderShowItem("Nhãn gián", CupertinoIcons.smiley_fill, () {}),
                SizedBox(height: 20),
                _builderShowItem("Văn bản", CupertinoIcons.textformat, () {
                  setState(() {
                    showtext = true;
                    print("aaaaaaaaaaaaaaaaaaaaaaaaaaa${offset}");
                  });
                }),
                SizedBox(height: 20),
                _builderShowItem("Nhạc", CupertinoIcons.music_note_2, () {}),
                SizedBox(height: 20),
                _builderShowItem("Hiệu ứng", CupertinoIcons.wand_stars, () {}),
                SizedBox(height: 20),
                _builderShowItem("Vẽ", Icons.gesture, () {}),
                SizedBox(height: 20),
                _builderShowItem("Gắn thẻ", CupertinoIcons.person_2_fill, () {}),
              ],
            ),
            Positioned(
              left: offset.dx+400,
              top: offset.dy-2600,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    offset += details.delta;
                  });
                },
                child: Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Nhập văn bản của bạn ở đây...',
                        fillColor: Colors.transparent,
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
            ),

            if (showtext==true)
              editText(),
          ],
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
                  fontSize: 15,
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
Widget editText(){
  return Column(
    children: [
      Center(
        child: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView.builder(
                    itemCount: listColer.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context, listColer[index]);
                        },
                        leading: CircleAvatar(
                          backgroundColor: listColer[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ).then((selectedColor) {
              if (selectedColor != null) {
                
              }
            });
          },
          icon: Icon(Icons.palette),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 5),
        margin: EdgeInsets.only(left: 30),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Bắt đầu nhập',
            fillColor: Colors.transparent,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}
}
