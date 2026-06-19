import 'package:caloriespro/core/network/dio_client.dart';
import 'package:caloriespro/core/network/storage.dart';
import 'package:caloriespro/features/auth/data/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String username, String email, String password);
  Future<void> signOut();
  Future<UserModel?> checkAuthStatus();
  Future<UserModel> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Storage storage;
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.storage, this.dioClient);
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      debugPrint('🔐 Logging in with email: $email');
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        try {
          final user = UserModel.fromJson(response.data);
          if (user.token.isEmpty || user.email.isEmpty) {
            throw Exception('Invalid user data from server');
          }
          await storage.write(Storage.authTokenKey, user.token);
          dioClient.setAuthToken(user.token);
          debugPrint('✅ Login successful for ${user.email}');
          return user;
        } catch (parseError) {
          debugPrint('❌ JSON Parse error: $parseError');
          debugPrint('Response data: ${response.data}');
          throw Exception('Failed to parse login response: $parseError');
        }
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final message = _getErrorMessage(e);
      debugPrint('❌ DioException: $message');
      throw Exception(message);
    } catch (e) {
      debugPrint('❌ Login error: $e');
      throw Exception('Login error: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      debugPrint('📝 Registering with email: $email');
      final response = await dioClient.dio.post(
        '/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final user = UserModel.fromJson(response.data);
          // For registration, token might not be provided by backend
          // Only validate email is present
          if (user.email.isEmpty) {
            throw Exception('Invalid user data from server');
          }
          // Only save token if it exists
          if (user.token.isNotEmpty) {
            await storage.write(Storage.authTokenKey, user.token);
            dioClient.setAuthToken(user.token);
          }
          debugPrint('✅ Registration successful for ${user.email}');
          return user;
        } catch (parseError) {
          debugPrint('❌ JSON Parse error: $parseError');
          debugPrint('Response data: ${response.data}');
          throw Exception('Failed to parse registration response: $parseError');
        }
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final message = _getErrorMessage(e);
      debugPrint('❌ DioException: $message');
      throw Exception(message);
    } catch (e) {
      debugPrint('❌ Register error: $e');
      throw Exception('Register error: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Clear the stored token
      await storage.delete(Storage.authTokenKey);
      dioClient.clearAuthToken();
      // Optional: Call backend logout endpoint if needed
      // await dioClient.dio.post('/logout');
    } catch (e) {
      throw Exception('Sign out error: $e');
    }
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    try {
      debugPrint('🔍 Checking authentication status...');
      final token = await storage.read(Storage.authTokenKey);
      if (token != null && token.isNotEmpty) {
        debugPrint('✅ Token found, user is logged in');
        dioClient.setAuthToken(token);
        // Return a user model with the token
        // In a real app, you might fetch user data from the token
        return UserModel(id: '', username: '', email: '', token: token);
      } else {
        debugPrint('❌ No token found, user not logged in');
        dioClient.clearAuthToken();
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error checking auth status: $e');
      return null;
    }
  }

  /// Helper method to convert DioException to user-friendly messages
  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Is the backend server running?';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Server is too slow to respond.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Server did not respond in time.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode} - ${error.response?.statusMessage ?? "Unknown"}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        return 'Network error: ${error.message ?? "Check your internet connection"}';
      default:
        return error.message ?? 'Network error occurred';
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      debugPrint('🔍 Fetching user profile...');
      final response = await dioClient.dio.get('/auth/profile');
      if (response.statusCode == 200) {
        try {
          final user = UserModel.fromJson(response.data);
          debugPrint('✅ User profile fetched for ${user.email}');
          return user;
        } catch (parseError) {
          debugPrint('❌ JSON Parse error: $parseError');
          debugPrint('Response data: ${response.data}');
          throw Exception('Failed to parse user profile response: $parseError');
        }
      } else {
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final message = _getErrorMessage(e);
      debugPrint('❌ DioException: $message');
      throw Exception(message);
    } catch (e) {
      debugPrint('❌ Get user profile error: $e');
      throw Exception('Get user profile error: ${e.toString()}');
    }
  }
}
