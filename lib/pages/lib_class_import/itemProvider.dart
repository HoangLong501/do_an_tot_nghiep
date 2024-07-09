import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemProvider with ChangeNotifier {
  List<DocumentSnapshot> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  List<String> _hideNewsfeed = [];
  List _unfollowedUsers = [];
  List<DocumentSnapshot> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? idUserDevice;

  Future<void> getidUserDevice() async {
    idUserDevice = await SharedPreferenceHelper().getIdUser();
  }

  Future<void> getHideItem(String id) async {
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(id)
        .collection("advance").doc(id).get();
    if (data.exists) {
      _hideNewsfeed = List<String>.from(data.get("hideNewsfeed"));
    } else {
      _hideNewsfeed = [];
    }
  }
  Future<void> getUnfollowedUsers(String id) async {
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("user").doc(id)
        .collection("advance").doc(id).get();
    try{
      _unfollowedUsers = data.get("unfollow");

    }catch(e){
      _unfollowedUsers=[];
    }
    // print("unfollowedUsers: $_unfollowedUsers");
  }
  Future<void> fetchPosts() async {
    await getidUserDevice();
    await getHideItem(idUserDevice!);
    await getUnfollowedUsers(idUserDevice!);
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    Query queryWithViewers = FirebaseFirestore.instance
        .collection('newsfeed')
        .where('viewers', arrayContains: idUserDevice)
        .orderBy('newTimestamp', descending: true)
        .limit(5);

    Query queryWithoutViewers = FirebaseFirestore.instance
        .collection('newsfeed')
        .where('viewers', isEqualTo: [])
        .orderBy('newTimestamp', descending: true)
        .limit(5);

    QuerySnapshot querySnapshotWithViewers = await queryWithViewers.get();
    QuerySnapshot querySnapshotWithoutViewers = await queryWithoutViewers.get();

    List<DocumentSnapshot> combinedPosts = [
      ...querySnapshotWithViewers.docs,
      ...querySnapshotWithoutViewers.docs
    ];

    combinedPosts.sort((a, b) => (b['newTimestamp']).compareTo(a['newTimestamp']));

    List<DocumentSnapshot> newItems = combinedPosts.where((doc) =>
    !_hideNewsfeed.contains(doc.id) &&
        !_unfollowedUsers.contains(doc['UserID'])).toList();
    _items = newItems;

    if (_items.isNotEmpty) {
      _lastDocument = _items.last;
    }

    _isLoading = false;
    _hasMore = combinedPosts.length == 10;
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    await getidUserDevice();
    await getHideItem(idUserDevice!);
    await getUnfollowedUsers(idUserDevice!);
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    Query queryWithViewers = FirebaseFirestore.instance
        .collection('newsfeed')
        .where('viewers', arrayContains: idUserDevice)
        .orderBy('newTimestamp', descending: true)
        .startAfterDocument(_lastDocument!)
        .limit(5);

    Query queryWithoutViewers = FirebaseFirestore.instance
        .collection('newsfeed')
        .where('viewers', isEqualTo: [])
        .orderBy('newTimestamp', descending: true)
        .startAfterDocument(_lastDocument!)
        .limit(5);

    QuerySnapshot querySnapshotWithViewers = await queryWithViewers.get();
    QuerySnapshot querySnapshotWithoutViewers = await queryWithoutViewers.get();

    List<DocumentSnapshot> combinedPosts = [
      ...querySnapshotWithViewers.docs,
      ...querySnapshotWithoutViewers.docs
    ];

    combinedPosts.sort((a, b) => (b['newTimestamp']).compareTo(a['newTimestamp']));

    List<DocumentSnapshot> newItems = combinedPosts.where((doc) =>
    !_hideNewsfeed.contains(doc.id) &&
        !_unfollowedUsers.contains(doc['UserID'])).toList();

    if (newItems.isNotEmpty) {
      _lastDocument = newItems.last;
    }

    _isLoading = false;
    _hasMore = combinedPosts.length == 10;
    notifyListeners();
  }

  void deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('newsfeed').doc(id).delete();
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void hideItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
