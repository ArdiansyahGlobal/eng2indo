import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baca Al-Quran',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SuratPage(),
    );
  }
}

class SuratPage extends StatefulWidget {
  const SuratPage({super.key});

  @override
  _SuratPageState createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  bool isLoading = true;
  Map<String, dynamic> suratYasin = {};

  @override
  void initState() {
    super.initState();
    _fetchSuratYasin();
  }

  // Fungsi untuk menarik data Surat Yasin dari API
  Future<void> _fetchSuratYasin() async {
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah/36'), // Surat Yasin (nomor 36)
    );

    if (response.statusCode == 200) {
      // Jika berhasil, ambil data JSON
      final data = json.decode(response.body);
      setState(() {
        suratYasin = data['data'];
        isLoading = false;
      });
    } else {
      // Jika gagal, tampilkan pesan error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load Surat Yasin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baca Surat Yasin'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Surat Yasin - Al-Quran',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: suratYasin['ayahs']?.length ?? 0,
                itemBuilder: (context, index) {
                  final ayat = suratYasin['ayahs'][index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      // Menghilangkan 'Ayat' dan nomor
                      title: Text(ayat['text'] ?? ''),
                    ),
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

//31 desember 2024.
