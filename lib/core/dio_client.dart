import 'package:dio/dio.dart';


class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5268/api/', // Android emulator icin
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: { 'Content-Type': 'application/json' },
    ),
  );
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }


  static Dio get dio => _dio;
}