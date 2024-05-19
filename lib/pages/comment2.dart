import 'package:flutter/material.dart';

class Comment2 extends StatefulWidget {
 final String idComment;
  const Comment2({super.key ,required this.idComment});

  @override
  State<Comment2> createState() => _CommentState();
}
class _CommentState extends State<Comment2> {
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
                  padding: EdgeInsets.only(top: 20 ,left: 20,right: 20),
                  child:  Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("data",style: TextStyle(fontSize: 20),),
                                Icon(Icons.thumb_up_alt_outlined),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/1.3,
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(),
                                      height:600,
                                      child: Text("ngu"),
                                      // child: ListView.builder(
                                      //     itemCount: 10,
                                      //     itemBuilder: (context,index){
                                      //       return Row(
                                      //         children: [
                                      //           CircleAvatar(
                                      //             backgroundColor: Colors.blue,
                                      //             radius: 30,
                                      //           ),
                                      //           Container(
                                      //             padding:EdgeInsets.all(8),
                                      //             decoration: BoxDecoration(
                                      //               color: Colors.grey.shade400.withOpacity(0.5),
                                      //               borderRadius: BorderRadius.circular(16),
                                      //             ),
                                      //             child: Column(
                                      //               crossAxisAlignment: CrossAxisAlignment.start,
                                      //               children: [
                                      //                 Text("User name $index" , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      //                 Text("Content",style: TextStyle(fontSize: 15),),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       );
                                      //     },
                                      // ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                            margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade400
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left: 20 ),
                                child: TextField(
                                  onTap: (){
                                    print("Tap vao input");
                                  },
                                  controller: contentController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Viết bình luận"
                                  ),
                                ),
                              ),
                            ),
                        // Container(
                        //   height: 500,
                        //   child: Text("BINH LUAN"),
                        // ),
                      ],
          ),
      ),
    );
  }
}
