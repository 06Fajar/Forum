import 'package:flutter/material.dart';
import 'package:flutter_application_1/buatforum_page.dart';
import 'package:flutter_application_1/forum_page.dart';
import 'package:flutter_application_1/login.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('LocalStorage');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,),
      home: LoginPage()
    );
  }
}