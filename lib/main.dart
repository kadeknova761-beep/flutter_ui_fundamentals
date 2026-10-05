import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Kadek Nova Krisna Putra';
const String studentId = '2415051117';

/// Membaca assets/data/student_data.json lalu mengubahnya menjadi Map.
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
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
      body: FutureBuilder<Map<String, dynamic>>(
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
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 3. Data state
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: Text(student['name'] as String),
                  subtitle: Text('${student['nim']} - ${student['kelas']}'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    final String status = course['status'] as String;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Icon(
                          _statusIcon(status),
                          color: _statusColor(status),
                        ),
                        title: Text(course['title'] as String),
                        subtitle: Text(
                          '${course['code']} - ${course['credits']} SKS',
                        ),
                        trailing: Text(
                          status,
                          style: TextStyle(
                            color: _statusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'done':
        return Icons.check_circle;
      case 'active':
        return Icons.play_circle;
      default:
        return Icons.schedule;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
