import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController nameGroupController = TextEditingController();
  List friends =[];
  List listSelected =[];
  String? userId;
  Map<String, bool> selectedItems = {};

  Future<Map<String, dynamic>> fetchFriendData(String id) async {
    // Giả sử bạn sử dụng Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user').doc(id).get();
    return doc.data() as Map<String, dynamic>;
  }
  Future<List> getSelectedKeys()async{
    return  selectedItems.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
  }
  onLoad()async{
    userId = await SharedPreferenceHelper().getIdUser();
    friends = await DatabaseMethods().getFriends(userId!);
    friends.remove(userId!);
    for (var item in friends) {
      selectedItems[item] = false;
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
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_rounded,size: 30,)),
                Text("Nhóm mới",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700),)
              ],
            ),

            ElevatedButton(
                onPressed: ()async{
                  List temp = await getSelectedKeys();
                  if(temp.isEmpty){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text("Thông báo!"),
                        content: Text("chưa có thành viên trong nhóm",style: TextStyle(
                          fontSize: 18
                        ),),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text("OK",style: TextStyle(
                            color: Colors.blue
                          ),))
                        ],
                      );
                    });
                  }else{
                    temp.add(userId);
                    String idGroup = randomAlphaNumeric(10);
                    Map<String , dynamic> chatRoomInfoMap={
                      "ID":idGroup,
                      "NameGroup":nameGroupController.text,
                      "LastMessage":"Gửi lời chào đến mọi người",
                      "userSent":"Hệ thống",
                      "Time":DateTime.now().toString(),
                      "user":temp,
                    };
                    print(chatRoomInfoMap);
                    DatabaseMethods().createGroupChat(idGroup, chatRoomInfoMap);
                    Map<String , dynamic> adminInfoMap={
                      "admin":[userId],
                      "owner":[userId],
                    };
                    print(adminInfoMap);
                    await FirebaseFirestore.instance.collection("groupChat").doc(idGroup)
                        .collection("info").doc(idGroup)
                        .set(adminInfoMap);

                    Navigator.of(context).pop();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith((states) => Colors.blue,),
                ),
                child: Text("Tạo",style: TextStyle(fontSize: 20),))
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: nameGroupController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tên nhóm"
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                child: Text("Gợi ý",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            ),
            Container(
              height: 700,
              child: ListView(
                children: friends.map((id) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchFriendData(id),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                       if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text("No data found"));
                      } else {
                        String image = snapshot.data!['imageAvatar']; // Giả sử dữ liệu có trường 'name'
                        String name =snapshot.data!['Username'];
                        return CheckboxListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: Image.network(image).image,
                                radius: 30,
                              ),
                              SizedBox(width: 20,),
                              Text(name , style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                            ],
                          ),
                          value: selectedItems[id] ?? false,
                          onChanged: (bool? value)async {
                            // await getSelectedKeys(listSelected);
                            setState(() {
                              selectedItems[id] = value!;
                            });
                          },
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
