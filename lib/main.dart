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

Future<void> main() async {
  // Wajib dipanggil sebelum memakai rootBundle di luar widget.
  WidgetsFlutterBinding.ensureInitialized();

  // Uji pembacaan JSON lewat debugPrint (hasil render ke UI ada di Tahap 13).
  try {
    final data = await loadStudentData();
    final student = data['student'] as Map<String, dynamic>;
    final courses = data['courses'] as List<dynamic>;

    debugPrint('JSON berhasil dimuat');
    debugPrint('NIM  : ${student['nim']}');
    debugPrint('Nama : ${student['name']}');
    debugPrint('Kelas: ${student['kelas']}');
    debugPrint('Jumlah courses: ${courses.length}');
    for (final c in courses) {
      final course = c as Map<String, dynamic>;
      debugPrint(
        '- ${course['code']} | ${course['title']} | '
        '${course['credits']} SKS | ${course['status']}',
      );
    }
  } catch (e) {
    debugPrint('Gagal memuat JSON: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TopicListPage(),
    );
  }
}

class TopicListPage extends StatelessWidget {
  const TopicListPage({super.key});

  final List<Map<String, dynamic>> topics = const [
    {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
    {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
    {
      'title': 'Flutter UI Fundamentals',
      'subtitle': 'Widgets & layout',
      'done': false,
    },
    {
      'title': '$studentId - $studentName',
      'subtitle': 'Pemilik aplikasi',
      'done': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int completed = topics.where((item) => item['done'] == true).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '$studentId - $studentName',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '$completed dari ${topics.length} topik selesai',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final item = topics[index];
                final bool isDone = item['done'] == true;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Icon(
                      isDone ? Icons.check_circle : Icons.schedule,
                      color: isDone ? Colors.green : Colors.orange,
                    ),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['subtitle'] as String),
                    trailing: Text(
                      isDone ? 'Selesai' : 'Belum',
                      style: TextStyle(
                        color: isDone ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
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
}
