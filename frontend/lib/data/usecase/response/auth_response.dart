import 'dart:convert';
import 'package:frontend/data/model/user.dart';

class AuthResponse {
  final String? status;
  final String? message;
  final String? accessToken;
  final String? tokenType;
  final User? data;

  AuthResponse({
    this.status,
    this.message,
    this.accessToken,
    this.tokenType,
    this.data,
  });

  AuthResponse copyWith({
    String? status,
    String? message,
    String? accessToken,
    String? tokenType,
    User? data,
  }) => AuthResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    accessToken: accessToken ?? this.accessToken,
    tokenType: tokenType ?? this.tokenType,
    data: data ?? this.data,
  );

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
    status: json["status"],
    message: json["message"],
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    data: json["data"] == null ? null : User.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "access_token": accessToken,
    "token_type": tokenType,
    "data": data?.toMap(),
  };
}
