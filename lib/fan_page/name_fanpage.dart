import 'package:do_an_tot_nghiep/fan_page/type_fanpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class NameFanPage extends StatefulWidget {
  const NameFanPage({super.key});
  @override
  State<NameFanPage> createState() => _NameFanPageState();
}

class _NameFanPageState extends State<NameFanPage> {
  TextEditingController nameFanPage=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back_outlined , size: 30,)),
            TextButton(onPressed: (){}, child: Text("Hủy" , style: TextStyle(color: Colors.blue,
            fontSize: 18
            ),))
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tên Trang của bạn là gì?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                Text("Hãy dùng tên doanh nghiệp/thương hiệu/tổ chức của bạn hoặc tên "
                    "góp phần giải thích về Trang",style: TextStyle(fontSize: 16),),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: nameFanPage,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Tên Trang"
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width/1,
              decoration: BoxDecoration(
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: nameFanPage.text!=""? WidgetStateColor.resolveWith((states) => Colors.blue,):
                  WidgetStateColor.resolveWith((states) => Colors.grey.withOpacity(0.6),)
                ),
                onPressed: (){
                  if(nameFanPage.text!=""){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TypeFanPage(nameFanPage: nameFanPage.text,)));
                  }
                },
                child: Text("Tiếp" ,style: TextStyle(color: nameFanPage.text!=""?  Colors.black:Colors.grey.shade300 ),),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
