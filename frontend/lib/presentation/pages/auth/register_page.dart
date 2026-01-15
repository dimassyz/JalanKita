import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/data/usecase/request/register_request.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _isLoading = false;

  final AuthRepository _authRepository = AuthRepository(HttpService());

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleRegister() async {
    // Cek semua field terisi
    if (_nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar("Semua field harus diisi");
      return;
    }

    // Cek password valid?
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar("Kata sandi tidak cocok");
      return;
    }

    if (_nikController.text.length != 16) {
      _showSnackBar("NIK harus berjumlah 16 digit");
      return;
    }

    if (!_emailController.text.contains("@")) {
      _showSnackBar("Format email tidak valid");
      return;
    }

    if (_passwordController.text.length < 8) {
      _showSnackBar("Kata sandi minimal 8 karakter");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = RegisterRequest(
        name: _nameController.text,
        username: _usernameController.text,
        nik: _nikController.text,
        email: _emailController.text,
        alamatLengkap: _addressController.text,
        phoneNumber: _phoneController.text,
        password: _passwordController.text,
      );

      final response = await _authRepository.register(request);

      setState(() => _isLoading = false);

      if (response.status == 'success') {
        _showSnackBar(response.message ?? "Registrasi berhasil");
        Navigator.pop(context); // Kembali ke Login
      } else {
        _showSnackBar(response.message ?? "Terjadi kesalahan");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Gagal terhubung ke server: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Buat Akun",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Bergabung bersama kami untuk infrastruktur yang lebih baik.",
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              const SizedBox(height: 32),

              // Nama Lengkap
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // NIK
              TextFormField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                  prefixIcon: Icon(Icons.badge_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Nomor HP
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone_android, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Alamat Lengkap
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Register Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("DAFTAR"),
              ),

              const SizedBox(height: 24),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke Login
                    },
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        color: JalanKitaTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
