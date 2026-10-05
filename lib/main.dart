import 'package:flutter/material.dart';

const String studentName = 'Kadek Nova Krisna Putra';
const String studentId = '2415051117';

// Collection data: List<Map<String, dynamic>>
final List<Map<String, dynamic>> topics = [
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

void main() {
  runApp(const MyApp());
}

// Function reusable dari Tahap 8 (belum dipakai di halaman ini)
Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// StatefulWidget dari Tahap 9 (belum dipakai di halaman ini)
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$studentId - $studentName'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Tulis pesan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              child: const Text('Tampilkan'),
            ),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
        body: Column(
          children: [
            // Identitas tetap di atas list
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '$studentId - $studentName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // List mengisi sisa ruang
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final item = topics[index];
                  return ListTile(
                    leading: Icon(
                      item['done'] == true
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                    ),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['subtitle'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
