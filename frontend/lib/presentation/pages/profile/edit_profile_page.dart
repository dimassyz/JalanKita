import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/request/update_profile_request.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;
  const EditProfilePage({super.key, this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _alamatController;

  File? _image;
  final _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? "");
    _phoneController = TextEditingController(
      text: widget.user?.phoneNumber ?? "",
    );
    _alamatController = TextEditingController(
      text: widget.user?.alamatLengkap ?? "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _handleUpdate() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _alamatController.text.isEmpty) {
      _showSnackBar("Semua form harus diisi");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = UserRepository(HttpService());
      final request = UpdateProfileRequest(
        name: _nameController.text,
        phone: _phoneController.text,
        alamat: _alamatController.text,
      );

      final response = await repo.updateProfile(request, _image);

      if (response.status == "success") {
        _showSnackBar("Profil berhasil diperbarui!");
        Navigator.pop(context, true);
      } else {
        _showSnackBar(response.message ?? "Gagal update");
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar dengan Icon Kamera
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : (widget.user?.profilePicture != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      "http://192.168.1.6:8000/storage/${widget.user!.profilePicture}",
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                    ),
                    child: _image == null && widget.user?.profilePicture == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white54,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: JalanKitaTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Edit Nama
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit Telepon
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit Alamat
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat Lengkap',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("SIMPAN PERUBAHAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
