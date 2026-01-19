import 'dart:io';

import 'package:frontend/data/usecase/request/create_report_request.dart';
import 'package:frontend/data/usecase/response/get_all_report_response.dart';
import 'package:frontend/data/usecase/response/my_report_response.dart';
import 'package:frontend/data/service/http_service.dart';
import 'dart:typed_data';
import 'package:frontend/data/usecase/response/create_report_response.dart';
import 'package:frontend/data/usecase/response/update_status_response.dart';

class ReportRepository {
  final HttpService httpService;
  ReportRepository(this.httpService);

  Future<MyReportResponse> getMyReport() async {
    final response = await httpService.get('my-reports');
    return MyReportResponse.fromJson(response.body);
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

  Future<CreateReportResponse> createReport(
    CreateReportRequest request,
    File imageFile,
  ) async {
    final response = await httpService.postWithFile(
      'reports',
      request.toMap(),
      imageFile,
      'image',
    );

    return CreateReportResponse.fromJson(response.body);
  }

  Future<GetAllReportResponse> getAllReport() async {
    final response = await httpService.get('admin/reports');

    if (response.statusCode == 200) {
      return GetAllReportResponse.fromJson(response.body);
    } else {
      throw Exception("Gagal memuat laporan admin: ${response.statusCode}");
    }
  }

  Future<UpdateStatusResponse> updateReportStatus(
    int reportId,
    String newStatus,
  ) async {
    final response = await httpService.patch('admin/reports/$reportId/status', {
      'status': newStatus.toLowerCase(),
    });

    if (response.statusCode == 200) {
      return UpdateStatusResponse.fromJson(response.body);
    } else {
      throw Exception("Gagal mengubah status: ${response.body}");
    }
  }
}
