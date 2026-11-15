
import 'package:flutter/material.dart';

import '../model/pengiriman.dart';

String formatRupiah(double nilai) {
  final angka = nilai.toStringAsFixed(0);

  return 'Rp${angka.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (match) => '${match[1]}.',
  )}';
}

class DetailPengirimanPage
    extends StatelessWidget {
  final Pengiriman pengiriman;

  const DetailPengirimanPage({
    super.key,
    required this.pengiriman,
  });

  Future<void> _konfirmasiHapus(
    BuildContext context,
  ) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Pengiriman?'),
          content: Text(
            'Pengiriman ${pengiriman.resi} '
            'akan dihapus dari daftar. '
            'Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yakin == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Widget _baris(
    BuildContext context,
    String label,
    String nilai, {
    bool monospace = false,
  }) {
    final skema = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: skema.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nilai,
            style: TextStyle(
              fontSize: 15,
              fontFamily:
                  monospace ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bagian(
    BuildContext context,
    String judul,
    String kode,
    IconData ikon,
    List<Widget> isi,
  ) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: skema.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: skema.surfaceContainerLow,
            child: Row(
              children: [
                Icon(
                  ikon,
                  size: 16,
                ),
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
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: skema.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                for (
                  var i = 0;
                  i < isi.length;
                  i++
                ) ...[
                  if (i > 0)
                    const Divider(height: 1),
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
    final skema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              pengiriman.resi,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
              ),
            ),
            Text(
              'Detail Pengiriman',
              style: TextStyle(
                fontSize: 10,
                color: skema.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            color: skema.primary,
            child: Text(
              'Detail',
              style: TextStyle(
                fontSize: 11,
                color: skema.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                _bagian(
                  context,
                  'INFORMASI PENGIRIMAN',
                  'LOG-INFO',
                  Icons.local_shipping_outlined,
                  [
                    _baris(
                      context,
                      'Nomor Resi',
                      pengiriman.resi,
                      monospace: true,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: skema.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: skema.surfaceContainerHigh,
                              border: Border.all(
                                color: skema.outline,
                              ),
                            ),
                            child: Text(
                              pengiriman.status,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _baris(
                      context,
                      'Gudang Asal',
                      pengiriman.asal.nama,
                    ),
                    _baris(
                      context,
                      'Kota Tujuan',
                      pengiriman.kotaTujuan,
                    ),
                    _baris(
                      context,
                      'Tanggal Kirim',
                      '${tgl.day}/${tgl.month}/${tgl.year}',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _bagian(
                  context,
                  'RINCIAN BARANG',
                  'ITEM-INFO',
                  Icons.inventory_2_outlined,
                  [
                    _baris(
                      context,
                      'Kode Barang',
                      pengiriman.barang.kode,
                      monospace: true,
                    ),
                    _baris(
                      context,
                      'Nama Barang',
                      pengiriman.barang.nama,
                    ),
                    _baris(
                      context,
                      'Jumlah',
                      '${pengiriman.jumlah} '
                      '${pengiriman.barang.satuan}',
                    ),
                    _baris(
                      context,
                      'Nilai Barang',
                      formatRupiah(
                        pengiriman.nilaiBarang,
                      ),
                      monospace: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                OutlinedButton.icon(
                  onPressed: () {
                    _konfirmasiHapus(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  label: const Text(
                    'Hapus Pengiriman',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        skema.error,
                    side: BorderSide(
                      color: skema.error,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 18,
                  ),
                  label: const Text(
                    'Kembali ke Daftar',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ketuk untuk kembali ke layar '
                  'Daftar Pengiriman',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: skema.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
