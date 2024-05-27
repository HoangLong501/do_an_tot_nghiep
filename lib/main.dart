
import 'package:do_an_tot_nghiep/pages/add_friend/friend.dart';
import 'package:do_an_tot_nghiep/pages/add_friend/hintfriend.dart';
import 'package:do_an_tot_nghiep/pages/add_friend/received.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/allhintdetail.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/edit_profile_detail.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/hintdetail.dart';
import 'package:do_an_tot_nghiep/pages/menu.dart';
import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/createNewsfeed.dart';
import 'package:do_an_tot_nghiep/pages/menu.dart';
import 'package:do_an_tot_nghiep/pages/notifications/noti.dart';
import 'package:do_an_tot_nghiep/pages/option_profile.dart';
import 'package:do_an_tot_nghiep/pages/profile_friend.dart';
import 'package:do_an_tot_nghiep/pages/search.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/profile.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/edit_story.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_address.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_birthday.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_born.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_email.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_password.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_phone.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_relationship.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_sex.dart';
import 'package:do_an_tot_nghiep/pages/update_detail_profile/update_username.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     // home: Profile(idProfileUser: "Ly Ly_202405091941",),
      //home: CreateNewsFeed()
      //home: ProfileFriend(idProfileUser:"Ly Ly_202405091941",)
      //home: Home(),
      //home: Profile(idProfileUser: "haonguyen16022002"),
      //home: Login(),
      home: EditStory(),
    );
  }
}

