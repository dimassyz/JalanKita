import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Dummy Data untuk Simulasi
  final List<Map<String, dynamic>> dummyReports = const [
    {
      "title": "Jalan Berlubang Parah",
      "date": "10 Januari 2026",
      "status": "Selesai",
    },
    {
      "title": "Aspal Retak Depan SD",
      "date": "11 Januari 2026",
      "status": "Diproses",
    },
    {
      "title": "Lampu Jalan Mati Total",
      "date": "12 Januari 2026",
      "status": "Pending",
    },
    {"title": "Laporan Iseng", "date": "13 Januari 2026", "status": "Ditolak"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Laporan")),
      body: dummyReports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history_toggle_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada laporan",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyReports.length,
              itemBuilder: (context, index) {
                final report = dummyReports[index];
                return ReportCard(data: report);
              },
            ),
    );
  }
}

// Widget Kartu Laporan Custom
class ReportCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ReportCard({super.key, required this.data});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return JalanKitaTheme.statusDone;
      case 'Diproses':
        return JalanKitaTheme.statusProcess;
      case 'Ditolak':
        return JalanKitaTheme.statusRejected;
      default:
        return JalanKitaTheme.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: JalanKitaTheme.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.white54),
            ),
            const SizedBox(width: 16),

            // Info Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(data['status']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getStatusColor(data['status']),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      data['status'],
                      style: TextStyle(
                        color: _getStatusColor(data['status']),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Tanggal
                  Text(
                    "${data['date']}",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
