import 'dart:io';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class test extends StatefulWidget {
  final String idUser;
  const test({Key? key, required this.idUser}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  late VideoPlayerController _controller;
  String searchString = "";
  final TextEditingController searchController = TextEditingController();
  onLoad() async {
        setState(() {});
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
        title: Text('Search Names'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Enter a letter to search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchString != "")
                  ? DatabaseMethods().getUserByName(searchString)
                  : FirebaseFirestore.instance.collection("user").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final results = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(results[index]['Username']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
