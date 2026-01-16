import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // TODO: Logic Upload Foto
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Buka Galeri...")),
                        );
                      },
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
              initialValue: "Nama Mahasiswa", // Dummy Data
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit Username
            TextFormField(
              initialValue: "Username Mahasiswa", // Dummy Data
              decoration: const InputDecoration(
                labelText: 'Username Akun',
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit Telepon
            TextFormField(
              initialValue: "0812-3456-7890", // Dummy Data
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: Icon(Icons.phone_android, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit NIK
            TextFormField(
              initialValue: "1234567890123456", // Dummy Data
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'NIK',
                prefixIcon: Icon(Icons.perm_identity, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit Email
            TextFormField(
              initialValue: "mahasiswa@jalankita.com", // Dummy Data
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Form Edit Alamat
            TextFormField(
              initialValue: "Jl. Merdeka No. 123, Jakarta", // Dummy Data
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                labelText: 'Alamat Lengkap',
                prefixIcon: Icon(Icons.home_outlined, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Logic Update Data ke Database
                  Navigator.pop(context); // Balik ke halaman profil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Perubahan Disimpan!")),
                  );
                },
                child: const Text("SIMPAN PERUBAHAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
