import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Filter Status Aktif
  String _selectedFilter = 'All'; // All, Pending, Diproses, Selesai

  // Dummy Data Laporan (Campuran semua user)
  final List<Map<String, dynamic>> allReports = [
    {
      "id": "1",
      "user": "Budi Santoso",
      "title": "Jalan Berlubang Parah",
      "date": "15 Okt 2023",
      "status": "Pending",
      "location": "Jl. Mawar No. 10"
    },
    {
      "id": "2",
      "user": "Siti Aminah",
      "title": "Lampu Merah Mati",
      "date": "20 Okt 2023",
      "status": "Diproses",
      "location": "Simpang Lima"
    },
    {
      "id": "3",
      "user": "Ahmad Dani",
      "title": "Pohon Tumbang",
      "date": "21 Okt 2023",
      "status": "Selesai",
      "location": "Jl. Sudirman"
    },
    {
      "id": "4",
      "user": "User Iseng",
      "title": "Tes Laporan",
      "date": "22 Okt 2023",
      "status": "Ditolak",
      "location": "Rumah"
    },
  ];

  // Helper untuk mendapatkan list yang difilter
  List<Map<String, dynamic>> get filteredReports {
    if (_selectedFilter == 'All') return allReports;
    return allReports.where((r) => r['status'] == _selectedFilter).toList();
  }

  // Fungsi Update Status (Munculkan Modal)
  void _showUpdateStatusDialog(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: JalanKitaTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Update Status Laporan", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Pilihan Status
              _buildStatusOption(report, "Pending", Icons.timer, Colors.grey),
              _buildStatusOption(report, "Diproses", Icons.build, Colors.blue),
              _buildStatusOption(report, "Selesai", Icons.check_circle, Colors.green),
              _buildStatusOption(report, "Ditolak", Icons.cancel, Colors.red),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(Map<String, dynamic> report, String status, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: () {
        // Update Logic (Dummy)
        setState(() {
          report['status'] = status;
        });
        Navigator.pop(context); // Tutup Modal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Status diubah menjadi $status")),
        );
      },
      trailing: report['status'] == status 
          ? const Icon(Icons.check, color: Colors.white) 
          : null,
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Statistik Ringkas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatCard("Pending", "1", Colors.grey),
                const SizedBox(width: 8),
                _buildStatCard("Proses", "1", Colors.blue),
                const SizedBox(width: 8),
                _buildStatCard("Selesai", "1", Colors.green),
              ],
            ),
          ),

          // 2. Filter Tabs
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Pending'),
                _buildFilterChip('Diproses'),
                _buildFilterChip('Selesai'),
                _buildFilterChip('Ditolak'),
              ],
            ),
          ),
          
          const SizedBox(height: 10),

          // 3. List Laporan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: JalanKitaTheme.surfaceColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, size: 20),
                    ),
                    title: Text(report['title'], 
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pelapor: ${report['user']}", style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        // Badge Status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            report['status'],
                            style: TextStyle(
                              fontSize: 10,
                              color: report['status'] == 'Selesai' ? Colors.green : 
                                     report['status'] == 'Diproses' ? Colors.blue : 
                                     report['status'] == 'Ditolak' ? Colors.red : Colors.grey
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_note, color: JalanKitaTheme.primaryColor),
                      onPressed: () => _showUpdateStatusDialog(report),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: JalanKitaTheme.inputColor,
        selectedColor: JalanKitaTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}