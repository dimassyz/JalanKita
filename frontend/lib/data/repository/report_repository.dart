import 'dart:io';

import 'package:frontend/data/usecase/request/create_report_request.dart';
import 'package:frontend/data/usecase/response/report_response.dart';
import 'package:frontend/data/service/http_service.dart';
import 'dart:typed_data';

class ReportRepository {
  final HttpService httpService;
  ReportRepository(this.httpService);

  Future<ReportResponse> getMyReport() async {
    final response = await httpService.get('my-reports');
    return ReportResponse.fromJson(response.body);
  }

  Future<Uint8List?> exportPdf(int reportId) async {
    try {
      final response = await httpService.get('reports/$reportId/export');

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      print("Error Export PDF: $e");
      return null;
    }
  }

  Future<ReportResponse> createReport(
    CreateReportRequest request,
    File imageFile,
  ) async {
    final response = await httpService.postWithFile(
      'reports',
      request.toMap(),
      imageFile,
      'image',
    );

    return ReportResponse.fromJson(response.body);
  }
}
