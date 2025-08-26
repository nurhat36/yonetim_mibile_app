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

  // GET isteği (token varsa header’a eklenir)
  Future<Response> get(String path, {String? token}) async {
    final options = Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return await _dio.get(path, options: options);
  }
  // POST isteği (token + body)
  Future<Response> post(String path, {dynamic data, String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return await _dio.post(path, data: data);
  }

  static Dio get dio => _dio;
}
