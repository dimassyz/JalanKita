import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/model/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return JalanKitaTheme.statusDone;
      case 'diproses':
        return JalanKitaTheme.statusProcess;
      case 'ditolak':
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                image: report.imagePath.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                          "http://192.168.1.6:8000/storage/${report.imagePath}",
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: report.imagePath.isEmpty
                  ? const Icon(Icons.image, color: Colors.white54)
                  : null,
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(report.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getStatusColor(report.status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      report.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(report.status),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    report.title,
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
                    "${report.createdAt.day}-${report.createdAt.month}-${report.createdAt.year}",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
