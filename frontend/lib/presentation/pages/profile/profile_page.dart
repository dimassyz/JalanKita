import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/pages/profile/edit_profile_page.dart';
import 'package:frontend/presentation/widgets/profile_item_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() async {
    try {
      final repo = UserRepository(HttpService());
      final response = await repo.getProfile();

      if (response.status == "success") {
        setState(() {
          _user = response.data;
          _isLoading = false;
        });
      } else {
        _showError("Sesi berakhir, silakan login ulang.");
        _handleLogout();
      }
    } catch (e) {
      _showError("Gagal terhubung ke server: $e");
      setState(() => _isLoading = false);
    }
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: JalanKitaTheme.statusRejected,
            ),
            tooltip: "Keluar",
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchProfile(),
              child: SingleChildScrollView(
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
                              image: _user?.profilePicture != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        "http://10.112.163.140:2000/storage/${_user!.profilePicture}",
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _user?.profilePicture == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white54,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Halo, ${_user?.username}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Info Detail
                    ProfileInfoItem(
                      icon: Icons.person_outline,
                      title: "Nama Lengkap",
                      value: "${_user?.name ?? "-"}",
                    ),
                    const SizedBox(height: 10),
                    ProfileInfoItem(
                      icon: Icons.phone_android,
                      title: "Nomor Telepon",
                      value: "${_user?.phoneNumber ?? "-"}",
                    ),
                    const SizedBox(height: 10),
                    ProfileInfoItem(
                      icon: Icons.email_outlined,
                      title: "Email",
                      value: "${_user?.email ?? "-"}",
                    ),
                    const SizedBox(height: 10),
                    ProfileInfoItem(
                      icon: Icons.perm_identity,
                      title: "NIK",
                      value: "${_user?.nik ?? "-"}",
                    ),
                    const SizedBox(height: 10),
                    ProfileInfoItem(
                      icon: Icons.home_outlined,
                      title: "Alamat Lengkap",
                      value: "${_user?.alamatLengkap ?? "-"}",
                    ),

                    const SizedBox(height: 24),

                    // Tombol Edit
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(user: _user),
                            ),
                          );
                          if (result == true) _fetchProfile();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("EDIT PROFIL"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
