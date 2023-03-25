import 'package:flutter/material.dart';
import 'package:mobile/widgets/maintab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FO-ATALIAN',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MainTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}
