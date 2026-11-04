import 'dart:io';

import 'package:silog_app/layanan/layanan_pengiriman.dart';
import 'package:silog_app/layanan/moda.dart';

void main() {
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(kodeLayanan: 'TRK-REG', jarakKm: 780, beratKg: 1200),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP',
      jarakKm: 780,
      beratKg: 1200,
      ekspres: true,
    ),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    PengirimanUdara(
      kodeLayanan: 'UDR-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      panjangCm: 300,
      lebarCm: 200,
      tinggiCm: 150,
    ),
  ];

  stdout.writeln('=== Perbandingan Layanan Pengiriman ===');
  for (final layanan in daftarLayanan) {
    stdout.writeln(layanan.ringkasan());
  }

  daftarLayanan.sort((a, b) => a.hitungTarif().compareTo(b.hitungTarif()));
  stdout.writeln('\nLayanan termurah : ${daftarLayanan.first.kodeLayanan}');
  stdout.writeln(
    'Layanan tercepat : '
    '${daftarLayanan.reduce((a, b) => a.estimasiHari() <= b.estimasiHari() ? a : b).kodeLayanan}',
  );

  // Pemanfaatan mixin Terlacak
  final truk = daftarLayanan.whereType<PengirimanTruk>().first;
  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');
  stdout.writeln('\nRiwayat posisi ${truk.kodeLayanan}:');
  for (final r in truk.riwayat) {
    stdout.writeln('  $r');
  }
  stdout.writeln('Posisi terakhir: ${truk.posisiTerakhir()}');

  stdout.writeln('\n=== Pengujian Mixin Terasuransi ===');
  const nilaiBarang = 10000000.0;
  for (final layanan in daftarLayanan) {
    if (layanan is Terasuransi) {
      final asuransi = layanan as Terasuransi;
      stdout.writeln(
        '${layanan.kodeLayanan} | Premi ${asuransi.persentasePremi}%: '
        'Rp${asuransi.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
      );
    } else {
      stdout.writeln(
        '${layanan.kodeLayanan} tidak memiliki metode hitungPremi().',
      );
    }
  }

  // Buka komentar berikut untuk mengamati error compiler pada truk:
  // truk.hitungPremi(nilaiBarang);
}
