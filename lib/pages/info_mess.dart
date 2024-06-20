import 'package:do_an_tot_nghiep/pages/member_chat.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
class InfoMess extends StatefulWidget {
  final String idChatRoom;
  const InfoMess({super.key , required this.idChatRoom});

  @override
  State<InfoMess> createState() => _InfoChatroomState();
}

class _InfoChatroomState extends State<InfoMess> {
  String image="" , nameChat="" , id="";
  String? myId;
  Color pickedColor = Colors.white;
  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("chatrooms").doc(widget.idChatRoom).get();
    id = data.get("UserContact");
    print(pickedColor);
    pickedColor = Color(int.parse(data.get("Theme")));
    print(pickedColor);
    DocumentSnapshot data1 = await FirebaseFirestore.instance.collection("user").doc(id).get();
    nameChat = data1.get("Username");
    try{
      image = data1.get("imageAvatar");
    }
    catch(e){
      image="";
    }
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
      appBar: AppBar(
        //backgroundColor: Colors.white,
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
                ],
              ),
            ),
            IconButton(onPressed: (){


            }, icon: Icon(CupertinoIcons.ellipsis_vertical)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: image=="" ? Center(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 60,
                ),
              ) :Center(
                child: CircleAvatar(
                  backgroundImage: Image.network(image).image,
                  radius: 60,
                ),
              ) ,
            ),
            Center(child: Text(nameChat , style: TextStyle(fontSize: 28 , fontWeight: FontWeight.w500),)),
            Text("Tùy chỉnh" , style: TextStyle(fontSize: 16,color: Colors.grey),),
            TextButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickedColor,
                          onColorChanged: (color) {
                            setState(() {
                              pickedColor = color;
                            });
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Done'),
                          onPressed: ()async{
                            Map<String , dynamic> data={
                              "Theme":pickedColor.value.toString()
                            };
                            await FirebaseFirestore.instance.collection("chatrooms").doc(widget.idChatRoom).update(data);
                            Navigator.of(context).pop();
                            print(pickedColor); // Print the selected color value
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Icon(CupertinoIcons.circle_lefthalf_fill,size: 30 , color: pickedColor,),
                  SizedBox(width: 20,),
                  Text("Chủ đề" , style: TextStyle(fontSize: 18),),
                ],
              ),
            ),
            Row(
              children: [
                Icon(CupertinoIcons.hand_thumbsup,size: 30 , color: Colors.blue,),
                SizedBox(width: 20,),
                Text("Cảm xúc nhanh" , style: TextStyle(fontSize: 18),),
              ],
            ),
            TextButton(
              onPressed: (){

              },
              child: Row(
                children: [
                  Icon(CupertinoIcons.pencil_ellipsis_rectangle,size: 30 , color: Colors.blue,),
                  SizedBox(width: 20,),
                  Text("Biệt danh" , style: TextStyle(fontSize: 18),),
                ],
              ),
            ),
            Text("Hành động khác" , style: TextStyle(fontSize: 16,color: Colors.grey),),
            Row(
              children: [
                Icon(CupertinoIcons.bell_fill,size: 30 , color: Colors.blue,),
                SizedBox(width: 20,),
                Text("Thông báo & âm thanh" , style: TextStyle(fontSize: 18),),
              ],
            ),
            Row(
              children: [
                Icon(CupertinoIcons.pin_fill,size: 30 , color: Colors.blue,),
                SizedBox(width: 20,),
                Text("Xem tin nhắn đã ghim" , style: TextStyle(fontSize: 18),),
              ],
            ),
            Text("Khác" , style: TextStyle(fontSize: 16,color: Colors.grey),),
            TextButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Xác nhận !"),
                    content: Text("Bạn muốn chặn liên lạc với người này ? "),
                    actions: [
                      TextButton(onPressed: ()async{
                        Map<String , dynamic> info={
                          "block":myId,
                        };
                        await FirebaseFirestore.instance.collection("chatrooms").doc(widget.idChatRoom).update(info);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                      }, child: Text("Ok")),
                      TextButton(onPressed: ()async{
                        Navigator.of(context).pop();
                      }, child: Text("Cancel"))
                    ],
                  );
                });


              },
              child: Row(
                children: [
                  Icon(Icons.block_sharp,size: 30 , color: Colors.redAccent,),
                  SizedBox(width: 20,),
                  Text("Chặn" , style: TextStyle(fontSize: 18 , color: Colors.redAccent),),
                ],
              ),
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }


}
