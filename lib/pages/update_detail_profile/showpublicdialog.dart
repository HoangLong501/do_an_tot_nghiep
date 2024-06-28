import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../service/database.dart';

class ShowPublicDialog extends StatefulWidget {
  const ShowPublicDialog({super.key});

  @override
  State<ShowPublicDialog> createState() => _ShowPublicDialogState();
}

class _ShowPublicDialogState extends State<ShowPublicDialog> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<List<String>> showPublicDialog(BuildContext context) async {
  int selectedRadio = 1;
  ValueNotifier<List<String>> selectedFriendsNotifier = ValueNotifier([]);
  String? idUser = await SharedPreferenceHelper().getIdUser();
  List<String> listView = await DatabaseMethods().getFriends(idUser!);
  listView.add(idUser);

  List<String>? result = await showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Text(
                      "Ai có thể xem tin của bạn?",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            FontAwesomeIcons.globe,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Công khai",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "Bất kì ai trên Facebook",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        Spacer(),
                        Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (int? value) {
                            setModalState(() {
                              selectedRadio = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 60),
                      child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            CupertinoIcons.person_2,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bạn bè",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "Chỉ bạn bè trên FaceBook",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        Spacer(),
                        Radio(
                          value: 2,
                          groupValue: selectedRadio,
                          onChanged: (int? value) {
                            setModalState(() {
                              selectedRadio = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 60),
                      child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            CupertinoIcons.person,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chỉ mình tôi",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "Chỉ mình bạn trên FaceBook",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        Spacer(),
                        Radio(
                          value: 3,
                          groupValue: selectedRadio,
                          onChanged: (int? value) {
                            setModalState(() {
                              selectedRadio = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 60),
                      child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        showCustom(context, selectedFriendsNotifier, idUser);
                      },
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              CupertinoIcons.person_add,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tùy chỉnh",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              ValueListenableBuilder<List<String>>(
                                valueListenable: selectedFriendsNotifier,
                                builder: (context, selectedFriends, _) {
                                  return selectedFriends.isEmpty
                                      ? Text(
                                    "Chỉ những người bạn chọn trên FaceBook",
                                    style: TextStyle(fontSize: 16),
                                  )
                                      : Text(
                                    "Chỉ ${selectedFriends.length} người bạn chọn trên FaceBook",
                                    style: TextStyle(fontSize: 16),
                                  );
                                },
                              ),
                            ],
                          ),
                          Spacer(),
                          Radio(
                            value: 4,
                            groupValue: selectedRadio,
                            onChanged: (int? value) {
                              setModalState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 60),
                      child: Divider(thickness: 1.5, color: Colors.grey.shade400)),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        if (selectedRadio == 1) {
                          listView = [];
                        } else if (selectedRadio == 3) {
                          listView = [idUser];
                        } else if (selectedRadio == 4) {
                          listView = selectedFriendsNotifier.value;
                        }
                        Navigator.pop(context, listView);
                      },
                      child: Text(
                        "Lưu",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );

  return result ?? [];
}

void showCustom(BuildContext context, ValueNotifier<List<String>> selectedFriendsNotifier,String idUser) async {

  TextEditingController searchController = TextEditingController();
  ValueNotifier<List<Map<String, dynamic>>> filteredListNotifier = ValueNotifier([]);
  // Lấy danh sách bạn bè ban đầu
  List<String> listFriend = await DatabaseMethods().getFriends(idUser);
  List<Map<String, dynamic>> initialFriendData = await Future.wait(
    listFriend.map((friendId) async {
      var userSnapshot = await DatabaseMethods().getUserById(friendId);
      var user = userSnapshot.docs.first;

      return {
        'friendId': friendId,
        'Username': user['Username'],
        'imageAvatar': user['imageAvatar'],
      };
    }),
  );
  filteredListNotifier.value = initialFriendData;
  searchController.addListener(() async {
    String query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> filteredList = initialFriendData
          .where((user) => user['Username'].toLowerCase().contains(query))
          .toList();
      filteredListNotifier.value = filteredList;
    } else {
      filteredListNotifier.value = initialFriendData;
    }
  });

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Tìm kiếm...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade400, thickness: 1.5),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: filteredListNotifier,
                      builder: (context, filteredList, _) {
                        if (filteredList.isEmpty) {
                          return Center(child: Text('Không tìm thấy bạn bè'));
                        }
                        return ValueListenableBuilder<List<String>>(
                          valueListenable: selectedFriendsNotifier,
                          builder: (context, selectedFriends, _) {
                            return ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                var user = filteredList[index];
                                bool isSelected = selectedFriends.contains(user['friendId']);
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(user['imageAvatar']),
                                  ),
                                  title: Text(user['Username']),
                                  trailing: Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setModalState(() {
                                        if (value != null && value) {
                                          selectedFriendsNotifier.value = List.from(selectedFriends)..add(user['friendId']);
                                        } else {
                                          selectedFriendsNotifier.value = List.from(selectedFriends)..remove(user['friendId']);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: TextButton(
                      onPressed: () {
                        selectedFriendsNotifier.value.add(idUser);
                        print(selectedFriendsNotifier.value);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Chọn người bạn",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
