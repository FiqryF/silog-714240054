import 'dart:io';

class ResiTidakDitemukan implements Exception {
  final String resi;

  ResiTidakDitemukan(this.resi);

  @override
  String toString() => 'Resi $resi tidak ditemukan.';
}

final Map<String, String> dataStatusKiriman = {
  'SLG-001': 'sedang dalam perjalanan menuju gudang transit.',
  'SLG-002': 'sedang diproses di gudang.',
  'SLG-003': 'sedang dikirim ke alamat tujuan.',
  'SLG-004': 'telah sampai di kota tujuan.',
  'SLG-005': 'telah diterima oleh penerima.',
};

Future<String> ambilStatusKiriman(String resi) async {
  await Future.delayed(const Duration(seconds: 2));

  final status = dataStatusKiriman[resi];

  if (status == null) {
    throw ResiTidakDitemukan(resi);
  }

  return 'Paket $resi $status';
}

Future<double> ambilOngkir(String resi) async {
  await Future.delayed(const Duration(seconds: 1));
  return 105400;
}

Future<void> bandingkanWaktu() async {
  final mulai = DateTime.now();

  final hasil = await Future.wait([
    ambilStatusKiriman('SLG-001'),
    ambilOngkir('SLG-001'),
  ]);

  final durasi = DateTime.now().difference(mulai);

  stdout.writeln('Status : ${hasil[0]}');
  stdout.writeln('Ongkir : ${hasil[1]}');
  stdout.writeln('Durasi total: ${durasi.inMilliseconds} ms');
}

Future<void> pantauBanyakResi(List<String> daftarResi) async {
  final proses = daftarResi.map((resi) async {
    try {
      final status = await ambilStatusKiriman(resi);
      stdout.writeln('Berhasil: $status');
    } on ResiTidakDitemukan catch (e) {
      stdout.writeln('Gagal: $e');
    }
  });

  await Future.wait(proses);
}

Future<void> main() async {
  stdout.writeln('1. Permintaan data dikirim...');

  try {
    final status = await ambilStatusKiriman('SLG-002');
    stdout.writeln('2. $status');

    final ongkir = await ambilOngkir('SLG-002');
    stdout.writeln('3. Ongkos kirim: Rp${ongkir.toStringAsFixed(0)}');
  } on ResiTidakDitemukan catch (e) {
    stdout.writeln('Peringatan: $e');
  } catch (e) {
    stdout.writeln('Gagal mengambil data: $e');
  }

  stdout.writeln('4. Proses selesai.');

  await bandingkanWaktu();

  await pantauBanyakResi([
    'SLG-001',
    'SLG-002',
    'SLG-003',
    'SLG-004',
    'SLG-005',
  ]);
}
