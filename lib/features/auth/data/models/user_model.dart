import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yonetim_mibile_app/core/dio_client.dart';
import 'package:yonetim_mibile_app/core/secure_storage.dart';


class AuthRepository {
  final Dio _dio = DioClient.dio;


  Future<String> login(String username, String password) async {
    final response = await _dio.post('auth/login', data: {
      'username': username,
      'password': password,
    });


    final token = response.data['token'];
    await SecureStorage.saveToken(token);
    return token;
  }


  Future<void> register(String username, String email, String password, File? image) async {
    final formData = FormData.fromMap({
      'UserName': username,
      'Email': email,
      'Password': password,
      if (image != null)
        'ProfileImage': await MultipartFile.fromFile(image.path),
    });


    await _dio.post('auth/register', data: formData);
  }


  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }
}