import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'login_screen.dart'; // Giriş ekranını içe aktarıyoruz
import 'home_screen.dart'; // Yeni ana ekranı içe aktarıyoruz

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Eğer Future kullanıyorsanız bu satır gerekli olabilir
  await initializeDateFormatting('tr_TR', null).then((_) => runApp(MyApp()));
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