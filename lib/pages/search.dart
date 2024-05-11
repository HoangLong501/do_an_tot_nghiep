import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List items = [0, 1, 2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Xử lý khi nút được nhấn
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            SizedBox(width: 10), // Khoảng cách giữa icon và TextField
            Expanded(
              child: Container(
                height: 40, // Đặt chiều cao của TextField
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade200, // Đặt màu nền cho đường viền
                ),
                child: TextField(
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
                itemCount: 4,
                // Số lượng mục trong ListView
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()));
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                // Độ bo góc
                                image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit
                                      .cover, // Đảm bảo hình ảnh vừa khớp trong container
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Xử lý khi cột được nhấp vào
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Căn lề trái cho các phần tử trong cột
                              children: [
                                Text(
                                  'name $index',
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
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
                                        TextButton(
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
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.person_add_alt_1,
                                                color: Colors
                                                    .white, // Màu biểu tượng
                                              ),
                                              SizedBox(width: 5),
                                              // Khoảng cách giữa biểu tượng và văn bản
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
                                            onPressed: () {},
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
              ),
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
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
