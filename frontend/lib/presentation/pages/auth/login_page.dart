import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/presentation/pages/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Logo 
                Image(image:AssetImage('assets/images/logo.png'), height: 100),
                const SizedBox(height: 16),
                const Text(
                  "JalanKita",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Laporkan kerusakan jalan di sekitarmu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 48),

                // 2. Form Section
                const Text(
                  "Masuk",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                // Email Input
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'contoh@email.com',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input
                TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
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

                const SizedBox(height: 32),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Logika login nanti di sini
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tombol Masuk Ditekan")),
                    );
                  },
                  child: const Text("MASUK"),
                ),

                const SizedBox(height: 24),

                // 3. Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke Register Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: JalanKitaTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}