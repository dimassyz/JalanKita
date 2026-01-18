import 'dart:convert';

class ReportResponse {
  final String? status;
  final String? message;
  final dynamic data;

  ReportResponse({this.status, this.message, this.data});

  factory ReportResponse.fromJson(String str) =>
      ReportResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReportResponse.fromMap(Map<String, dynamic> json) => ReportResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
