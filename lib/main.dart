import 'package:flutter/material.dart';
import 'package:vehicles_app/screens/login_screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //para quitar la baarita de arriba
      title: 'Vehicles App',
      home: LoginScreen(),
    );
  }
}
