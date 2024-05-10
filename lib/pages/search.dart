import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Xử lý khi nút được nhấn
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            SizedBox(width: 10), // Khoảng cách giữa icon và TextField
            Container(
              height: 40, // Đặt chiều cao của TextField
              width: MediaQuery.of(context).size.width - 100, // Đặt chiều rộng của TextField
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Tìm kiếm trên...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Đặt lề bên trong
                ),
              ),
            ),
          ],
        ),
      ),


      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text("Gợi ý",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Text("Xem tất cả",

                style: TextStyle(

                  color: Colors.blue,
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
