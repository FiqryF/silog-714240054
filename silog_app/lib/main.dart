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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C),
        ),
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
        title: const Text('SiLog'),
        centerTitle: true,
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFEBEE), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 6,
                shadowColor: const Color(0x33000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB71C1C),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_shipping_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sistem Informasi Logistik',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7F0000),
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Data Praktikan',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: const Color(0xFF757575)),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 8),
                      const _InfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Nama',
                        value: 'Fiqry Firmansyah',
                      ),
                      const _InfoRow(
                        icon: Icons.badge_outlined,
                        label: 'NIM',
                        value: '714240054',
                      ),
                      const _InfoRow(
                        icon: Icons.school_outlined,
                        label: 'Kelas',
                        value: 'D4 Teknik Informatika 3B',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFB71C1C)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
