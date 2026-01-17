import 'package:frontend/data/usecase/response/my_report_response.dart';
import 'package:frontend/data/service/http_service.dart';

class ReportRepository {
  final HttpService httpService;
  ReportRepository(this.httpService);

  Future<MyReportResponse> getMyReport() async {
    final response = await httpService.get('my-reports');
    return MyReportResponse.fromJson(response.body);
  }
}
