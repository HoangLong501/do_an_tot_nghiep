import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/shared_pref.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController questionController = TextEditingController();
  String? myId;
  List item=[];

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    QuerySnapshot data = await FirebaseFirestore.instance.collection("notification").doc(myId).collection("detail").get();
    for(var value in data.docs){
      item.add(value);
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back , size: 32,)),
                Text('Thông báo' , style: TextStyle(fontWeight: FontWeight.w700),),
              ],
            ),
            IconButton(onPressed: (){}, icon: Icon(Icons.search , size: 32,))
          ],
        ),
      ),
      body:item.isNotEmpty ? Container(
        margin: EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height/1.2,
        child: ListView.builder(
            itemCount: item.length,
            itemBuilder:(context , index){
              return DetailNoti(id: item[index].get("ID"),content: item[index].get("content"),ts: item[index].get("ts"),);
            }
        ),
      ):Center(child: Text("Bạn chưa có thông báo",style: TextStyle(fontSize: 20),),)
    );
  }
}

class DetailNoti extends StatefulWidget {
  final String id , content , ts;
  const DetailNoti({super.key , required this.id , required this.content , required this.ts});

  @override
  State<DetailNoti> createState() => _DetailNotiState();
}

class _DetailNotiState extends State<DetailNoti> {
  String image = "";
  String? myId;

  updateCheckNotification(String id)async{
    QuerySnapshot data = await FirebaseFirestore.instance.collection("notification").doc(id).collection("detail").where("check",isEqualTo: false).get();
    for( var value in data.docs){
      await FirebaseFirestore.instance.collection("notification").doc(id).collection("detail").doc(value.id).update({"check":true});
    }
  }

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(widget.id).get();
    image = data.get("imageAvatar");
    await updateCheckNotification(myId!);
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
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image!=""? CircleAvatar(
            backgroundImage: Image.network(image).image,
            radius: 36,
          ):CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 36,
          ),
          SizedBox(width: 10,),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width/1.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.content , style: TextStyle(fontSize: 16 ,),),
                Text(widget.ts , style: TextStyle(color: Colors.grey.shade600),)
              ],
            ),
          ),
        ],
      ),
    );
  }


}
