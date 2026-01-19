import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:frontend/presentation/pages/profile/profile_page.dart';
import 'package:frontend/presentation/pages/report/create_report_page.dart';
import 'package:frontend/presentation/pages/report/history_report_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/presentation/pages/admin/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cek Sesi Login
  final prefs = await SharedPreferences.getInstance();
  final bool isLogin = prefs.getBool('is_login') ?? false;
  final String role = prefs.getString('role') ?? 'user';

  runApp(MyApp(isLogin: isLogin, role: role));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  final String role;
  const MyApp({super.key, required this.isLogin, required this.role});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: JalanKitaTheme.darkTheme,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: isLogin
          ? (role == 'admin'
                ? const AdminPage()
                : const MyHomePage(title: "JalanKita"))
          : const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Default: 0 (Halaman Form)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onReportSubmitted() {
    // Pindah ke tab Riwayat setelah laporan berhasil dikirim
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body berubah sesuai index yang dipilih
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CreateReportPage(onReportSubmitted: _onReportSubmitted), // Index 0
          const HistoryPage(), // Index 1
          const ProfilePage(), // Index 2
        ],
      ),

      // Footer Bar (Bottom Navigation)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_outlined),
            activeIcon: Icon(Icons.add_a_photo),
            label: 'Lapor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
