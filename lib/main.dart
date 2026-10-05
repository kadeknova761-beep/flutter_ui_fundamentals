import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Kadek Nova Krisna Putra';
const String studentId = '2415051117';

// ===== SAKLAR DEBUGGING TAHAP 15 =====
// Kasus A: true = tampilkan versi overflow, false = versi perbaikan.
const bool showOverflowBug = false;
// Kasus C: true = path JSON sengaja salah untuk menguji error state.
const bool simulateJsonError = false;
// =======================================

/// Membaca assets/data/student_data.json lalu mengubahnya menjadi Map.
Future<Map<String, dynamic>> loadStudentData() async {
  final String path = simulateJsonError
      ? 'assets/data/student_data_salah.json'
      : 'assets/data/student_data.json';

  final jsonString = await rootBundle.loadString(path);
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // late: diisi di initState(), sebelum dipakai oleh build().
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    // Future dibuat satu kali di sini, bukan di dalam build().
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // 1. Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Error state
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$studentId - $studentName',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat data: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. Data state
            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            final int totalCourses = courses.length;
            final int totalCredits = courses.fold<int>(
              0,
              (sum, c) => sum + ((c as Map<String, dynamic>)['credits'] as int),
            );
            final int doneCount = courses
                .where((c) => (c as Map<String, dynamic>)['status'] == 'done')
                .length;

            return CustomScrollView(
              slivers: [
                // Kartu profil / identitas
                SliverToBoxAdapter(
                  child: ProfileCard(
                    name: student['name'] as String,
                    nim: student['nim'] as String,
                    kelas: student['kelas'] as String,
                    semester: student['semester'].toString(),
                  ),
                ),

                // Kasus A: demo overflow dan perbaikannya
                const SliverToBoxAdapter(child: OverflowCaseCard()),

                // Baris ringkasan
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        SummaryCard(
                          icon: Icons.menu_book,
                          value: '$totalCourses',
                          label: 'Materi',
                        ),
                        SummaryCard(
                          icon: Icons.school,
                          value: '$totalCredits',
                          label: 'Total SKS',
                        ),
                        SummaryCard(
                          icon: Icons.check_circle,
                          value: '$doneCount',
                          label: 'Selesai',
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Daftar Materi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Daftar course dari JSON
                SliverList.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return CourseTile(
                      code: course['code'] as String,
                      title: course['title'] as String,
                      credits: course['credits'] as int,
                      status: course['status'] as String,
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Kasus A: Row dengan teks panjang.
/// showOverflowBug = true  -> Text langsung di Row (RenderFlex overflow).
/// showOverflowBug = false -> Text dibungkus Expanded (teks turun ke baris baru).
class OverflowCaseCard extends StatelessWidget {
  const OverflowCaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    const String longText =
        '$studentId - $studentName - Ini adalah teks yang sangat panjang '
        'untuk menguji layout dan harus tetap terbaca tanpa overflow';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: showOverflowBug
            // VERSI RUSAK: Text tidak dibatasi lebarnya oleh Row.
            ? Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 8),
                  Text(longText),
                ],
              )
            // VERSI PERBAIKAN: Expanded membatasi Text pada sisa lebar Row.
            : Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 8),
                  Expanded(child: Text(longText)),
                ],
              ),
      ),
    );
  }
}

/// Reusable widget 1: kartu profil mahasiswa.
class ProfileCard extends StatelessWidget {
  final String name;
  final String nim;
  final String kelas;
  final String semester;

  const ProfileCard({
    super.key,
    required this.name,
    required this.nim,
    required this.kelas,
    required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/profile.jpg',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                // Jika asset gagal dimuat, tampilkan ikon profil.
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 72,
                    height: 72,
                    child: Icon(Icons.person, size: 48),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(nim),
                  const SizedBox(height: 4),
                  Text('Kelas $kelas - Semester $semester'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable widget 2: kartu ringkasan (angka + label).
class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable widget 3: item course dengan status conditional.
class CourseTile extends StatelessWidget {
  final String code;
  final String title;
  final int credits;
  final String status;

  const CourseTile({
    super.key,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  IconData get _icon {
    switch (status) {
      case 'done':
        return Icons.check_circle;
      case 'active':
        return Icons.play_circle;
      default:
        return Icons.schedule;
    }
  }

  Color get _color {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String get _label {
    switch (status) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Berjalan';
      default:
        return 'Rencana';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(_icon, color: _color, size: 32),
        title: Text(title),
        subtitle: Text('$code - $credits SKS'),
        trailing: Text(
          _label,
          style: TextStyle(color: _color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
