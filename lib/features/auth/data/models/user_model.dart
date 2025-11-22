/// User Model
///
/// Data model representing a user in the application.
/// Supports creation from Firebase User.

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  /// Create UserModel from Firebase User
  /// Used after successful Firebase authentication
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'Unknown User',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'photoUrl': photoUrl};
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String,
    );
  }

  /// Override toString for debugging
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photoUrl: $photoUrl)';
  }

  /// Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ photoUrl.hashCode;
  }
}
