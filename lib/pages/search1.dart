import 'package:do_an_tot_nghiep/pages/profile.dart';
import 'package:do_an_tot_nghiep/pages/profile_friend.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Search1 extends StatefulWidget {
  const Search1({super.key});

  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1> {
  TextEditingController searchController = TextEditingController();
  List<String> searchKey=[];
  String searchString = "";
  List searchResults = [];
  bool search=false;
  String? myId;
  
  List<String> generateSearchKeys(String fullName) {
    List<String> names = fullName.split(" ");
    Set<String> searchKeys = {};

    // Tạo các tổ hợp con của mỗi từ
    for (String name in names) {
      for (int i = 0; i < name.length; i++) {
        for (int j = i + 1; j <= name.length; j++) {
          searchKeys.add(name.substring(i, j).toUpperCase());
        }
      }
    }

    // Tạo các tổ hợp con của các cụm từ
    for (int i = 0; i < names.length; i++) {
      String combinedName = "";
      for (int j = i; j < names.length; j++) {
        combinedName = (combinedName.isEmpty ? names[j] : "$combinedName ${names[j]}");
        for (int k = 0; k < combinedName.length; k++) {
          for (int l = k + 1; l <= combinedName.length; l++) {
            searchKeys.add(combinedName.substring(k, l).toUpperCase());
          }
        }
      }
    }

    return searchKeys.toList();
  }
  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        search =false;
      });
      return;
    }

    String searchKey = query.toUpperCase();

    FirebaseFirestore.instance
        .collection('user')
        .where('SearchKey', arrayContains: searchKey)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    });
    setState(() {
      search=true;
    });

  }


  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();


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
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  width: MediaQuery.of(context).size.width/1.4,
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      controller:  searchController,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        border: InputBorder.none
                      ),
                      onChanged: (value){
                        setState(() {
                          searchString = value;
                        });

                        performSearch(value);
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),
      body: searchString.isNotEmpty? Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200
        ),
        height: MediaQuery.of(context).size.height/2,
        child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: GestureDetector(
                onTap: (){

                  if(searchResults[index]['IdUser']==myId){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)
                    =>Profile(idProfileUser: myId!)));
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)
                    =>ProfileFriend(idProfileUser: searchResults[index]['IdUser'])));
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: Image.network(searchResults[index]['imageAvatar']).image,
                      ),
                      SizedBox(width: 10),
                      Text(searchResults[index]['Username']),
                    ],
                  ),
                ),
              ),
              // Hiển thị các thông tin khác nếu cần
            );
          },
        ),
      ):Container(
        //Giao dien con lai


      ),
    );
  }
}
