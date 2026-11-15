import 'package:flutter/material.dart';

import 'data/preferensi.dart';
import 'tampilan/daftar_pengiriman_page.dart';

void main() => runApp(const SiLogApp());

class SiLogApp extends StatefulWidget {
  const SiLogApp({super.key});

  @override
  State<SiLogApp> createState() => _SiLogAppState();
}

class _SiLogAppState extends State<SiLogApp> {
  final _preferensi = Preferensi();
  bool _gelap = false;
  bool _sibuk = true;

  @override
  void initState() {
    super.initState();
    _muatTema();
  }

  Future<void> _muatTema() async {
    try {
      final gelap = await _preferensi.modeGelap();
      if (mounted) setState(() => _gelap = gelap);
    } catch (error) {
      debugPrint('Preferensi tema gagal dimuat: $error');
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  Future<void> _ubahTema(BuildContext context) async {
    if (_sibuk) return;
    final gelap = !_gelap;
    setState(() => _sibuk = true);
    try {
      await _preferensi.setModeGelap(gelap);
      if (mounted) setState(() => _gelap = gelap);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mode tampilan gagal disimpan')),
      );
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  static ThemeData _buatTema(Brightness brightness) {
    final gelap = brightness == Brightness.dark;
    final skema =
        ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: brightness,
        ).copyWith(
          primary: gelap ? const Color(0xFFE5E7EB) : Colors.black,
          onPrimary: gelap ? const Color(0xFF171717) : Colors.white,
          surface: gelap ? const Color(0xFF17191D) : Colors.white,
          onSurface: gelap ? const Color(0xFFF3F4F6) : const Color(0xFF111827),
          onSurfaceVariant: gelap
              ? const Color(0xFFB9C1CE)
              : const Color(0xFF6B7280),
          surfaceContainerLow: gelap
              ? const Color(0xFF202329)
              : const Color(0xFFF9FAFB),
          surfaceContainerHigh: gelap
              ? const Color(0xFF2B3038)
              : const Color(0xFFF3F4F6),
          outlineVariant: gelap
              ? const Color(0xFF454B56)
              : const Color(0xFFD1D5DB),
        );
    final pemisah = gelap ? skema.outlineVariant : const Color(0xFFE5E7EB);

    return ThemeData(
      useMaterial3: true,
      colorScheme: skema,
      scaffoldBackgroundColor: skema.surface,
      dividerColor: pemisah,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: skema.surface,
        foregroundColor: skema.onSurface,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: pemisah)),
        titleTextStyle: TextStyle(
          color: skema.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: skema.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          side: BorderSide(color: skema.outlineVariant),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: skema.primary,
        foregroundColor: skema.onPrimary,
        shape: const StadiumBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: gelap ? skema.primary : const Color(0xFF171717),
          foregroundColor: skema.onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(),
        ),
      ),
    );
  }

  final _temaTerang = _buatTema(Brightness.light);
  final _temaGelap = _buatTema(Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiLog',
      debugShowCheckedModeBanner: false,
      theme: _temaTerang,
      darkTheme: _temaGelap,
      themeMode: _gelap ? ThemeMode.dark : ThemeMode.light,
      home: DaftarPengirimanPage(ubahTema: _sibuk ? null : _ubahTema),
    );
  }
}
