import 'package:flutter/material.dart';

import '../model/pengiriman.dart';

class KartuPengiriman extends StatelessWidget {
  final Pengiriman pengiriman;
  final VoidCallback onTap;

  const KartuPengiriman({
    super.key,
    required this.pengiriman,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: skema.surfaceContainerHigh,
                      border: Border.all(color: skema.outlineVariant),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No. Resi',
                          style: TextStyle(
                            fontSize: 10,
                            color: skema.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pengiriman.resi,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: skema.surfaceContainerHigh,
                      border: Border.all(color: skema.outline),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      pengiriman.status,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
              const Divider(height: 26),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Barang & Jumlah',
                          style: TextStyle(
                            fontSize: 10,
                            color: skema.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${pengiriman.barang.nama} × ${pengiriman.jumlah}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rute Pengiriman',
                          style: TextStyle(
                            fontSize: 10,
                            color: skema.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${pengiriman.asal.kota} → ${pengiriman.kotaTujuan}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
