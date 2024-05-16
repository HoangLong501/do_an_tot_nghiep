
import 'dart:async';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import '../service/database.dart';
import 'lib_class_import/user.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
   late List<Person> userlist = [];
  List items = [0, 1, 2];
  TextEditingController searchConTroller = TextEditingController();
  bool isVisible=true;
  String? birthDate="",
  email="",
  id="",
  phone="",
  sex= "",
  username="",
  image="";
  List<Person> uSers=[];
   List listRequest=[];
   List listReceive=[];
   List listFriend=[];
   List<String> listHideHintsFriend=[];
   Stream<List<String>>? listGetHideHintsFriend;
   Stream<List<Person>>? hideHintsUsers;
   List<Person> listHideHintsUsers=[];
   Stream<List<String>>? getListReceived;

  onLoad()async{
    listHideHintsUsers=await DatabaseMethods().getUser();
    //print(listHideHintsUsers);
    id=(await SharedPreferenceHelper().getIdUser());
    hideHintsUsers=await DatabaseMethods().getHideHintsUsers(id!, listHideHintsUsers);
    await for(List<Person> key in hideHintsUsers!){
      uSers=key;
    }
    await for(List<String> list in getListReceived!){
      listReceive=list;
    }
   // print(uSers);
    //print("danh sách $listHideHintsUsers");
   // print(id);
    listRequest=await DatabaseMethods().getRequest(id!);

    listFriend=await DatabaseMethods().getFriends(id!);
    //print(uSers);
    //print(uSers);

    setState(() {

    });
  }
