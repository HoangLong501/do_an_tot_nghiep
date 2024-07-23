import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
class ChatMessageTitle extends StatefulWidget {
  final bool group , seen;
  final String message,imageUrl,audioUrl,sendByMe,time , theme;
  const ChatMessageTitle({super.key,
      required this.message,
      required this.imageUrl,
      required this.audioUrl,
      required this.sendByMe,
      required this.time,
      required this.group,
      required this.theme,
       this.seen=false,
  });

  @override
  State<ChatMessageTitle> createState() => _ChatMessageTitleState();
}

class _ChatMessageTitleState extends State<ChatMessageTitle> {
  bool who=false;
  String? myId;
  String name="",image="";
  AudioPlayer player = AudioPlayer();

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    who = myId==widget.sendByMe;
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(widget.sendByMe).get();
    name = data.get("Username");
    image = data.get("imageAvatar");
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    if (mounted) {
      setState(() {
        // cập nhật trạng thái
      });
    }
  }
  @override
  void initState() {
   super.initState();
   onLoad();
  }
  void dispose() {
    player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: who? MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        widget.group? who?SizedBox():
        CircleAvatar(
          backgroundImage: image!=""? Image.network(image).image :Image.asset("assets/images/avatar.jpg").image,
        ):SizedBox(),
        Flexible(
          child: Column(
            crossAxisAlignment:who?CrossAxisAlignment.end: CrossAxisAlignment.start,
            children: [
              widget.group ? !who ? Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(name ,style: TextStyle(fontSize: 16,color: Colors.grey),)):SizedBox() :SizedBox(),
              Container(
                padding: EdgeInsets.only(bottom: 8,left: 12,right: 12,top: 4),
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
                  bottomRight: who?Radius.circular(0):Radius.circular(24),topRight: Radius.circular(24),
                  bottomLeft: who ? Radius.circular(24):Radius.circular(0),),
                  color: who? Colors.white.withAlpha(Color(int.parse(widget.theme)).value).withRed(Color(int.parse(widget.theme)).value) :
                  Colors.white.withAlpha(Color(int.parse(widget.theme)).value),
                ),
                child: Column(
                  crossAxisAlignment: who ?CrossAxisAlignment.end: CrossAxisAlignment.start,
                  children: [
                    if(widget.message!="")
                      Text(widget.message, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),),
                    if(widget.imageUrl!="")
                      Image(image: Image.network(widget.imageUrl).image,height: 400,width: MediaQuery.of(context).size.width/2,),
                    if(widget.audioUrl!="")
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: ()async{
                                  // await player.setSourceUrl(audioUrl);
                                  //  print(player.setSourceUrl(audioUrl,mimeType: acc));
                                  await player.play(UrlSource(widget.audioUrl));
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
                    Text(widget.time,style: TextStyle(color: Colors.black38),),
                  ],
                ),
              ),
              who? !widget.seen? Container(
                  margin: EdgeInsets.only(right: 16,bottom: 10),
                  child: Text("Đã gửi")):SizedBox() : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
