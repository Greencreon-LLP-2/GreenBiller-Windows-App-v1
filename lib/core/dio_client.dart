import 'package:dio/dio.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:logger/logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;
  final logger = Logger();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl, // Adjust base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        logger.e('Error: ${e.response?.statusCode} ${e.message}');
        return handler.next(e);
      },
    ));
  }

  // Add token to headers for authenticated requests
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}