import 'package:do_an_tot_nghiep/pages/comment.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class WidgetNewsfeed extends StatefulWidget {
  final String username ,time , content ,image, id , idComment;
  const WidgetNewsfeed({super.key ,
      required this.id,
    required this.username,
    required this.content,
    required this.time,
    required this.image,
    required this.idComment
  });
  @override
  State<WidgetNewsfeed> createState() => _WidgetNewsfeedState();
}

class _WidgetNewsfeedState extends State<WidgetNewsfeed> {

  final _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10 ,left: 20,right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundImage: Image.network("https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png").image,
                    radius: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        Text("01/01/2001",style: TextStyle(fontSize: 12,color:Colors.grey.shade600 ),),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Icon(Icons.linear_scale_outlined,size: 20,color: Colors.grey,),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(top: 16,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text(widget.content),
                ),
                SizedBox(height: 4,),
               widget.image!=""? Image(image: Image.network(widget.image).image,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width/1,
                ):SizedBox(),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(left: 20 , right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.thumb_up_alt_outlined ,color: Colors.grey.shade600,),
                          SizedBox(width: 6,),
                          Text("Thích" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          _overlayController.toggle();
                        },
                        child: OverlayPortal(
                          controller: _overlayController,
                          overlayChildBuilder: (context){
                            return Draggable(
                              feedback: SizedBox(),
                              child: Container(
                                  margin:EdgeInsets.only(top: 100),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent
                                  ),
                                  width: MediaQuery.of(context).size.width/1,
                                  height: 700,
                                  child: Text("Overplay")),
                            );
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.comment_bank_outlined ,color: Colors.grey.shade600,),
                                SizedBox(width: 6,),
                                Text("Bình luận" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                              ],
                            ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.chat_bubble_outline ,color: Colors.grey.shade600,),
                          SizedBox(width: 6,),
                          Text("Gửi" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.turn_slight_right_outlined ,color: Colors.grey.shade600,),
                          SizedBox(width: 6,),
                          Text("Chia sẽ" , style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
