import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DetailReportPage extends StatefulWidget {
  final Report report;
  const DetailReportPage({super.key, required this.report});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage> {
  bool _isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _exportPdf() async {
    setState(() => _isLoading = true);

    try {
      final repo = ReportRepository(HttpService());
      final bytes = await repo.exportPdf(widget.report.id);

      if (bytes != null) {
        final Directory? externalDir = await getExternalStorageDirectory();

        if (externalDir == null) {
          _showSnackBar("Gagal mendapatkan akses penyimpanan luar.");
          return;
        }

        final fileName = "Bukti_Lapor_${widget.report.id}.pdf";
        final filePath = "${externalDir.path}/$fileName";

        final file = File(filePath);
        await file.writeAsBytes(bytes);

        if (!mounted) return;
        _showSnackBar("PDF berhasil di download di: $fileName");
      }
    } catch (e) {
      _showSnackBar("Gagal mendownload PDF: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.report;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: _exportPdf,
                ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "http://10.112.163.140:2000/storage/${r.imagePath}",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              r.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: JalanKitaTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: JalanKitaTheme.primaryColor),
              ),
              child: Text(
                r.status.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const Divider(height: 40),

            const Text(
              "Deskripsi Kerusakan:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              r.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),

            const SizedBox(height: 24),
            const Text(
              "Lokasi GPS:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: Text("${r.latitude ?? "-"}, ${r.longitude ?? "-"}"),
              subtitle: const Text("Koordinat otomatis terdeteksi"),
            ),
          ],
        ),
      ),
    );
  }
}
