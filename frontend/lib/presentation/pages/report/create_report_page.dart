import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/request/create_report_request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Position? _currentPosition; // Menyimpan koordinat (Latitude, Longitude)
  bool _isGettingLocation = false; // Indikator Loading GPS
  String _addressMessage = "Belum ada lokasi"; // Pesan status lokasi
  bool _isLoading = false;

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

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? JalanKitaTheme.statusRejected : Colors.green,
      ),
    );
  }

  void _resetForm() {
    _titleController.clear();
    _descController.clear();
    setState(() {
      _imageFile = null;
      _currentPosition = null;
      _addressMessage = "Belum ada lokasi";
    });
  }

  void _handleSubmit() async {
    if (_imageFile == null) {
      _showSnackBar("Ambil foto kerusakan dulu!", isError: true);
      return;
    }

    if (_currentPosition == null) {
      _showSnackBar(
        "Lokasi belum terdeteksi. Harap nyalakan GPS!",
        isError: true,
      );
      return;
    }

    if (_titleController.text.isEmpty) {
      _showSnackBar("Judul laporan tidak boleh kosong!", isError: true);
      return;
    }

    if (_descController.text.isEmpty) {
      _showSnackBar("Deskripsi laporan tidak boleh kosong!", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = CreateReportRequest(
        title: _titleController.text,
        description: _descController.text,
        latitude: _currentPosition!.latitude.toString(),
        longitude: _currentPosition!.longitude.toString(),
      );

      final repo = ReportRepository(HttpService());
      final response = await repo.createReport(request, _imageFile!);

      if (!mounted) return;

      if (response.status == "success") {
        _showSnackBar("Laporan berhasil dibuat!");
        _resetForm();
      } else {
        _showSnackBar(
          response.message ?? "Gagal mengirim laporan",
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true; // Mulai loading
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Mengecek apakah GPS HP menyala
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi (GPS) nonaktif. Harap mengaktifkan GPS.';
      }

      // Mengecek izin aplikasi
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen. Buka pengaturan HP.';
      }

      // Mengambil Lokasi Saat Ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _addressMessage = "Lokasi Berhasil Didapat";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      setState(() {
        _addressMessage = "Gagal mengambil lokasi";
      });
    } finally {
      setState(() {
        _isGettingLocation = false; // Stop loading
      });
    }
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
            InkWell(
              onTap: _getCurrentLocation, // klik manual untuk refresh
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: JalanKitaTheme.inputColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _currentPosition != null
                        ? JalanKitaTheme.statusDone
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    // Ikon Spinner jika loading
                    _isGettingLocation
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.location_on,
                            color: _currentPosition != null
                                ? JalanKitaTheme.statusDone
                                : JalanKitaTheme.primaryColor,
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Koordinat Lokasi",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                          // Menampilkan Koordinat Asli atau Placeholder
                          Text(
                            _currentPosition != null
                                ? "${_currentPosition!.latitude}, ${_currentPosition!.longitude}"
                                : _addressMessage,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _currentPosition != null
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _getCurrentLocation,
                      tooltip: "Perbarui Lokasi",
                    ),
                  ],
                ),
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
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Jalan Berlubang di Depan Pasar',
                labelText: 'Judul Laporan',
                prefixIcon: Icon(Icons.title, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),

            // Deskripsi
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kondisi kerusakan...',
                labelText: 'Deskripsi Kerusakan',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Kirim
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _handleSubmit, // Disable saat loading
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(_isLoading ? "MENGIRIM..." : "KIRIM LAPORAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
