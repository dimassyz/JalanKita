import 'dart:convert';
import 'package:frontend/data/model/user.dart';

class UserResponse {
  final String? status;
  final User? data;

  UserResponse({this.status, this.data});

  factory UserResponse.fromJson(String str) =>
      UserResponse.fromMap(json.decode(str));

  factory UserResponse.fromMap(Map<String, dynamic> json) => UserResponse(
    status: json["status"],
    data: json["data"] == null ? null : User.fromMap(json["data"]),
  );
}
