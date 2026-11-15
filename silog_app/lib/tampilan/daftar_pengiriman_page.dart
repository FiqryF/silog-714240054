
import 'package:flutter/material.dart';

import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import 'detail_pengiriman_page.dart';
import 'form_pengiriman_page.dart';
import 'stok_page.dart';

class DaftarPengirimanPage extends StatefulWidget {
  const DaftarPengirimanPage({super.key, this.ubahTema});

  final Future<void> Function(BuildContext context)? ubahTema;

  @override
  State<DaftarPengirimanPage> createState() =>
      _DaftarPengirimanPageState();
}

class _DaftarPengirimanPageState
    extends State<DaftarPengirimanPage> {
  late List<Pengiriman> _daftar;

  @override
  void initState() {
    super.initState();

    _daftar = List<Pengiriman>.from(dataPengiriman);
  }

  double get _totalNilai => _daftar.fold<double>(
        0,
        (total, item) => total + item.nilaiBarang,
      );

  List<Pengiriman> _hasilSaring(String? status) {
    if (status == null) {
      return _daftar;
    }

    return _daftar
        .where((item) => item.status == status)
        .toList();
  }

  Future<void> _bukaFormulir() async {
    final hasil = await Navigator.push<Pengiriman>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengirimanPage(
          resiTerpakai: _daftar
              .map(
                (item) =>
                    item.resi.trim().toUpperCase(),
              )
              .toSet(),
        ),
      ),
    );

    if (!mounted || hasil == null) return;

    // Pemeriksaan tambahan untuk mencegah resi duplikat.
    if (_daftar.any(
      (item) =>
          item.resi.trim().toUpperCase() ==
          hasil.resi.toUpperCase(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor resi sudah digunakan'),
        ),
      );

      return;
    }

    setState(() {
      _daftar.insert(0, hasil);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pengiriman ${hasil.resi} berhasil ditambahkan',
        ),
      ),
    );
  }

  Future<void> _bukaDetail(
    Pengiriman pengiriman,
  ) async {
    final dihapus = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DetailPengirimanPage(
          pengiriman: pengiriman,
        ),
      ),
    );

    if (!mounted || dihapus != true) return;

    setState(() {
      _daftar.removeWhere(
        (item) => identical(item, pengiriman),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pengiriman ${pengiriman.resi} berhasil dihapus',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skema = tema.colorScheme;
    final gelap = tema.brightness == Brightness.dark;
    final ubahTema = widget.ubahTema;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengiriman'),
          actions: [
            IconButton(
              icon: Icon(gelap ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              tooltip: gelap ? 'Aktifkan mode terang' : 'Aktifkan mode gelap',
              onPressed: ubahTema == null ? null : () => ubahTema(context),
            ),
            IconButton(
              icon: const Icon(Icons.warehouse_outlined),
              tooltip: 'Stok Gudang',
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const StokPage(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Cari resi',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                RingkasanPengiriman(
                  jumlah: _daftar.length,
                  totalNilai: _totalNilai,
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(
                    16, 0, 16, 6,
                  ),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: skema.surfaceContainerHigh,
                    border: Border.all(
                      color: skema.outlineVariant,
                    ),
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                  child: TabBar(
                    dividerHeight: 0,
                    indicatorSize:
                        TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: skema.primary,
                      borderRadius:
                          const BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                    labelColor: skema.onPrimary,
                    unselectedLabelColor: skema.onSurface,
                    labelStyle: const TextStyle(fontSize: 11),
                    labelPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    tabs: const [
                      Tab(
                        text: 'Semua',
                        height: 32,
                      ),
                      Tab(
                        text: 'Dalam Perjalanan',
                        height: 32,
                      ),
                      Tab(
                        text: 'Diterima',
                        height: 32,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      _tampilkanDaftar(null),
                      _tampilkanDaftar(
                        'Dalam Perjalanan',
                      ),
                      _tampilkanDaftar('Diterima'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
            FloatingActionButton.extended(
          onPressed: _bukaFormulir,
          icon: const Icon(
            Icons.add,
            size: 18,
          ),
          label: const Text('Pengiriman Baru'),
        ),
      ),
    );
  }

  Widget _tampilkanDaftar(String? status) {
    final daftar = _hasilSaring(status);

    if (daftar.isEmpty) {
      return const Center(
        child: Text('Tidak ada data pengiriman'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: daftar.length,
      itemBuilder: (context, index) {
        final item = daftar[index];

        return KartuPengiriman(
          pengiriman: item,
          onTap: () => _bukaDetail(item),
        );
      },
    );
  }
}

class RingkasanPengiriman
    extends StatelessWidget {
  final int jumlah;
  final double totalNilai;

  const RingkasanPengiriman({
    super.key,
    required this.jumlah,
    required this.totalNilai,
  });

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: skema.surfaceContainerLow,
        border: Border.all(
          color: skema.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'JUMLAH PENGIRIMAN',
                    style: TextStyle(
                      fontSize: 10,
                      color: skema.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$jumlah',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const VerticalDivider(width: 24),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL NILAI BARANG',
                    style: TextStyle(
                      fontSize: 10,
                      color: skema.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatRupiah(totalNilai),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
