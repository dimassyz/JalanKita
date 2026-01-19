import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/presentation/widgets/report_card.dart';
import 'package:frontend/data/usecase/response/my_report_response.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Report>> _reportFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    final repo = ReportRepository(HttpService());
    setState(() {
      _reportFuture = repo.getMyReport().then(
        (response) => response.data ?? [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Laporan")),
      body: FutureBuilder<List<Report>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          // kondisi loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // kondisi error
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // kondisi data kosong
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada laporan",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          // kondisi data ada
          return RefreshIndicator(
            onRefresh: () async => _loadReports(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return ReportCard(report: reports[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
