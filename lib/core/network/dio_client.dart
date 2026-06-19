import 'dart:io';

import 'package:caloriespro/core/network/config.dart';
import 'package:caloriespro/core/network/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio dio;

  final Storage _storage = Storage();
  String? _inMemoryAuthToken;

  DioClient._internal() {
    debugPrint(
      '🌐 Initializing DioClient with baseUrl: ${NetworkConfig.baseUrl}',
    );

    dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,

        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    // Add auth interceptor to attach token dynamically
    dio.interceptors.add(AuthTokenInterceptor(tokenProvider: _getAuthToken));

    // Add error interceptor for better error handling
    dio.interceptors.add(DioErrorInterceptor());

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('🔷 $obj'),
      ),
    );
  }

  Future<String?> _getAuthToken() async {
    final token = _inMemoryAuthToken;
    if (token != null && token.isNotEmpty) return token;
    return _storage.read(Storage.authTokenKey);
  }

  /// Call after login to set the token once for this app session.
  /// Also updates Dio default headers immediately.
  void setAuthToken(String? token) {
    _inMemoryAuthToken = token;
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Call after logout to stop sending token.
  void clearAuthToken() => setAuthToken(null);
}

class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({required this.tokenProvider});

  final Future<String?> Function() tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If caller already provided Authorization, don't overwrite it.
    if (!options.headers.containsKey('Authorization')) {
      final token = await tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

/// Custom interceptor to handle DioExceptions
class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = _getErrorMessage(err);
    debugPrint('❌ DioError: $message');
    super.onError(err, handler);
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Check if the server is running.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Server is too slow.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Server did not respond.';
      case DioExceptionType.badResponse:
        return 'Bad response: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'Network error. Check your internet connection.';
        }
        return 'Unknown error: ${error.message}';
      default:
        return error.message ?? 'Network error';
    }
  }
}
