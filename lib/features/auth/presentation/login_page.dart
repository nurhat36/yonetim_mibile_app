import 'package:flutter/material.dart';
import 'package:yonetim_mibile_app/features/auth/data/auth_repository.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _repo = AuthRepository();


  void _login() async {
    try {
      await _repo.login(_username.text, _password.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı!')),
      );
      // Direk binalar sayfasına yönlendir
      Navigator.pushReplacementNamed(context, '/Buildings/user-buildings');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _username, decoration: const InputDecoration(labelText: 'Kullanıcı Adı')),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Şifre')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Giriş Yap')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Hesabın yok mu? Kaydol'),
            ),
          ],
        ),
      ),
    );
  }
}