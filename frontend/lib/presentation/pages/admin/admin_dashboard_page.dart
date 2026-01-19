import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/presentation/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _selectedFilter = 'All';
  List<Report> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final repo = ReportRepository(HttpService());
      final response = await repo.getAllReport();
      setState(() {
        _reports = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Gagal mengambil data: $e");
    }
  }

  void _updateStatus(int id, String newStatus) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final repo = ReportRepository(HttpService());
      final response = await repo.updateReportStatus(
        id,
        newStatus.toLowerCase(),
      );

      if (response.status == "success") {
        _showSnackBar("Status berhasil diubah menjadi $newStatus");
        _fetchReports();
      }
    } catch (e) {
      _showSnackBar("Gagal update: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Report> get filteredReports {
    if (_selectedFilter == 'All') return _reports;
    return _reports
        .where((r) => r.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. Statistik Ringkas
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildStatCard(
                        "Pending",
                        _reports
                            .where((r) => r.status == 'pending')
                            .length
                            .toString(),
                        Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        "Proses",
                        _reports
                            .where((r) => r.status == 'diproses')
                            .length
                            .toString(),
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        "Selesai",
                        _reports
                            .where((r) => r.status == 'selesai')
                            .length
                            .toString(),
                        Colors.green,
                      ),
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
                      'All',
                      'Pending',
                      'Diproses',
                      'Selesai',
                      'Ditolak',
                    ].map((e) => _buildFilterChip(e)).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // 3. List Laporan
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchReports,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: JalanKitaTheme.surfaceColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "http://192.168.1.6:8000/storage/${report.imagePath}",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              report.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ID Laporan: #${report.id}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report.status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(report.status),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.edit_note,
                                color: JalanKitaTheme.primaryColor,
                              ),
                              onPressed: () => _showUpdateStatusDialog(report),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showUpdateStatusDialog(Report report) {
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
              Text(
                "Update Status Laporan #${report.id}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _buildStatusOption(report, "Pending", Icons.timer, Colors.grey),
              _buildStatusOption(report, "Diproses", Icons.build, Colors.blue),
              _buildStatusOption(
                report,
                "Selesai",
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatusOption(report, "Ditolak", Icons.cancel, Colors.red),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(
    Report report,
    String status,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: () => _updateStatus(report.id, status), // Panggil Fungsi API
      trailing: report.status.toLowerCase() == status.toLowerCase()
          ? const Icon(Icons.check, color: Colors.white)
          : null,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.blue;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  // Widget StatCard tetap sama secara visual
  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
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
        onSelected: (_) => setState(() => _selectedFilter = label),
        backgroundColor: JalanKitaTheme.inputColor,
        selectedColor: JalanKitaTheme.primaryColor,
      ),
    );
  }
}
