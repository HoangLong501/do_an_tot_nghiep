import 'package:do_an_tot_nghiep/fan_page/name_fanpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CreateNewPage extends StatefulWidget {
  const CreateNewPage({super.key});
  @override
  State<CreateNewPage> createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
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
            }, icon: Icon(Icons.close , size: 30,)),
            Text("Tạo" , style: TextStyle(fontSize: 18),),
            TextButton(onPressed: (){}, child: Text("Hủy" , style: TextStyle(color: Colors.blue,
                fontSize: 18
            ),))
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1)
            ),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(CupertinoIcons.profile_circled ,size: 30,),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trang cá nhân" , style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w600),),
                      Text(" Tạo thêm trang cá nhân", style: TextStyle(color: Colors.grey,fontSize: 16 ,fontWeight: FontWeight.w500),),
                      Text("•  Có tên và bảng feed mới", style: TextStyle(color: Colors.grey,fontSize: 16 ,fontWeight: FontWeight.w500),),
                      Text("•  Chọn người bạn muốn kết nối", style: TextStyle(color: Colors.grey,fontSize: 16 ,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NameFanPage()));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1)
              ),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.profile_circled ,size: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Trang công khai" , style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w600),),
                        Text("Phát triển ở vai trò đoanh nghiệp, người sáng tạo nội dung hoặc tổ chức", style: TextStyle(color: Colors.grey,fontSize: 16 ,fontWeight: FontWeight.w500),),
                        Text("•  Nhận các công cụ chuyên nghiệp nâng cao", style: TextStyle(color: Colors.grey,fontSize: 16 ,fontWeight: FontWeight.w500),),
                        Text("•  Chỉ định quyền truy cập cho người khác", style: TextStyle(color: Colors.grey,fontSize: 16 ,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
