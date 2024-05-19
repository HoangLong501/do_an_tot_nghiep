import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/database.dart';
class ReceivedDetail extends StatefulWidget {
  final String idReceived;
  const ReceivedDetail({super.key, required this.idReceived});

  @override
  State<ReceivedDetail> createState() => _ReceivedDetailState();
}

class _ReceivedDetailState extends State<ReceivedDetail> {
String idReceiveds="",username="",image="";
bool addFriends=true;

Future<void> getData() async {
  QuerySnapshot querySnapshot = await DatabaseMethods().getUserById(widget.idReceived);
  username= querySnapshot.docs[0]["Username"];
  image= querySnapshot.docs[0]["imageAvatar"];
  print("dã vào");
  print(username);

}
onLoad() async{
  idReceiveds= (await SharedPreferenceHelper().getIdUser())!;
 await getData();
  print(image);
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
    return
         GestureDetector(
          onTap: (){
            print(image);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  height: 100,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        alignment:Alignment.centerLeft,
                        child: Text(
                          username,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "  bạn chung",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // if(!)
                          Container(
                              width: MediaQuery.of(context).size.width/3,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              child:
                              TextButton(
                                onPressed: () async
                                {
                                  Map<String,dynamic> receivedInfoMap={
                                    "id":widget.idReceived,
                                    "status":"friend"
                                  };
                                  Map<String,dynamic> requestInfoMap={
                                    "id":idReceiveds,
                                    "status":"friend"
                                  };
                                  DatabaseMethods().deleteHint(idReceiveds, widget.idReceived);
                                  DatabaseMethods().addFriends(widget.idReceived, idReceiveds, receivedInfoMap);
                                  DatabaseMethods().addFriends(idReceiveds,widget.idReceived , requestInfoMap);
                                  setState(() {
                                    addFriends=false;
                                  });
                                },
                                style:  ButtonStyle(
                                  backgroundColor:MaterialStateProperty.all<Color>(Colors.blue.shade800),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây
                                    ),
                                  ),
                                ),

                                child: Text("Chấp nhận",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                ),
                               )
                          ),
                                //     TextButton(
                          //       onPressed: () async
                          //       {
                          //
                          //       },
                          //       style:  ButtonStyle(
                          //         backgroundColor:MaterialStateProperty.all<Color>(Colors.grey.shade400),
                          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //           RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây
                          //
                          //           ),
                          //         ),
                          //       ),
                          //
                          //       child: Text("Bạn bè",
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             color: Colors.black
                          //         ),
                          //       ),
                          //     )
                          //
                          // ),
                          SizedBox(width: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width/4,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            child: TextButton(
                                onPressed: ()
                                {
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Đặt bán kính bo góc ở đây

                                    ),
                                  ),
                                ),
                                child: Text("Xóa",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black
                                  ),
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );


  }
}
