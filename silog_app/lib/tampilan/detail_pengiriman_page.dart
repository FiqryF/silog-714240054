import 'package:flutter/material.dart';

import '../model/pengiriman.dart';

// Nilai barang pada data praktikum ditampilkan sebagai rupiah bulat.
String formatRupiah(double nilai) =>
    'Rp${nilai.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.')}';

class DetailPengirimanPage extends StatelessWidget {
  final Pengiriman pengiriman;

  const DetailPengirimanPage({super.key, required this.pengiriman});

  Widget _baris(String label, String nilai, {bool monospace = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF737373)),
          ),
          const SizedBox(height: 6),
          Text(
            nilai,
            style: TextStyle(
              fontSize: 15,
              fontFamily: monospace ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bagian(String judul, String kode, IconData ikon, List<Widget> isi) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFF9FAFB),
            child: Row(
              children: [
                Icon(ikon, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  kode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: Color(0xFF737373),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < isi.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  isi[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tgl = pengiriman.tanggalKirim;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pengiriman.resi,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
            ),
            const Text(
              'Detail Pengiriman',
              style: TextStyle(fontSize: 10, color: Color(0xFF737373)),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: const Color(0xFF171717),
            child: const Text(
              'Detail',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _bagian(
                  'INFORMASI PENGIRIMAN',
                  'LOG-INFO',
                  Icons.local_shipping_outlined,
                  [
                    _baris('Nomor Resi', pengiriman.resi, monospace: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF737373),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              border: Border.all(
                                color: const Color(0xFF737373),
                              ),
                            ),
                            child: Text(
                              pengiriman.status,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _baris('Gudang Asal', pengiriman.asal.nama),
                    _baris('Kota Tujuan', pengiriman.kotaTujuan),
                    _baris(
                      'Tanggal Kirim',
                      '${tgl.day}/${tgl.month}/${tgl.year}',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _bagian(
                  'RINCIAN BARANG',
                  'ITEM-INFO',
                  Icons.inventory_2_outlined,
                  [
                    _baris(
                      'Kode Barang',
                      pengiriman.barang.kode,
                      monospace: true,
                    ),
                    _baris('Nama Barang', pengiriman.barang.nama),
                    _baris(
                      'Jumlah',
                      '${pengiriman.jumlah} ${pengiriman.barang.satuan}',
                    ),
                    _baris(
                      'Nilai Barang',
                      formatRupiah(pengiriman.nilaiBarang),
                      monospace: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Kembali ke Daftar'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ketuk untuk kembali ke layar Daftar Pengiriman',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Color(0xFF737373)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
