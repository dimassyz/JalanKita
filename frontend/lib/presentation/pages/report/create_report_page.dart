import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/usecase/request/create_report_request.dart';

class CreateReportPage extends StatefulWidget {
  final VoidCallback? onReportSubmitted;

  const CreateReportPage({super.key, this.onReportSubmitted});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Position? _currentPosition; // Menyimpan koordinat (Latitude, Longitude)
  bool _isGettingLocation = false; // Indikator Loading GPS
  String _addressMessage = "Belum ada lokasi"; // Pesan status lokasi

  // Controllers untuk form
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Loading state
  bool _isSubmitting = false;

  // Repository
  final ReportRepository _reportRepository = ReportRepository(HttpService());

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lokasi berhasil diambil!"),
          backgroundColor: JalanKitaTheme.statusDone,
        ),
      );
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

  Future<void> _handleSubmitReport() async {
    // Validasi: Gambar harus ada
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mohon ambil foto bukti kerusakan!"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      return;
    }

    // Validasi: Lokasi harus ada
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lokasi belum terdeteksi. Harap nyalakan GPS!"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      return;
    }

    // Validasi: Judul harus diisi
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Judul laporan harus diisi!"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      return;
    }

    // Validasi: Deskripsi harus diisi
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Deskripsi kerusakan harus diisi!"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      return;
    }

    // Validasi: Judul minimal 5 karakter
    if (_titleController.text.trim().length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Judul laporan minimal 5 karakter!"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      return;
    }

    // Validasi: Deskripsi minimal 50 karakter
    if (_descriptionController.text.trim().length < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Deskripsi minimal 50 karakter!"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
      return;
    }

    // Semua validasi lolos, mulai proses submit
    setState(() => _isSubmitting = true);

    try {
      final request = CreateReportRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _imageFile!,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );

      final response = await _reportRepository.createReport(request);

      setState(() => _isSubmitting = false);

      if (!mounted) return;

      if (response.status == 'success') {
        // Tampilkan pesan sukses
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Laporan berhasil dikirim!"),
            backgroundColor: JalanKitaTheme.statusDone,
            duration: const Duration(seconds: 2),
          ),
        );

        // Clear form setelah berhasil
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFile = null;
          _currentPosition = null;
          _addressMessage = "Belum ada lokasi";
        });

        // Panggil callback untuk pindah ke tab Riwayat
        await Future.delayed(const Duration(milliseconds: 800));
        if (widget.onReportSubmitted != null) {
          widget.onReportSubmitted!();
        }
      } else {
        // Tampilkan pesan error dari server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Gagal mengirim laporan"),
            backgroundColor: JalanKitaTheme.statusRejected,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal terhubung ke server: $e"),
          backgroundColor: JalanKitaTheme.statusRejected,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Laporan Baru")),
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
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                hintText: 'ex: Jalan Berlubang di Depan Pasar',
                labelText: 'Judul Laporan',
                prefixIcon: Icon(Icons.title, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),

            // Deskripsi
            TextFormField(
              controller: _descriptionController,
              enabled: !_isSubmitting,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kondisi kerusakan...',
                labelText: 'Deskripsi Kerusakan',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Kirim
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _handleSubmitReport,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(_isSubmitting ? "MENGIRIM..." : "KIRIM LAPORAN"),
            ),
          ],
        ),
      ),
    );
  }
}
