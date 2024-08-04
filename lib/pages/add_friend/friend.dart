import 'package:do_an_tot_nghiep/pages/add_friend/hintfriend.dart';
import 'package:do_an_tot_nghiep/pages/add_friend/received.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/frienddail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/database.dart';
import '../../service/shared_pref.dart';
class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<String> listFriend=[];
  Stream<QuerySnapshot>? getListFriend;
  String id="";
  onLoad() async {
    id= (await SharedPreferenceHelper().getIdUser())! ;
    print(id);
    getListFriend=await DatabaseMethods().getFriend(id);
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
          title:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child:  Center(

                  child: Text("Bạn bè",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              Icon(
                Icons.search,
              )
            ],
          ) ,
        ),
        body: SingleChildScrollView(
            child: Column(
                children: [

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),

                  //getHint()
                   getFriends()
                ]
            )
        )
    );
  }
Widget getFriends(){
  return StreamBuilder<QuerySnapshot>(
    stream: getListFriend,
    builder: (context,AsyncSnapshot<QuerySnapshot> snapshot)    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Center(child: Text("lỗi ròi"));
      }else if(snapshot.data == null ||snapshot.data!.docs.isEmpty){
        return Center(child: Text("bạn chưa có bạn nào"));
      }
      else {
        return snapshot.hasData?
        Container(
            //height: MediaQuery.of(context).size.height,
            child:  Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          " ${snapshot.data!.docs.length} Bạn bè ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),// Ngăn ListView.builder cuộn độc lập
                    itemCount: snapshot.data!.docs.length, // Số lượng mục trong ListView
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> data =snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      print("id laf : ${data['id']}");
                      return FriendDetail(idFriend: data["id"]);

                    }
                ),

              ],
            )

        ):Center(child: Text("bị lỗi rồi"));
      }
    },

  );
  }
}
