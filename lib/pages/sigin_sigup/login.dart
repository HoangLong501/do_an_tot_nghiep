
import 'package:do_an_tot_nghiep/pages/home.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/register.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  Color facebookBlue = const Color(0xFF1877F2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  
),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Bắt đầu từ trái
              end: Alignment.centerRight, // Kết thúc ở phải
              colors: [
                Colors.yellow.shade50, // Màu vàng
                Colors.red.shade50, // Màu đỏ
                Colors.lightBlue.shade50, // Màu xám
              ],
              stops: [0.0,0.1,1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
        
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Độ bo góc
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover, // Đảm bảo hình ảnh vừa khớp trong container
                    ),
                  ),
                ),
        
                SizedBox(height: 70),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email hoặc số điện thoại',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
        
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
        
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>Home()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),                  ),
                    child: Text('Đăng nhập',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 20
                     ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Xử lý quên mật khẩu ở đây
                  },
                  child: Text('Bạn quên mật khẩu ư?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                  ),
                  ),
                ),
                SizedBox(height: 70),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý đăng nhập ở đây
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>register()),
                      );
                    },
                    style: ButtonStyle(
        
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.deepPurpleAccent.shade200)), // Màu viền
                      ),
                    child: Text('tạo tài khoản mới',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

