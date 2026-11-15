import 'package:flutter/material.dart';

import '../model/stok.dart';

class FormStokPage extends StatefulWidget {
  const FormStokPage({super.key, required this.kodeGudang});

  final String kodeGudang;

  @override
  State<FormStokPage> createState() => _FormStokPageState();
}

class _FormStokPageState extends State<FormStokPage> {
  final _formKey = GlobalKey<FormState>();
  final _kode = TextEditingController();
  final _nama = TextEditingController();
  final _jumlah = TextEditingController();

  @override
  void dispose() {
    _kode.dispose();
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  String? _wajib(String? nilai, String label) {
    return nilai == null || nilai.trim().isEmpty ? '$label wajib diisi' : null;
  }

  String? _validasiJumlah(String? nilai) {
    final pesanWajib = _wajib(nilai, 'Jumlah');
    if (pesanWajib != null) return pesanWajib;
    final jumlah = int.tryParse(nilai!.trim(), radix: 10);
    if (jumlah == null || jumlah < 1 || jumlah > 9007199254740991) {
      return 'Jumlah harus berupa bilangan bulat positif yang valid';
    }
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Stok(
        kodeBarang: _kode.text.trim(),
        namaBarang: _nama.text.trim(),
        kodeGudang: widget.kodeGudang,
        jumlah: int.parse(_jumlah.text.trim(), radix: 10),
        diperbaruiPada: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Stok')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Gudang ${widget.kodeGudang}'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _kode,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Kode Barang',
                    border: OutlineInputBorder(),
                  ),
                  validator: (nilai) => _wajib(nilai, 'Kode barang'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nama,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(),
                  ),
                  validator: (nilai) => _wajib(nilai, 'Nama barang'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _jumlah,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah (unit)',
                    border: OutlineInputBorder(),
                    errorMaxLines: 2,
                  ),
                  validator: _validasiJumlah,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _simpan,
                  child: const Text('Simpan Stok'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
