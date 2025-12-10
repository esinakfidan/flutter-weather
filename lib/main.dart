import 'package:flutter/material.dart';
import 'package:pdroapp/screens/home_page.dart';

void main() {
  runApp(const Home());

}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hava Durumu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

