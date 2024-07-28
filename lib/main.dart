
import 'package:do_an_tot_nghiep/pages/chatPage.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/itemProvider.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/userDetailProvider.dart';
import 'package:do_an_tot_nghiep/pages/noti_page.dart';
import 'package:do_an_tot_nghiep/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ItemProvider()),
          ChangeNotifierProvider(create: (_) => UserDetailProvider()),
        ],
        child: MyApp(),
      ),
    );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
       home: AuthUser(),
      //home: ChatPage(),

    );
  }
}

