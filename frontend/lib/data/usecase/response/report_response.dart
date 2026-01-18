import 'dart:convert';

import 'package:frontend/data/model/report.dart';

class ReportResponse {
  final String status;
  final String message;
  final List<Report> data;

  ReportResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  ReportResponse copyWith({
    String? status,
    String? message,
    List<Report>? data,
  }) => ReportResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory ReportResponse.fromJson(String str) =>
      ReportResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReportResponse.fromMap(Map<String, dynamic> json) => ReportResponse(
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
