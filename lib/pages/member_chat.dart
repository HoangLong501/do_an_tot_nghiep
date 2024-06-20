import 'package:do_an_tot_nghiep/pages/add_member_groupchat.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/member_detail.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberChat extends StatefulWidget {
  final String idChatRoom;
  const MemberChat({super.key , required this.idChatRoom});
  @override
  State<MemberChat> createState() => _MemberChatState();
}

class _MemberChatState extends State<MemberChat> {
  bool selected=true;
  List members=[] , admin=[];
  int countMember=0 , countAdmin=0;
  Stream<List>? memberStream;
  onLoad()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).get();
    members = data.get("user");
    countMember = members.length;

    DocumentSnapshot data1 = await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).collection("info")
        .doc(widget.idChatRoom).get();
    admin =data1.get("admin");
    countAdmin=admin.length;
    memberStream = DatabaseMethods().getMemberStream(widget.idChatRoom);
    setState(() {

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
                IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_rounded ,size: 30,)),
                SizedBox(width: 20,),
                Text("Thành viên" ,style: TextStyle(fontSize: 24 ,fontWeight: FontWeight.w600),)
              ],
            ),
            TextButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddMemberGroupChat(idChatRoom: widget.idChatRoom,)));
            }, child: Text("Thêm",style: TextStyle(
              fontSize: 22,color: Colors.blue
            ),))
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){
                  setState(() {
                    if(selected){
                    }else{
                      selected=!selected;
                      print(selected);
                      memberStream = DatabaseMethods().getMemberStream(widget.idChatRoom);
                    }
                  });
                },
                    style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => !selected ? Colors.grey :Colors.blue,)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width/3.2,
                        child: Center(child: Text("Tất cả",style: TextStyle(color: Colors.black),)))),
                ElevatedButton(onPressed: (){
                  setState(() {
                    if(!selected){
                    }else{
                      selected=!selected;
                      print(selected);
                      memberStream = DatabaseMethods().getAdminStream(widget.idChatRoom);
                    }
                  });
                },
                    style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => selected ? Colors.grey :Colors.blue,)),
                    child: SizedBox(
                    width: MediaQuery.of(context).size.width/3.2,
                    child: Center(child: Text("Quản trị viên",style: TextStyle(color: Colors.black),)))),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
              child: selected? Text("$countMember  Thành viên" , style: TextStyle(
                fontSize: 18 , color: Colors.grey.shade700
              ),):Text("$countAdmin  Quản trị viên" , style: TextStyle(
                  fontSize: 18 , color: Colors.grey.shade700
              ),),
          ),
          StreamBuilder<List>(stream:memberStream,
              builder: (context ,AsyncSnapshot<List> snapshot){
                  if(snapshot.hasData){
                    return Expanded(
                          child:  ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context , index){
                                      return MemberDetail( key: ValueKey(snapshot.data),idUser: snapshot.data![index], idChatRoom: widget.idChatRoom,);
                                  },
                              ),);
                  }else{

                  }
                  return SizedBox();

              }
          ),

        ],
      ),
    );
  }
}

