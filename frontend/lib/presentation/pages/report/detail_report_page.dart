import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class DetailReportPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailReportPage({super.key, required this.data});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai': return JalanKitaTheme.statusDone;
      case 'Diproses': return JalanKitaTheme.statusProcess;
      case 'Ditolak': return JalanKitaTheme.statusRejected;
      default: return JalanKitaTheme.statusPending;
    }
  }

  // Logic Dummy Export PDF (Logic asli nanti dipegang Student B)
  void _exportToPDF(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mengunduh Laporan dalam bentuk PDF..."),
        backgroundColor: JalanKitaTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
        actions: [
          // Shortcut Share Button (Opsional)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Gambar Bukti Kerusakan (Besar)
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              child: const Icon(Icons.image, size: 100, color: Colors.white54),
              // Nanti di sini pakai: Image.network(data['imageUrl'])
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Status Badge & Tanggal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(data['status']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getStatusColor(data['status'])),
                        ),
                        child: Text(
                          data['status'],
                          style: TextStyle(
                            color: _getStatusColor(data['status']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        data['date'],
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  // 3. Judul Laporan
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 4. Lokasi
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: JalanKitaTheme.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data['location'],
                          style: TextStyle(color: Colors.grey[300], fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 40, color: Colors.grey),

                  // 5. Deskripsi
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['description'] ?? "Tidak ada deskripsi.",
                    style: TextStyle(color: Colors.grey[400], height: 1.5),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 40),

                  // 6. Tombol Export PDF
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _exportToPDF(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: JalanKitaTheme.inputColor,
                        foregroundColor: JalanKitaTheme.primaryColor,
                        side: const BorderSide(color: JalanKitaTheme.primaryColor),
                      ),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("EXPORT LAPORAN (PDF)"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}