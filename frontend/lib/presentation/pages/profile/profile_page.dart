import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/pages/profile/edit_profile_page.dart';
import 'package:frontend/presentation/widgets/profile_item_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: JalanKitaTheme.statusRejected,
            ),
            tooltip: "Keluar",
            onPressed: () {
              // Balik ke Login
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Foto Profil & Nama
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: JalanKitaTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Halo, Username Mahasiswa",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Info Detail
            const ProfileInfoItem(
              icon: Icons.person_outline,
              title: "Nama Lengkap",
              value: "Nama Mahasiswa",
            ),
            const SizedBox(height: 10),
            const ProfileInfoItem(
              icon: Icons.phone_android,
              title: "Nomor Telepon",
              value: "0812-3456-7890",
            ),
            const SizedBox(height: 10),
            const ProfileInfoItem(
              icon: Icons.email_outlined,
              title: "Email",
              value: "mahasiswa@jalankita.com",
            ),
            const SizedBox(height: 10),
            const ProfileInfoItem(
              icon: Icons.perm_identity,
              title: "NIK",
              value: "1234567890123456",
            ),
            const SizedBox(height: 10),
            const ProfileInfoItem(
              icon: Icons.home_outlined,
              title: "Alamat Lengkap",
              value: "Jl. Merdeka No. 123, Jakarta",
            ),

            const SizedBox(height: 24),

            // Tombol Edit
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigasi ke Halaman Edit Profil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("EDIT PROFIL"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
