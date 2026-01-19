import 'dart:convert';
import 'package:frontend/data/model/report.dart';

class UpdateStatusResponse {
  final String status;
  final String message;
  final Report? data;

  UpdateStatusResponse({
    required this.status,
    required this.message,
    this.data,
  });

  UpdateStatusResponse copyWith({
    String? status,
    String? message,
    Report? data,
  }) => UpdateStatusResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory UpdateStatusResponse.fromJson(String str) =>
      UpdateStatusResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateStatusResponse.fromMap(Map<String, dynamic> json) =>
      UpdateStatusResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Report.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}
