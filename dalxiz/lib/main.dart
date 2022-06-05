import 'package:dalxiz/screens/constant.dart';
import 'package:flutter/material.dart';

import 'screens/create_acount.dart';
import 'screens/login_screen.dart';
import 'screens/open_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: OpeningView());
  }
}
