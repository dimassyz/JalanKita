import 'package:frontend/data/usecase/response/my_report_response.dart';
import 'package:frontend/data/service/http_service.dart';
import 'dart:typed_data';

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
}
