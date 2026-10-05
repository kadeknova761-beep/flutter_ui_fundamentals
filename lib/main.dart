import 'package:flutter/material.dart';

const String studentName = 'Kadek Nova Krisna Putra';
const String studentId = '2415051117';

void main() {
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
