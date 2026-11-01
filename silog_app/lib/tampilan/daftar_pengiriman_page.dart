import 'package:flutter/material.dart';

import '../data/data_contoh.dart';
import '../widget/kartu_pengiriman.dart';
import 'detail_pengiriman_page.dart';

class DaftarPengirimanPage extends StatelessWidget {
  const DaftarPengirimanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalNilai = dataPengiriman.fold<double>(
      0,
      (total, item) => total + item.nilaiBarang,
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengiriman'),
          actions: [
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
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                RingkasanPengiriman(
                  jumlah: dataPengiriman.length,
                  totalNilai: totalNilai,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const TabBar(
                    dividerHeight: 0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xFF111827),
                    labelStyle: TextStyle(fontSize: 11),
                    labelPadding: EdgeInsets.symmetric(horizontal: 2),
                    tabs: [
                      Tab(text: 'Semua', height: 32),
                      Tab(text: 'Dalam Perjalanan', height: 32),
                      Tab(text: 'Diterima', height: 32),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final status in [
                        null,
                        'Dalam Perjalanan',
                        'Diterima',
                      ])
                        _daftar(context, status),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Pengiriman Baru'),
        ),
      ),
    );
  }

  Widget _daftar(BuildContext context, String? status) {
    final daftar = dataPengiriman
        .where((item) => status == null || item.status == status)
        .toList();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: daftar.length,
      itemBuilder: (context, index) {
        final item = daftar[index];
        return KartuPengiriman(
          pengiriman: item,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => DetailPengirimanPage(pengiriman: item),
            ),
          ),
        );
      },
    );
  }
}

class RingkasanPengiriman extends StatelessWidget {
  final int jumlah;
  final double totalNilai;

  const RingkasanPengiriman({
    super.key,
    required this.jumlah,
    required this.totalNilai,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JUMLAH PENGIRIMAN',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL NILAI BARANG',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
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
