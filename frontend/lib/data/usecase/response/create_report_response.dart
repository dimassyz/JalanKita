import 'dart:convert';
import 'package:frontend/data/model/report.dart';

class CreateReportResponse {
  final String status;
  final String message;
  final Report data;

  CreateReportResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  CreateReportResponse copyWith({
    String? status,
    String? message,
    Report? data,
  }) => CreateReportResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory CreateReportResponse.fromJson(String str) =>
      CreateReportResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateReportResponse.fromMap(Map<String, dynamic> json) =>
      CreateReportResponse(
        status: json["status"],
        message: json["message"],
        data: Report.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data.toMap(),
  };
}
