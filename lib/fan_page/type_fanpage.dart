import 'package:do_an_tot_nghiep/fan_page/profile_fanpage.dart';
import 'package:do_an_tot_nghiep/service/database.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';



class TypeFanPage extends StatefulWidget {
  final String nameFanPage;
  const TypeFanPage({super.key , required this.nameFanPage});

  @override
  State<TypeFanPage> createState() => _TypeFanPageState();
}

class _TypeFanPageState extends State<TypeFanPage> {
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? myId;
  final List<String> items = [
    'Nhạc sỹ/Ban nhạc',
    'Sức khỏe/Sắc đẹp',
    'Cửa hàng tạp khóa',
    'Trang web giải trí',
    'Vận động viên',
    'Dịch vụ tài chính',
    'Tác giả',
    'Người sáng tạo nội dung ',
    'Cửa hàng quần áo',
    'Nhà báo',
    'Tổ chức chính phủ',
    'Tổ chức phi lợi nhuận',
  ];

  onLoad()async{
    myId=await SharedPreferenceHelper().getIdUser();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height/1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hạng mục nào mô tả chính xác nhất về Trang của bạn",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                    Text("Nhờ hạng mục, mọi người sẽ tìm thấy Trang này trong kết quả tìm kiếm. Bạn có thể "
                        "thêm đến 3 hạng mục",style: TextStyle(fontSize: 16),),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child:  TypeAheadField(
                        controller: typeController,
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: 'Tìm kiếm hạng mục',
                              ),
                            );
                          },

                          itemBuilder: (context , suggestion){
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSelected: (onSelected){
                            setState(() {
                              typeController.text=onSelected;
                            });
                          },
                          suggestionsCallback: (pattern){
                            return items.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
                          })
                    ),
                    SizedBox(height: 20,),
                    Text("Hạng mục phổ biến"),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: (){}, child: Text("Nhạc sỹ/Ban nhạc")),
                        ElevatedButton(onPressed: (){}, child: Text("Sức khỏe/Sắc đẹp")),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: (){}, child: Text("Cửa hàng tạp hóa")),
                        ElevatedButton(onPressed: (){}, child: Text("Trang web giải trí")),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text("Hãy thêm mô tả cho Trang của bạn",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                    SizedBox(height: 20,),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Hãy thêm mô tả (không bắt buộc)',
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/1,
                decoration: BoxDecoration(
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: typeController.text!=""? WidgetStateColor.resolveWith((states) => Colors.blue,):
                      WidgetStateColor.resolveWith((states) => Colors.grey.withOpacity(0.6),)
                  ),
                  onPressed: (){
                    if(typeController.text!=""){
                      Map<String ,dynamic> fanPageInfoMap={
                        "ID":myId,
                        "nameFanpage":widget.nameFanPage,
                        "type":typeController.text,
                        "description":descriptionController.text
                      };
                      DatabaseMethods().addFanPage(myId!, fanPageInfoMap);
                      print(fanPageInfoMap);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileFanPage()));
                    }
                  },
                  child: Text("Tiếp" ,style: TextStyle(color: typeController.text!=""?  Colors.black:Colors.grey.shade300 ),),
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
