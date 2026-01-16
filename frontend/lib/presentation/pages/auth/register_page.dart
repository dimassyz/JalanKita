import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  bool _isObscureConfirm = true;

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

              // Username Akun
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username Akun',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // Nama Lengkap
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // Nomor HP
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone_android, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // NIK
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                  prefixIcon: Icon(Icons.perm_identity, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // Alamat Lengkap
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                  prefixIcon: Icon(Icons.home_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // Password
              TextFormField(
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
              const SizedBox(height: 10),

              // Konfirmasi Password
              TextFormField(
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
              const SizedBox(height: 24),

              // Register Button
              ElevatedButton(
                onPressed: () {
                  // Logika Register nanti di sini
                },
                child: const Text("DAFTAR"),
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
