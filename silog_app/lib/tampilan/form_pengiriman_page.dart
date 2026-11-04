
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/data_contoh.dart';
import '../model/barang.dart';
import '../model/pengiriman.dart';

class FormPengirimanPage extends StatefulWidget {
  final Set<String> resiTerpakai;

  const FormPengirimanPage({
    super.key,
    required this.resiTerpakai,
  });

  @override
  State<FormPengirimanPage> createState() =>
      _FormPengirimanPageState();
}

class _FormPengirimanPageState extends State<FormPengirimanPage> {
  final _formKey = GlobalKey<FormState>();

  final _resiC = TextEditingController();
  final _namaBarangC = TextEditingController();
  final _hargaC = TextEditingController();
  final _jumlahC = TextEditingController();
  final _beratC = TextEditingController();

  String _kotaTujuan = 'Surabaya';
  DateTime _tanggalKirim = DateTime.now();

  @override
  void dispose() {
    _resiC.dispose();
    _namaBarangC.dispose();
    _hargaC.dispose();
    _jumlahC.dispose();
    _beratC.dispose();
    super.dispose();
  }

  String? _wajib(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  String? _validasiResi(String? value) {
    final dasar = _wajib(value, 'Nomor resi');
    if (dasar != null) return dasar;

    final resi = value!.trim().toUpperCase();

    if (!RegExp(r'^SLG-\d{4}-\d{4}$').hasMatch(resi)) {
      return 'Format resi harus SLG-TAHUN-NOMOR, '
          'contoh SLG-2026-0010';
    }

    if (widget.resiTerpakai.contains(resi)) {
      return 'Nomor resi sudah digunakan, masukkan resi lain';
    }

    return null;
  }

  String? _validasiBilangan(
    String? value,
    String label, {
    double min = 1,
    double? max,
    bool harusBulat = false,
  }) {
    final dasar = _wajib(value, label);
    if (dasar != null) return dasar;

    final teks = value!.trim().replaceAll(',', '.');
    final angka = double.tryParse(teks);

    if (angka == null || !angka.isFinite) {
      return '$label harus berupa angka';
    }

    if (harusBulat && angka != angka.truncateToDouble()) {
      return '$label harus bilangan bulat';
    }

    if (angka < min || (max != null && angka > max)) {
      if (max != null) {
        return '$label harus antara '
            '${_angkaLabel(min)} dan ${_angkaLabel(max)}';
      }

      return '$label minimal ${_angkaLabel(min)}';
    }

    return null;
  }

  String _angkaLabel(double angka) {
    if (angka == angka.truncateToDouble()) {
      return angka.toStringAsFixed(0);
    }

    return angka.toString().replaceAll('.', ',');
  }

  String? _validasiTanggal() {
    final sekarang = DateTime.now();

    final hariIni = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
    );

    final tanggal = DateTime(
      _tanggalKirim.year,
      _tanggalKirim.month,
      _tanggalKirim.day,
    );

    if (tanggal.isBefore(hariIni)) {
      return 'Tanggal kirim tidak boleh sebelum hari ini';
    }

    return null;
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();

    final hariIni = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
    );

    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalKirim.isBefore(hariIni)
          ? hariIni
          : _tanggalKirim,
      firstDate: hariIni,
      lastDate: hariIni.add(const Duration(days: 90)),
    );

    if (hasil != null && mounted) {
      setState(() {
        _tanggalKirim = hasil;
      });
    }
  }

  void _simpan() {
    final valid = _formKey.currentState!.validate();
    final pesanTanggal = _validasiTanggal();

    if (!valid || pesanTanggal != null) {
      if (pesanTanggal != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(pesanTanggal),
          ),
        );
      }

      return;
    }

    final pengiriman = Pengiriman(
      resi: _resiC.text.trim().toUpperCase(),
      asal: gudangBandung,
      kotaTujuan: _kotaTujuan,
      pelanggan: pelangganContoh,
      barang: Barang(
        kode:
            'B-${DateTime.now().millisecondsSinceEpoch % 10000}',
        nama: _namaBarangC.text.trim(),
        hargaSatuan: double.parse(_hargaC.text.trim()),
        beratKg: double.parse(
          _beratC.text.trim().replaceAll(',', '.'),
        ),
      ),
      jumlah: int.parse(_jumlahC.text.trim()),
      tanggalKirim: _tanggalKirim,
      status: 'Menunggu Pickup',
    );

    Navigator.pop(context, pengiriman);
  }

  @override
  Widget build(BuildContext context) {
    const kota = [
      'Surabaya',
      'Makassar',
      'Medan',
      'Denpasar',
      'Jayapura',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengiriman Baru'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Form(
            key: _formKey,
            autovalidateMode:
                AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _resiC,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Resi',
                    hintText: 'SLG-2026-0010',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization:
                      TextCapitalization.characters,
                  validator: _validasiResi,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _namaBarangC,
                  decoration: const InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      _wajib(v, 'Nama barang'),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _hargaC,
                  decoration: const InputDecoration(
                    labelText: 'Harga Satuan (Rp)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) => _validasiBilangan(
                    v,
                    'Harga satuan',
                    min: 1000,
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _jumlahC,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) => _validasiBilangan(
                    v,
                    'Jumlah',
                    harusBulat: true,
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _beratC,
                  decoration: const InputDecoration(
                    labelText: 'Berat Barang (kg)',
                    hintText: 'Contoh: 2,5',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.,]'),
                    ),
                  ],
                  validator: (v) => _validasiBilangan(
                    v,
                    'Berat barang',
                    min: 0.1,
                    max: 5000,
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _kotaTujuan,
                  decoration: const InputDecoration(
                    labelText: 'Kota Tujuan',
                    border: OutlineInputBorder(),
                  ),
                  items: kota.map((k) {
                    return DropdownMenuItem(
                      value: k,
                      child: Text(k),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _kotaTujuan = v;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: _pilihTanggal,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    'Tanggal Kirim: '
                    '${_tanggalKirim.day}/'
                    '${_tanggalKirim.month}/'
                    '${_tanggalKirim.year}',
                  ),
                ),
                const SizedBox(height: 24),

                FilledButton(
                  onPressed: _simpan,
                  child: const Text('Simpan Pengiriman'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