void sendRequest(String idRequaest,String idReceived){

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
        title: Row(
          children: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
            //   },
            //   icon: Icon(Icons.arrow_back_ios),
            // ),
            SizedBox(width: 10), // Khoảng cách giữa icon và TextField
            Expanded(
              child: Container(
                height: 40, // Đặt chiều cao của TextField
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade200, // Đặt màu nền cho đường viền
                ),
                child: TextField(
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      setState(() {
                        isVisible = false;
                      });
                    } else {
                      setState(() {
                        isVisible = true;
                      });
                    }
                    try {
                      List<Person> result = await _SearchUser();
                      setState(() {
                        userlist = result;
                      });
                      print("Kết quả tìm kiếm: ${userlist.toString()}");
                    } catch (e) {
                      print("Lỗi tìm kiếm người dùng: $e");
                    }
                  },
                  controller:searchConTroller,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm trên...',
                    border: InputBorder.none,
                    // Loại bỏ đường viền của TextField
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10), // Đặt lề bên trong
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), // Chiều cao của Divider
          child: Divider(
              height: 1, thickness: 0.5, color: Colors.grey), // Đường gạch chia
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Gần đây",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Xem tất cả",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                // Chỉ sử dụng khoảng không gian cần thiết
                physics: NeverScrollableScrollPhysics(),
                // Không cho phép cuộn trong ListView này
                itemCount:userlist.length ,
                // Số lượng mục trong ListView
                itemBuilder: (BuildContext context, int index) {
                  Person person = userlist[index];
                  return Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                // Độ bo góc
                                image: DecorationImage(
                                  image:Image.network(person.image).image,
                                  fit: BoxFit
                                      .cover, // Đảm bảo hình ảnh vừa khớp trong container
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                            // List searched;
                            //   Map<String, dynamic> updateId = {
                            //     "Searched": person.id,
                            //   };
                              _updateSearched(id!,person.id);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Căn lề trái cho các phần tử trong cột
                              children: [
                                Text(
                                  person.username,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      size: 8,
                                      Icons.circle,
                                      // Sử dụng biểu tượng chấm ngang
                                      color: Colors
                                          .blue, // Đặt màu của biểu tượng là màu xanh
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "thông tin mới",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Spacer(), // Tạo một khoảng trống linh hoạt
                          IconButton(
                            onPressed: () {
                              // Hành động khi nút được nhấn
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors
                                  .grey.shade600, // Đặt màu của biểu tượng
                            ),
                          ),
                          SizedBox(width: 20), // Icon hoặc widget khác ở đây
                        ],
                      );
                },
              ),
              isVisible?
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Những người bạn có thể biết",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem tất cả",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  potentianlFriends(),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Các thước phim phổ biến bạn có thể thích",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem tất cả",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              width: 200,
                              height: 365, // Đặt chiều cao của Container
                              margin: EdgeInsets.only(
                                left: 10,
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // Cho phép cuộn ngang
                                  itemCount: 4,
                                  // Số lượng mục trong ListView
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          // Xử lý khi GestureDetector được nhấn
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),

                                                borderRadius: BorderRadius.circular(
                                                    10), // Độ bo góc
                                              ),
                                              width: 200,
                                              // Đặt chiều rộng của Container
                                              height: 365,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              // Đặt khoảng cách giữa các phần tử
                                              child:   ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(
                                                  "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                            )));
                                  })))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Nhóm dành cho bạn",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem tất cả",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 250,
                          height: 380, // Đặt chiều cao của Container
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
                            itemCount: 4, // Số lượng mục trong ListView
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  // Xử lý khi GestureDetector được nhấn
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),

                                      borderRadius:
                                      BorderRadius.circular(10), // Độ bo góc
                                    ),
                                    width: 250,
                                    // Đặt chiều rộng của Container
                                    height: 370,
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    // Đặt khoảng cách giữa các phần tử

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // Căn lề trái cho các phần tử trong cột
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(9),
                                              topRight: Radius.circular(
                                                  9)), // Độ cong của góc bo tròn
                                          child: Image.network(
                                            "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Text(
                                            "name $index",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              height: 24,
                                              child: Text(
                                                "350 thành viên . 10 bài viết/tháng",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              // Đặt chiều cao của Container
                                              width: 80,
                                              // Đặt chiều rộng của Container
                                              child: Stack(
                                                children: List.generate(
                                                    items.length, (index) {
                                                  return Positioned(
                                                    right: 15 + index * 15,
                                                    // Tăng vị trí của mỗi ảnh trước để nó đè lên ảnh sau một phần
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        // Đảm bảo container có hình dạng tròn
                                                        border: Border.all(
                                                          // Định nghĩa viền
                                                          color: Colors.white,
                                                          // Màu của viền
                                                          width:
                                                          2, // Độ dày của viền
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundImage:
                                                        NetworkImage(
                                                          "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            Expanded(
                                                child: Text(
                                                  "Những người bạn là thành viên",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                            ),

                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              // Xử lý khi nút được nhấn
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all<
                                                  Color>(
                                                  Colors.blue.shade800),
                                              // Màu nền của nút
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Bo góc của nút
                                                ),
                                              ),
                                            ),
                                            child:  Center(

                                              child: Text(
                                                "Tham gia",
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Màu văn bản
                                                ),
                                              ),
                                            ),

                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Thử nhiều hơn trên Facebook",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/pf9WhKD/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Nhắc đến bạn",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/TBL2dbh/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Bình luận của bạn",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/ZBq245P/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Bài viết bạn đã th...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/n31CXVY/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Sinh nhật",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/jHT3ttL/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Đã lưu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/d0tdJgN/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Bạn bè",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/QK25Gxp/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Marketplace",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/TH2YrpP/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Nhóm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/Lx3gq6w/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Reels",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/q9L29J9/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Kỷ niệm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,)
                ],
              ): SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
  Widget potentianlFriends (){
    return StreamBuilder<List<Person>>(
        stream: DatabaseMethods().getHideHintsUsers(id!,uSers), // Lắng nghe thay đổi từ Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }else {
            //print(snapshot.hasData);
    return snapshot.hasData?

      Row(
      children: [
        Expanded(
          child: Container(
            width: 250,
            height: 365, // Đặt chiều cao của Container
            margin: EdgeInsets.only(
              left: 10,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
              itemCount: uSers.length, // Số lượng mục trong ListView
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(

                  onTap: () {

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),

                        borderRadius:
                        BorderRadius.circular(10), // Độ bo góc
                      ),
                      width: 250,
                      // Đặt chiều rộng của Container
                      height: 350,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      // Đặt khoảng cách giữa các phần tử

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Căn lề trái cho các phần tử trong cột
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(9),
                                topRight: Radius.circular(
                                    9)), // Độ cong của góc bo tròn
                            child: Image.network(
                              uSers[index].image,

                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              uSers[index].username,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                // Đặt chiều cao của Container
                                width: 80,
                                // Đặt chiều rộng của Container
                                child: Stack(
                                  children: List.generate(
                                      items.length, (index) {
                                    return Positioned(
                                      right: 15 + index * 15,
                                      // Tăng vị trí của mỗi ảnh trước để nó đè lên ảnh sau một phần
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // Đảm bảo container có hình dạng tròn
                                          border: Border.all(
                                            // Định nghĩa viền
                                            color: Colors.white,
                                            // Màu của viền
                                            width:
                                            2, // Độ dày của viền
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundImage:
                                          NetworkImage(
                                            "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Text(
                                "bạn chung",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              if(listRequest.contains(uSers[index].id))
                                TextButton(
                                  onPressed: () async {
                                    print("danh sách gửi");
                                    await DatabaseMethods().deleteRequest(id!, uSers[index].id);
                                    List updateRequest=await DatabaseMethods().getRequest(id!);
                                    setState(()   {
                                      listRequest=updateRequest;
                                      print("danh sách request: $listRequest");
                                    });

                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty
                                        .all<Color>(Colors
                                        .blue
                                        .shade800),
                                    // Màu nền của nút
                                    shape: MaterialStateProperty
                                        .all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            10.0), // Bo góc của nút
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      if(listRequest.contains(uSers[index].id))
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .person_remove,
                                              color: Colors
                                                  .white, // Màu biểu tượng
                                            ),
                                            SizedBox(width: 5),
                                            // Khoảng cách giữa biểu tượng và văn bản
                                            Text(
                                              "Hủy lời mời",
                                              style: TextStyle(
                                                color: Colors
                                                    .white, // Màu văn bản
                                              ),
                                            )
                                          ],
                                        )
                                      else
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .person_add_alt_1,
                                              color: Colors
                                                  .white, // Màu biểu tượng
                                            ),
                                            SizedBox(width: 5),
                                            // Khoảng cách giữa biểu tượng và văn bản
                                            Text(
                                              "thêm bạn bè",
                                              style: TextStyle(
                                                color: Colors
                                                    .white, // Màu văn bản
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                )
                                else
                                  TextButton(
                                    onPressed: ()async {
                                     // print("elseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                                      await DatabaseMethods()
                                          .requestFriend(
                                          id!,
                                          uSers[index]
                                              .id);
                                      List  updateListRequest=await DatabaseMethods().getRequest(id!) ;
                                      setState(()   {
                                        listRequest= updateListRequest;
                                        print("Thêm bạn bè: $listRequest");
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty
                                          .all<Color>(Colors
                                          .blue
                                          .shade800),
                                      // Màu nền của nút
                                      shape: MaterialStateProperty
                                          .all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10.0), // Bo góc của nút
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons
                                              .person_add_alt_1,
                                          color: Colors
                                              .white, // Màu biểu tượng
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Thêm bạn bè",
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Màu văn bản
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                              SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                  onPressed: () async {
                                   await DatabaseMethods().addHideHintsFriend(id!, uSers[index].id);

                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateColor
                                        .resolveWith((states) =>
                                    Colors.grey.shade300),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        )),
                                  ),
                                  child: Text(
                                    "Xóa",
                                    style: TextStyle(
                                        color: Colors.black),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ):Center(child: CircularProgressIndicator(),);
          }
    }
    );
  }
   Future<List<Person>> _SearchUser() async {
     try {
       String userName = searchConTroller.text;
       List<Person> userlist = (await DatabaseMethods().getUserByName(userName));
      // print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      // print(userlist.toString());
      // print(userlist.length);
       return userlist;
     } catch (e) {
       // Xử lý các lỗi khác nếu có
       print("Error searching for user: $e");
       return []; // Trả về danh sách trống trong trường hợp có lỗi
     }
   }
   Future<void> _updateSearched(String id, String idSearchUser) async {
     try {
       // Lấy thông tin người dùng từ Firestore
       QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(id);
       // Lấy danh sách "Searched" từ tài liệu người dùng
       List searched = querySnapshot.docs[0]["Searched"];
       // Kiểm tra xem idSearchUser đã tồn tại trong searched hay chưa
       if (!searched.contains(idSearchUser)) {
         // Nếu idSearchUser chưa tồn tại trong searched, thêm nó vào danh sách
         searched.add(idSearchUser);
         // Tạo một Map mới để cập nhật thông tin người dùng
         Map<String, dynamic> updatedUserInfo = {
           "Searched": searched
         };

         // Cập nhật thông tin người dùng trong Firestore
         await DatabaseMethods().updateUserDetail(id, updatedUserInfo);
       }
     } catch (e) {
       print("Lỗi khi cập nhật searched: $e");
     }
   }

}


