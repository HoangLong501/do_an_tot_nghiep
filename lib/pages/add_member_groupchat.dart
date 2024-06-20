import 'package:do_an_tot_nghiep/pages/member_chat.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddMemberGroupChat extends StatefulWidget {
  final String idChatRoom;
  const AddMemberGroupChat({super.key , required this.idChatRoom});

  @override
  State<AddMemberGroupChat> createState() => _AddMemberGroupChatState();
}

class _AddMemberGroupChatState extends State<AddMemberGroupChat> {
  String? myId;
  List myListFriend=[] , listMemberGroup =[] ,admin=[] ,list=[] , leader=[];
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
    myId = await SharedPreferenceHelper().getIdUser();
    myListFriend = await DatabaseMethods().getFriends(myId!);
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).get();
    listMemberGroup = data.get("user");
    for(int i=0;i<myListFriend.length;i++){
      if(!listMemberGroup.contains(myListFriend[i])){
        list.add(myListFriend[i]);
      }
    }
    print(list);
    DocumentSnapshot data1 = await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).collection("info")
        .doc(widget.idChatRoom).get();
    admin =data1.get("admin");
    try{
      leader =data1.get("leader");
    }catch(e){
      leader=[];
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
                IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_rounded ,size: 30,)),
                SizedBox(width: 20,),
                Text("Thêm người" ,style: TextStyle(fontSize: 24 ,fontWeight: FontWeight.w600),)
              ],
            ),
            TextButton(onPressed: ()async{
              if(admin.contains(myId) || leader.contains(myId)){
                List temp = await getSelectedKeys();
                if(temp.isNotEmpty){
                  for(var user in temp){
                    listMemberGroup.add(user);
                  }
                 Map<String , dynamic> updateMember={
                    "user":listMemberGroup,
                 };
                  await FirebaseFirestore.instance.collection("groupChat").doc(widget.idChatRoom).update(updateMember);
                  Navigator.of(context).pop();
                 // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MemberChat(idChatRoom: widget.idChatRoom)));
                }else{
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: Text("Thông báo!"),
                      content: Text("Hãy chọn ít nhất 1 thành viên để thêm"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text("Ok"))
                      ],
                    );
                  });
                }

              }else{
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Thông báo!"),
                    content: Text("Bạn không phải là Quản trị viên nên không thể thêm thành viên khác "),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("Ok"))
                    ],
                  );
                });
              }


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
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width/1,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tìm kiếm",
                  hintStyle: TextStyle(fontSize: 18 , color: Colors.grey),
                  prefixIcon: Icon(Icons.search ,color: Colors.grey,),
                ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Text("Gợi ý",style: TextStyle(fontSize: 18,color: Colors.grey.shade600),),
          ),
          Expanded(
              child: ListView(
                children: list.map((id) {
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
                            setState(() {
                              selectedItems[id] = value!;
                            });
                            print(selectedItems);
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
    );
  }


}

