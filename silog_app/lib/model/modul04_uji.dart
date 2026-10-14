
import 'barang.dart';
import 'gudang.dart';
import 'pengiriman.dart';
import 'pelanggan.dart';

void main() {
  final sepatu = Barang(
    kode: 'B-1024',
    nama: 'Sepatu Lari Pria',
    hargaSatuan: 450000,
    beratKg: 0.9,
  );

  final kaos = Barang.dariPemindaian('B-2048;Kaos Katun;85000');

  final gudangBandung = Gudang(
    kode: 'GD-BDG',
    nama: 'Gudang Utama Bandung',
    kota: 'Bandung',
    kapasitas: 500,
  );

  final pelanggan = Pelanggan(
    kode: 'PLG-001',
    nama: 'Fiqry Firmansyah',
    nomorTelepon: '081234567890',
    alamat: 'Jl. Pagarsih Gg. Pelita 1 NO53A/9B, Bandung, Jawa Barat 40173',
  );

  gudangBandung.terimaBarang(sepatu, 120);
  gudangBandung.terimaBarang(kaos, 300);

  print(gudangBandung);
  print('Rincian stok: ${gudangBandung.stok}');
  print('Data pelanggan: $pelanggan');

  final kirim = Pengiriman.baru(
    resi: 'SLG-2026-0007',
    asal: gudangBandung,
    kotaTujuan: 'Surabaya',
    barang: sepatu,
    pelanggan: pelanggan,
    jumlah: 10,
  );

  gudangBandung.keluarkanBarang(sepatu, kirim.jumlah);

  print(kirim);
  print('Nilai barang: Rp${kirim.nilaiBarang.toStringAsFixed(0)}');

  kirim.ubahStatus('Dalam Perjalanan');
  print('Status terbaru: ${kirim.status}');

  try {
    kirim.ubahStatus('Draft');
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  try {
    gudangBandung.keluarkanBarang(sepatu, 9999);
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }
}
