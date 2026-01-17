import 'dart:convert';
import 'package:frontend/data/model/user.dart';

class UserResponse {
  final String? status;
  final String? message;
  final User? data;

  UserResponse({this.status, this.message, this.data});

  UserResponse copyWith({String? status, String? message, User? data}) =>
      UserResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UserResponse.fromJson(String str) =>
      UserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserResponse.fromMap(Map<String, dynamic> json) => UserResponse(
    status: json["status"],
    message: json["message"],
    data: User.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}
