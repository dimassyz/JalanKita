import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      // Jika user berhasil ambil foto
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil gambar: $e")));
    }
  }

  // menghapus foto jika user ingin ulang
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Laporan Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview Foto
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: JalanKitaTheme.inputColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : InkWell(
                          onTap: _getImageFromCamera,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt_rounded,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Ketuk untuk ambil foto jalan",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                ),

                // Tombol Hapus/Retake Foto
                if (_imageFile != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _removeImage,
                      ),
                    ),
                  ),
              ],
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
                  const Icon(
                    Icons.location_on,
                    color: JalanKitaTheme.primaryColor,
                  ),
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form Input Text
            const Text(
              "Detail Laporan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Judul
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Contoh: Jalan Berlubang di Depan Pasar',
                labelText: 'Judul Laporan',
                prefixIcon: Icon(Icons.title, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),

            // Deskripsi
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kondisi kerusakan secara singkat...',
                labelText: 'Deskripsi Kerusakan',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 24),

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
