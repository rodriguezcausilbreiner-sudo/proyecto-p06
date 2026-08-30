import 'package:dio/dio.dart';

class ClienteDio {
  static Dio crear({String baseUrl = 'http://10.0.2.2:3000/api'}) {
    return Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 20), // subir foto puede tardar más
    ));
  }
}
