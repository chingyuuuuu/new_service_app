import 'package:flutter/material.dart';
import 'package:jkmapp/constants.dart';
import 'menu.dart';
import 'package:go_router/go_router.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';

class dining extends StatefulWidget {
  @override
  _DiningState createState() => _DiningState();
}


class _DiningState extends State<dining> {//和statefulwidget適配對，實際管理widget的狀態
  String? storeName;
  String? password;
  String? userId;
  @override
  void initState(){//初始化
     super.initState();
     _loadData();
  }

  Future<void> _loadData() async {
    String? storedName = await StorageHelper.getStoreName();
    String? savedPassword = await StorageHelper.getPassword();
    String? userId= await StorageHelper.getUserId();
    setState(() {
      storeName = storedName;
      password = savedPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(//側邊欄位
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,//確保內容緊貼邊框
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 50),
                  SizedBox(width: 10),
                  Text( storeName ?? '店家', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('訂單'),
              onTap: () {
                Provider.of<OrderProvider>(context,listen: false).getallorders(userId, context);
                context.push('/Userorderlist');
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('菜單'),
              onTap: () {
                 context.pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定'),
              onTap: () {
                context.push('/SettingsPage');
              },
             ),
            ListTile(
              leading:Icon(Icons.storage),
              title:Text('問答資料庫'),
              onTap:(){
                 context.push('/restaurant_database');
              },
            ),
            ListTile(
              leading:Icon(Icons.people_alt_outlined),
              title:Text('客人模式'),
              onTap:(){
                context.push('/Client/A1');
              },
            ),
            ListTile(
               leading: Icon(Icons.table_bar),
               title:Text('生成桌號'),
               onTap:(){
                  context.push('/TableManagement');
               },
            ),
            ListTile(
              leading: Icon(Icons.price_check_sharp),
              title:Text('結帳'),
              onTap:(){
                context.push('/Checkpage');
              },
            ),
            const SizedBox(height:30),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('登出'),
              onTap: () {
                isloggedIn=false;
                context.go('/Login');
              },
            ),
          ],
        ),
      ),
       body:MenuPage(),
    );
  }
}