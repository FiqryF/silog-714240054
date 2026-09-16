import 'package:flutter/material.dart';

void main() {
  runApp(const SiLogApp());
}

class SiLogApp extends StatelessWidget {
  const SiLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiqry Firmansyah - 714240054',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),
      home: const BerandaPage(),
    );
  }
}

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SiLog - Modul 1'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(24),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_shipping, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Sistem Informasi Logistik',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text('Data Praktikan'),
                  Divider(height: 28),
                  Text('Nama: Fiqry Firmansyah'),
                  SizedBox(height: 6),
                  Text('NIM: 714240054'),
                  SizedBox(height: 6),
                  Text('Kelas: D4 Teknik Informatika 3B'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}