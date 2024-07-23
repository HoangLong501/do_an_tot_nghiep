// import 'package:do_an_tot_nghiep/fan_page/create_new_page.dart';
import 'package:do_an_tot_nghiep/pages/add_friend/received.dart';
import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/profile.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/register.dart';
import 'package:do_an_tot_nghiep/pages/video.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'lib_class_import/userDetailProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Map<String,dynamic>>? listUserLogin;
  String? idUserCurrent;

  final _auth = FirebaseAuth.instance;

  onLoad()async{
    idUserCurrent = await SharedPreferenceHelper().getIdUser();
    listUserLogin=await SharedPreferenceHelper().getUserInfoList();
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
    final userDetailProvider = Provider.of<UserDetailProvider>(context);
    userDetailProvider.getUser();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.only(top: 40,left: 20,right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Menu",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                SizedBox(
                  width: MediaQuery.of(context).size.width/6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings),
                      Icon(Icons.search_outlined),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20,left: 8,right: 8,bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(idProfileUser:idUserCurrent!)));
                        },
                        child: SizedBox(
                          width:MediaQuery.of(context).size.width/2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              userDetailProvider.avatar==""?CircleAvatar(backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,):
                              CircleAvatar(backgroundImage: Image.network(userDetailProvider.avatar).image,),
                              SizedBox(width: 10,),
                              Text(userDetailProvider.name,style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          showUserLoginDialog(context,listUserLogin!);
                        },
                          child: Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            size: 30,
                            color: Colors.grey.shade700,
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateNewPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(CupertinoIcons.plus_circle_fill,color: Colors.grey.shade700,size: 30,),
                        Text("Tạo trang cá nhân hoặc Trang mới",
                        style: TextStyle(fontSize: 20,color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.groups,size: 30,color: Colors.blueAccent,),
                        Text("Nhóm",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.settings_backup_restore,size: 30,color: Colors.teal,),
                        Text("Kỷ niệm",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2.4,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,left:20 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.flag,size: 30,color: Colors.orange,),
                          Text("Trang",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Received()));
                  },
                 child:  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width/2.4,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.white
                    ),
                    child: Padding(

                      padding: const EdgeInsets.only(top: 20,left:20 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.people_alt_rounded,size: 30,color: Colors.lightBlue,),
                          Text("Bạn bè",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.bookmark,size: 30,color: Colors.pinkAccent,),
                        Text("Đã lưu",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                 GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Video()));
                  },
               child: Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,left:20 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.ondemand_video,size: 30,color: Colors.greenAccent,),
                          Text("Video",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.pages_rounded,size: 30,color: Colors.blueAccent,),
                        Text("Bảng feed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: MediaQuery.of(context).size.width/2.4,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.emoji_people_rounded,size: 30,color: Colors.redAccent,),
                        Text("Hẹn hò",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: ()async{
                await _auth.signOut();
                //logOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 100),
                width: 400,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Đăng xuất",style: TextStyle(
                    color: Colors.grey.shade700,fontSize: 20,fontWeight: FontWeight.w500
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          duration: Duration(milliseconds: 900),
                          type: PageTransitionType.rightToLeft,
                          isIos: true,
                          child: Home(),
                        ),
                      );

                    },
                    child: Icon(Icons.home_outlined ,
                      color: Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Video()));
                      setState(() {

                      });
                    },
                    child: Icon(Icons.ondemand_video ,
                      color:  Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.people ,
                      color: Colors.grey,
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {

                      });
                    },
                    child: Icon(Icons.notifications_none_outlined ,
                      color:  Colors.grey,
                    )),

              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: (){
                      print("press ---TREND-- Bottom Appbar");
                      setState(() {
                      });
                    },
                    child: Icon(Icons.menu ,
                      color:  Colors.blueAccent,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> logOut() async {
    await SharedPreferenceHelper().saveUserName("");
    await SharedPreferenceHelper().saveIdUser("");
    await SharedPreferenceHelper().saveUserPhone("");
    await SharedPreferenceHelper().saveImageUser("");
    await SharedPreferenceHelper().saveSex("");
    await SharedPreferenceHelper().saveBirthDate("");
    //@gmail.comawait SharedPreferenceHelper().saveUserInfoListUser([]);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
  }
  void showUserLoginDialog(BuildContext context, List<Map<String, dynamic>> listLogin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                height: MediaQuery.of(context).size.height / 1.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "Chuyển đổi tài khoản",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        itemCount: listLogin.length + 1,
                        itemBuilder: (context, index) {
                          Map<String, dynamic>? userId;
                          if (index == listLogin.length) {
                            userId = listLogin[index - 1];
                          } else {
                            userId = listLogin[index];
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (index == listLogin.length)
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Login(),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "thêm tài khoản khác",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    userLogin(userId!["email"], userId["password"]);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            userId!["avata"],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          userId["name"],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () async {
                                          bool confirmed = await showDeleteDialog(context);
                                          if (confirmed) {
                                            await SharedPreferenceHelper().deleteUserInfoList(userId!["id"]);
                                            setState(() {
                                              listLogin.remove(userId);
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.delete),
                                      )
                                    ],
                                  ),
                                ),
                              Container(
                                padding: EdgeInsets.only(left: 100),
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 0.9,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        child: Text(
                          "Tạo tài khoản mới",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
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
  }
  Future<void> userLogin(String gmail,String passWord) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: gmail, password: passWord);
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserByEmail(gmail);
      print('Number of documents: ${querySnapshot.size}');
       String birthDate = "${querySnapshot.docs[0]["Birthdate"]}";
      String email = "${querySnapshot.docs[0]["E-mail"]}";
      String id = "${querySnapshot.docs[0]["IdUser"]}";
      String phone = "${querySnapshot.docs[0]["Phone"]}";
      String sex = "${querySnapshot.docs[0]["Sex"]}";
      String username = "${querySnapshot.docs[0]["Username"]}";
      String images = "${querySnapshot.docs[0]["imageAvatar"]}";
      await SharedPreferenceHelper().saveUserName(username);
      await SharedPreferenceHelper().saveIdUser(id);
      await SharedPreferenceHelper().saveUserPhone(phone);
      await SharedPreferenceHelper().saveImageUser(images);
      await SharedPreferenceHelper().saveSex(sex);
      await SharedPreferenceHelper().saveBirthDate(birthDate);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email không tồn tại", style: TextStyle(fontSize: 18,color: Colors.white)),
            backgroundColor: Colors.black,
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sai mật khẩu", style: TextStyle(fontSize: 18,color: Colors.white)),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đăng nhập thất bại ", style: TextStyle(fontSize: 18,color: Colors.white)),
            backgroundColor: Colors.black,
          ),
        );
      }
    }
  }
  Future<bool> showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Column(
            children: [
              Text('Thông báo'),
              Divider(height: 0.1, color: Colors.grey.shade400),
            ],
          ),
          content: Text(
            'Bạn có muốn xoá khoản này không?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

}
