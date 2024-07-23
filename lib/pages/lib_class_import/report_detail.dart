import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'itemProvider.dart';
class ReportDetail extends StatefulWidget {
  final String idNewsfeed;
  const ReportDetail({super.key , required this.idNewsfeed});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  int _currentStep = 0;
  int _lastStep = 0;
  String reason="";
  String selectReason1="Nội dung mang tính bạo lực, thù ghét hoặc gây phiền toái";
  String selectReason2="Thông tin sai sự thật, lừa đảo hoặc gian lận";
  String selectReason3="Bắt nạt , quấy rối hoặc lăng mạ/lạm dụng/ngược đãi";
  String detailText="";
  String detailText2="";
  String detailText3="";
  String content="";
  String? myId;

  onLoad()async{
    myId = await SharedPreferenceHelper().getIdUser();
    print(myId);
    if (mounted) {
      setState(() {
        // cập nhật trạng thái
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 400,
        padding: EdgeInsets.all(20),
        color: Colors.grey.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentStep==0?SizedBox(width: 34,):
                IconButton(
                  onPressed: () {
                    setState(() {
                      if(_lastStep==1){
                        _lastStep=0;
                        _currentStep =1;
                      }else{
                        _currentStep = 0;
                      }
                    });
                  },
                  color: Colors.black45,
                  icon: Icon(Icons.arrow_back_ios_new_outlined),
                ),
                DefaultTextStyle(style: TextStyle(color: Colors.black , fontSize: 18), child: Text("Báo cáo")),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.red,
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(height: 1,),
            DefaultTextStyle(style: TextStyle(color: Colors.black , fontSize: 18 ,fontWeight: FontWeight.w600), child: Text(""
                "Tại sao bạn báo cáo bài viết này?")),
            _lastStep==1? _buildSubmitContent() : _currentStep == 0 ? _buildInitialContent() : _buildDetailContent(),
          ],
        ),
      ),
    );
  }
  Widget _buildInitialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
              reason = selectReason1;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  child: Text(selectReason1),
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 2;
              reason = selectReason2;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  child: Text(selectReason2),
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 3;
              reason = selectReason3;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  child: Text(selectReason3),
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailContent() {
    if (_currentStep == 1) {
      detailText = "Mối đe dọa về an toàn có thể xảy ra ";
      detailText2 = "Kêu gọi hành vi bạo lực";
      detailText3 = "Thể hiện hành vi bạo lực, tử vong hoặc thương tích nghiêm trọng";
    } else if (_currentStep == 2) {
      detailText = "Gian lận hoặc lừa đảo";
      detailText2 = "Chia sẽ thông tin sai sự thật";
      detailText3 = "Spam";
    } else {
      detailText = "Bắt nạt hoặc quấy rối";
      detailText2 = "Có vẻ giống hành vi bóc lột tình dục";
      detailText3 = "Đe dọa chia sẽ hình ảnh khỏa thân của tôi";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextButton(
          onPressed: (){
            content = "$reason - $detailText";
            setState(() {
              _lastStep=1;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width/1.6,
                child:  DefaultTextStyle(
                    style: TextStyle(color: Colors.grey.shade700 , fontSize: 16 ),
                    child: Text(detailText),
                  ),
              ),
              Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: (){
            content = "$reason - $detailText2";
            setState(() {
              _lastStep=1;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width/1.6,
                child:  DefaultTextStyle(
                  style: TextStyle(color: Colors.grey.shade700 , fontSize: 16 ),
                  child: Text(detailText2),
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: (){
            content = "$reason - $detailText3";
            setState(() {
              _lastStep=1;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width/1.6,
                child:  DefaultTextStyle(
                  style: TextStyle(color: Colors.grey.shade700 , fontSize: 16 ),
                  child: Text(detailText3),
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildSubmitContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        DefaultTextStyle(
          style: TextStyle(color: Colors.grey.shade700 , fontSize: 16 ),
          child: Text("Chúng tôi chỉ xóa những nội dung vi phạm tiêu chuẩn công đồng , bạn hãy cân nhắc khi gửi báo cáo , chúng tôi sẽ phản hồi "
              "sau khi đã xem xét"),
        ),
        SizedBox(height: 50,),
        Center(
          child: TextButton(onPressed: (){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("Xác nhận"),
                content: Text("Bạn chắc chắn muốn gửi báo cáo với nội dung $content",style: TextStyle(
                    fontSize: 16
                ),),
                actions: [
                  TextButton(onPressed: ()async{
                    String id ="";
                    QuerySnapshot data = await FirebaseFirestore.instance.collection("newsfeed").doc(widget.idNewsfeed)
                    .collection("share").get();
                    if(data.docs.isNotEmpty){
                      id=data.docs[0]["ID"];
                    }else{
                      id = widget.idNewsfeed;
                    }
                    await FirebaseFirestore.instance.collection("report").doc("OBZUdRWJbFpeofVH1eal").collection("newsfeed")
                        .doc().set({
                      "idNewsfeed":id,
                      "content":content,
                      "reporter":myId
                    });
                    List temp=[];
                    DocumentSnapshot docu = await FirebaseFirestore.instance.collection("user")
                        .doc(myId).collection("advance").doc(myId).get();
                    if(docu.exists){
                      try{
                        temp = docu.get("hideNewsfeed");
                      }catch(e){
                        temp=[];
                      }
                    }
                    temp.add(widget.idNewsfeed);
                    Map<String , dynamic> data1 = {
                      "hideNewsfeed":temp
                    };
                    await FirebaseFirestore.instance.collection("user")
                        .doc(myId).collection("advance").doc(myId).set(data1);
                    Provider.of<ItemProvider>(context, listen: false).hideItem(widget.idNewsfeed);
                    // xử lý báo cáo ở đây
                   Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, child: Text("Ok" , style: TextStyle(
                      fontSize: 18
                  ),)),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text("Cancel" ,style: TextStyle(
                      fontSize: 18
                  ),)),
                ],
              );
            });

          }, child: Text("Gửi báo cáo" , style: TextStyle(fontSize: 18),)),
        )
      ],
    );
  }



}
