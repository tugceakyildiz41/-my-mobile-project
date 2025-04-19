import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  bool _isLoginForm = true;
  DateTime? _selectedDate;

  void _toggleForm() {
    setState(() {
      _isLoginForm = !_isLoginForm;
      // Form geçişinde alanları temizle
      _emailController.clear();
      _passwordController.clear();
      _nameSurnameController.clear();
      _birthDateController.clear();
      _selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String nameSurname = _nameSurnameController.text.trim();
    String? birthDate = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null;

    if (_isLoginForm) {
      // Giriş işlemleri burada yapılacak (şimdilik sadece log yazdırıyoruz)
      print('Giriş Yapılıyor - E-posta: $email, Şifre: $password');
      // **Giriş başarılıysa ana ekrana yönlendir**
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Kayıt işlemleri burada yapılacak (şimdilik sadece log yazdırıyoruz)
      print('Kayıt Olunuyor - Ad Soyad: $nameSurname, Doğum Tarihi: $birthDate, E-posta: $email, Şifre: $password');
      // **Kayıt başarılıysa ana ekrana yönlendir**
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    // Giriş veya kayıt başarılıysa ana ekrana yönlendirme yapıldı
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100, // Arka plan rengi
      appBar: AppBar(
        title: Text(_isLoginForm ? 'Giriş' : 'Kayıt Ol', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Container( // Daha belirgin bir form alanı için Container
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLoginForm) // Kayıt ekranında gösterilecek alanlar
                    Column(
                      children: [
                        TextFormField(
                          controller: _nameSurnameController,
                          decoration: InputDecoration(
                            labelText: 'Ad Soyad',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen adınızı ve soyadınızı girin';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _birthDateController,
                          readOnly: true, // Manuel giriş engellenir
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: 'Doğum Tarihi (GG/AA/YYYY)',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen doğum tarihinizi seçin';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen e-posta adresinizi girin';
                      }
                      if (!value.contains('@')) {
                        return 'Geçerli bir e-posta adresi girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen şifrenizi girin';
                      }
                      if (value.length < 6) {
                        return 'Şifre en az 6 karakter olmalıdır';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(_isLoginForm ? 'Giriş Yap' : 'Kayıt Ol', style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: _toggleForm,
                    child: Text(
                      _isLoginForm
                          ? 'Hesabınız yok mu? Kayıt Olun'
                          : 'Zaten bir hesabınız var mı? Giriş Yapın',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}