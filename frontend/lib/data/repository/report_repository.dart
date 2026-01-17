import 'dart:convert';
import 'dart:developer';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/request/create_report_request.dart';
import 'package:frontend/data/usecase/response/report_response.dart';

class ReportRepository {
  final HttpService httpService;

  ReportRepository(this.httpService);

  Future<ReportResponse> createReport(CreateReportRequest request) async {
    try {
      final response = await httpService.postWithFile(
        'reports',
        request.toMap(),
        request.image,
        'image', // field name untuk file
      );

      // Log untuk debug
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      // Cek apakah response adalah JSON
      if (!response.body.trim().startsWith('{') &&
          !response.body.trim().startsWith('[')) {
        log('Response bukan JSON, kemungkinan HTML error page');
        return ReportResponse(
          status: 'error',
          message:
              'Server error (${response.statusCode}). Response bukan JSON. Cek backend Anda.',
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = ReportResponse.fromJson(response.body);
        return responseData;
      } else {
        // Coba parse error response
        try {
          final errorResponse = ReportResponse.fromJson(response.body);
          return errorResponse;
        } catch (e) {
          return ReportResponse(
            status: 'error',
            message: 'Server error (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      log('Exception in createReport: $e');
      return ReportResponse(
        status: 'error',
        message: 'Gagal terhubung ke server: $e',
      );
    }
  }

  Future<List<Report>> getUserReports() async {
    try {
      final response = await httpService.get('my-reports');

      log('Get User Reports Status Code: ${response.statusCode}');
      log('Get User Reports Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Backend biasanya mengembalikan { "data": [...] } atau { "reports": [...] }
        List<dynamic> reportsJson = [];

        if (jsonData['data'] != null) {
          reportsJson = jsonData['data'];
        } else if (jsonData['reports'] != null) {
          reportsJson = jsonData['reports'];
        } else if (jsonData is List) {
          // Jika langsung return array
          reportsJson = jsonData as List<dynamic>;
        }

        return reportsJson.map((json) => Report.fromMap(json)).toList();
      } else {
        log('Get User Reports Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Exception in getUserReports: $e');
      return [];
    }
  }

  Future<List<Report>> getAllReports() async {
    try {
      final response = await httpService.get('admin/reports');

      log('Get All Reports Status Code: ${response.statusCode}');
      log('Get All Reports Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        List<dynamic> reportsJson = [];

        if (jsonData['data'] != null) {
          reportsJson = jsonData['data'];
        } else if (jsonData['reports'] != null) {
          reportsJson = jsonData['reports'];
        } else if (jsonData is List) {
          reportsJson = jsonData as List<dynamic>;
        }

        return reportsJson.map((json) => Report.fromMap(json)).toList();
      } else {
        log('Get All Reports Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Exception in getAllReports: $e');
      return [];
    }
  }
}
