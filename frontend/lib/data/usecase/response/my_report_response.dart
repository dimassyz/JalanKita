import 'dart:convert';

import 'package:frontend/data/model/report.dart';

class MyReportResponse {
  final String status;
  final String message;
  final List<Report> data;

  MyReportResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  MyReportResponse copyWith({
    String? status,
    String? message,
    List<Report>? data,
  }) => MyReportResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory MyReportResponse.fromJson(String str) =>
      MyReportResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyReportResponse.fromMap(Map<String, dynamic> json) =>
      MyReportResponse(
        status: json["status"],
        message: json["message"],
        data: List<Report>.from(json["data"].map((x) => Report.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
