import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Laporan Baru"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview Foto (Image Picker UI)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: JalanKitaTheme.inputColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: InkWell(
                onTap: () {
                  // Membuka Kamera (Logic Task Mobile)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Buka Kamera...")),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_rounded, 
                      size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      "Ketuk untuk mengambil foto jalan",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Lokasi (GPS Preview)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: JalanKitaTheme.inputColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: JalanKitaTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lokasi Terdeteksi",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "-7.250445, 112.768845", // Dummy Coordinates
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      // TODO: Refresh GPS Logic
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form Input Text
            const Text("Detail Laporan", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            
            // Judul
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Contoh: Jalan Berlubang di Depan Pasar',
                labelText: 'Judul Laporan',
                prefixIcon: Icon(Icons.title, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            
            // Deskripsi
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kondisi kerusakan secara singkat...',
                labelText: 'Deskripsi Kerusakan',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Kirim
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Logic Kirim Data ke API
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text("KIRIM LAPORAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}