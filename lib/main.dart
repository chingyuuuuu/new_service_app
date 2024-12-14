import 'package:flutter/material.dart';
import 'package:jkmapp/constants.dart';
import 'package:jkmapp/providers/client/Notification_Provider.dart';
import 'package:jkmapp/providers/QA/QA_provider.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/services/api_service.dart';
import 'package:jkmapp/providers/restaurant/remark_provider.dart';
import 'package:jkmapp/providers/QA/Speech_provider.dart';
import 'package:jkmapp/providers/client/client_provider.dart';
import 'package:jkmapp/providers/restaurant/product_provider.dart';
import 'package:jkmapp/providers/user/Forget_provider.dart';
import 'providers/client/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:jkmapp/services/user/websocket_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());//開啟path routing-

  final webSocketService=WebSocketService();
  webSocketService.connect(baseUrl);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()//提供購物車的狀態
        ),
        ChangeNotifierProvider(create: (_)=>NotificationProvider()
        ),
        ChangeNotifierProvider(create: (_)=>OrderProvider()
        ),
        ChangeNotifierProvider(create: (_)=>QAprovider()
        ),
        ChangeNotifierProvider(create: (_)=>RemarkProvider()
        ),
        ChangeNotifierProvider(create: (_)=>SpeechProvider()
        ),
        ChangeNotifierProvider(create: (_)=>ClientProvider()
        ),
        ChangeNotifierProvider(create: (_)=>ProductProvider()
        ),
        ChangeNotifierProvider(create: (_)=>ForgetProvider()
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color:Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Routers.first,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class DataWidget extends StatefulWidget {
  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  Future<Map<String, dynamic>>? _data;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _data= _apiService.fetchData();//調用api獲取數據
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(//用於存取從flask 獲取的數據
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('Message: ${snapshot.data!['message']}');
        }
      },
    );
  }
}


