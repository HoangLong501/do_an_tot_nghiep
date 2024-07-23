import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class AuthUser extends StatelessWidget {
  const AuthUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context , snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Center(child: Text("Error , data does not exits"),);
          }else{
            if(snapshot.data == null){
              return Login();
            }else{
              return Home();
            }
          }
        } ,
      ),
    );
  }
}
