import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yonetim_mibile_app/features/auth/data/auth_repository.dart';




class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _repo = AuthRepository();
  File? _image;


  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }


  void _register() async {
    try {
      await _repo.register(_username.text, _email.text, _password.text, _image);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _username, decoration: const InputDecoration(labelText: 'Kullanıcı Adı')),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'E-Posta')),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Şifre')),
            const SizedBox(height: 10),
            _image != null ? Image.file(_image!, height: 100) : const Text('Profil resmi seçilmedi'),
            ElevatedButton(onPressed: _pickImage, child: const Text('Profil Resmi Seç')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Kayıt Ol')),
          ],
        ),
      ),
    );
  }
}