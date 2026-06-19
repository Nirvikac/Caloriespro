import 'package:caloriespro/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.token,
  });

  /// Parse user from backend response with nested structure
  /// Backend returns: { token: "...", user: { _id, username, email, ... } }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user object from backend
    final userData = json['user'] ?? json;

    return UserModel(
      id: userData['_id']?.toString() ?? userData['id']?.toString() ?? '',
      username:
          userData['username']?.toString() ??
          userData['name']?.toString() ??
          '',
      email: userData['email']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
    );
  }
}
