import 'package:flutter/material.dart';
import 'login_screen.dart'; // Giriş ekranını içe aktarıyoruz
import 'home_screen.dart'; // Yeni ana ekranı içe aktarıyoruz

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenci Çalışma Planı',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LoginScreen(), // Uygulama başladığında giriş ekranını göster
    );
  }
}


 