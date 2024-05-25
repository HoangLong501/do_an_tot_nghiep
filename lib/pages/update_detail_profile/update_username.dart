import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UpdateUserName extends StatefulWidget {
  final String idUser;
  const UpdateUserName({super.key,required this.idUser});

  @override
  State<UpdateUserName> createState() => _UpdateUserNameState();
}

class _UpdateUserNameState extends State<UpdateUserName> {
  TextEditingController userNameController=TextEditingController();
  String oldName="", username="";
  final _formKey = GlobalKey<FormState>();
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(widget.idUser);
      oldName = querySnapshot.docs[0]["Username"];
    }catch(error){
      print("lỗi lấy thông tin người dùng");
    }
  }
  onLoad() async {
  await getData();
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Tên",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      body: Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height/1.75,
       child: Padding(
         padding: EdgeInsets.all(10),
         child: Container(
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(4)
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(
                 padding: EdgeInsets.only(left: 20),
                 child: Text(
                   "Nhập tên",
                   style: TextStyle(
                     fontSize: 20
                   ),
                 ),
               ),
               Divider(height: 0.1,color: Colors.grey.shade300,),
               SizedBox(height: 20,),
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 child: TextFormField(
                   validator: (value){
                     if(value==null||value.isEmpty){
                       return "Vui lòng điền tên bạn muốn thay đổi!";
                     }
                     return null;
                   },
                   controller: userNameController,
                   decoration: InputDecoration(
                     filled: true,
                     fillColor: Colors.white,
                     hintText: oldName,
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(6)
                     )
                   ),
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Container(
                   height: MediaQuery.of(context).size.height/7,
                   width: MediaQuery.of(context).size.width,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(6),
                     color: Colors.grey.shade200,

                   ),
                   padding: EdgeInsets.all(10),
                   child: Text(
                     "Lưu ý: đây là tên hiện thiện thị trên trang cá nhân của bạn, khi bạn đổi thì tên trên trang của bạn cũng đổi và bạn bè của bạn cũng sẽ dùng tên này để tìm ra bạn!",
                   style: TextStyle(
                     fontSize: 16,
                   ),
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     onPressed: () async {
                       if(_formKey.currentState!.validate()){
                         setState(() {
                         username=  userNameController.text;
                         });
                         Map<String,dynamic> userInfoMap={
                           "Username": username
                         };
                          await DatabaseMethods().updateUser(widget.idUser, userInfoMap);
                         showGeneralDialog(
                           barrierColor: Colors.black.withOpacity(0.5),
                           transitionBuilder: (context, a1, a2, widget) {
                             return Transform.scale(
                               scale: a1.value,
                               child: Opacity(
                                 opacity: a1.value,
                                 child: AlertDialog(
                                   shape: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(16.0),
                                   ),
                                   title: Column(
                                     children: [
                                       Text('Thông báo'),
                                       Divider(height: 0.1,color: Colors.grey.shade400,),
                                     ],
                                   ),
                                   content:Text('Bạn đã đổi tên $oldName thành $username',
                                     style: TextStyle(
                                         fontSize: 16
                                     ),
                                   ),
                                   actions: <Widget>[
                                     TextButton(
                                       child: Text('OK'),
                                       onPressed: () {
                                         Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                       },
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },
                           transitionDuration: Duration(milliseconds: 200),
                           barrierDismissible: true,
                           barrierLabel: '',
                           context: context,
                           pageBuilder: (context, animation1, animation2) {
                             return SizedBox.shrink();
                           },
                         );
                       }


                     },
                     style: ButtonStyle(
                       backgroundColor: MaterialStateProperty.all(Colors.blue.shade600,),
                       shape: MaterialStateProperty.all(
                           RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(6),
                           )
                       )
                     ),
                     child: Text(
                       "Lưu thay đổi",
                       style: TextStyle(
                         fontSize: 20,
                         color: Colors.white
                       ),
                         ),
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(20),
                 child: SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(

                     onPressed: (){

                     },
                     style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all(Colors.grey.shade300,),
                         shape: MaterialStateProperty.all(
                             RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(6),
                             )
                         )
                     ),
                     child: Text(
                       "Hủy",
                       style: TextStyle(
                           fontSize: 20,
                           color: Colors.black
                       ),
                     ),
                   ),
                 ),
               )
             ]
           ),
         ),
       ),

      ),
      )
    );
  }
}
