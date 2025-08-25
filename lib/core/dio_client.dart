import 'package:dio/dio.dart';


class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5268/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Token eklemek için
  Future<Response> get(String path, {String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return await _dio.get(path);
  }

  static Dio get dio => _dio;
}
