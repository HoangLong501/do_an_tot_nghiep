import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'itemProvider.dart';
class ReportUser extends StatefulWidget {
  final String idUser;
  const ReportUser({super.key , required this.idUser});

  @override
  State<ReportUser> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportUser> {
  int _currentStep = 0;
  int _lastStep = 0;
  String reason="";
  String selectReason1="Giả mạo người khác";
  String selectReason2="Tài khoản giả mạo";
  String selectReason3="Tôi muốn giúp đỡ";
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
                "Hãy chọn vấn đề")),
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
      detailText = "Tôi";
      detailText2 = "Người nổi tiếng";
      detailText3 = "Một doanh nghiệp";
    } else if (_currentStep == 2) {
      detailText = "Nhằm mục đích lừa đảo ";
      detailText2 = "Nhằm mục đích đăng tin sai sự thật";
      detailText3 = "Vấn đề khác";
    } else {
      detailText = "Tự gây thương tích";
      detailText2 = "Quấy rối";
      detailText3 = "Bị hack";
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
          child: Text("Chúng tôi sẽ xem xét và phản hồi khi đã có kết quả"),
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

                    await FirebaseFirestore.instance.collection("report").doc("OBZUdRWJbFpeofVH1eal").collection("user")
                        .doc().set({
                      "idUser":widget.idUser,
                      "content":content,
                      "reporter":myId
                    });

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
