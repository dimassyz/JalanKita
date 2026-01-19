import 'package:frontend/data/model/report.dart';
import 'dart:convert';

class GetAllReportResponse {
  final String status;
  final List<Report> data;

  GetAllReportResponse({required this.status, required this.data});

  GetAllReportResponse copyWith({String? status, List<Report>? data}) =>
      GetAllReportResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory GetAllReportResponse.fromJson(String str) =>
      GetAllReportResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllReportResponse.fromMap(Map<String, dynamic> json) =>
      GetAllReportResponse(
        status: json["status"],
        data: List<Report>.from(json["data"].map((x) => Report.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
