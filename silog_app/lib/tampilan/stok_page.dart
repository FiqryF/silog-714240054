import 'package:flutter/material.dart';

import '../data/preferensi.dart';
import '../data/stok_repository.dart';
import '../model/stok.dart';
import 'form_stok_page.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final _repo = StokRepository.instance;
  final _pref = Preferensi();
  final _pencarian = TextEditingController();

  List<Stok> _daftar = [];
  String _gudang = 'GD-BDG';
  String _kataKunci = '';
  bool _memuat = false;
  bool _gagal = false;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  Future<void> _muat([Future<void> Function()? perubahan]) async {
    if (_memuat) return;
    setState(() {
      _memuat = true;
      _gagal = false;
    });
    try {
      await perubahan?.call();
      final gudang = await _pref.ambilGudangTerakhir();
      final data = await _repo.ambilSemua(
        kodeGudang: gudang,
        namaBarang: _kataKunci,
      );
      if (!mounted) return;
      setState(() {
        _gudang = gudang;
        _daftar = data;
        _memuat = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _gagal = true;
        _memuat = false;
      });
    }
  }

  void _cari(String masukan) {
    if (_memuat) return;
    _kataKunci = masukan.trim();
    _muat();
  }

  Future<void> _tambahStok() async {
    final stok = await Navigator.push<Stok>(
      context,
      MaterialPageRoute<Stok>(
        builder: (_) => FormStokPage(kodeGudang: _gudang),
      ),
    );
    if (!mounted || stok == null) return;
    _pencarian.clear();
    _kataKunci = '';
    await _muat(() async {
      await _repo.simpan(stok);
    });
  }

  Future<void> _ubahJumlah(Stok stok, int delta) async {
    final baru = stok.jumlah + delta;
    if (baru < 0) return;
    await _muat(() => _repo.perbarui(stok.salinDengan(jumlah: baru)));
  }

  Future<void> _hapus(Stok stok) async {
    final id = stok.id;
    if (id == null) return;

    final ya = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus data stok'),
        content: Text('Hapus ${stok.namaBarang} dari gudang $_gudang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (!mounted || ya != true) return;
    await _muat(() => _repo.hapus(id));
  }

  @override
  Widget build(BuildContext context) {
    final total = _daftar.fold<int>(0, (jumlah, stok) => jumlah + stok.jumlah);

    return Scaffold(
      appBar: AppBar(title: Text('Stok Gudang $_gudang')),
      body: _memuat
          ? const Center(child: CircularProgressIndicator())
          : _gagal
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Data stok tidak dapat diproses.'),
                  TextButton(onPressed: _muat, child: const Text('Coba lagi')),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    controller: _pencarian,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      labelText: 'Cari nama barang',
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_kataKunci.isNotEmpty)
                            IconButton(
                              tooltip: 'Reset pencarian',
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _pencarian.clear();
                                _cari('');
                              },
                            ),
                          IconButton(
                            tooltip: 'Cari',
                            icon: const Icon(Icons.search),
                            onPressed: () => _cari(_pencarian.text),
                          ),
                        ],
                      ),
                    ),
                    onSubmitted: _cari,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _kataKunci.isEmpty
                        ? 'Total stok: $total unit dari ${_daftar.length} jenis barang'
                        : 'Hasil pencarian: $total unit dari ${_daftar.length} jenis barang',
                  ),
                ),
                Expanded(
                  child: _daftar.isEmpty
                      ? Center(
                          child: Text(
                            _kataKunci.isEmpty
                                ? 'Belum ada data stok'
                                : 'Barang tidak ditemukan',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: _daftar.length,
                          itemBuilder: (context, i) {
                            final stok = _daftar[i];
                            return ListTile(
                              title: Text(stok.namaBarang),
                              subtitle: Text(
                                '${stok.kodeBarang} - ${stok.jumlah} unit',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Kurangi stok',
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: stok.jumlah == 0
                                        ? null
                                        : () => _ubahJumlah(stok, -1),
                                  ),
                                  IconButton(
                                    tooltip: 'Tambah stok',
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => _ubahJumlah(stok, 1),
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus stok',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _hapus(stok),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _memuat || _gagal
          ? null
          : FloatingActionButton(
              tooltip: 'Tambah stok',
              onPressed: _tambahStok,
              child: const Icon(Icons.add),
            ),
    );
  }
}
