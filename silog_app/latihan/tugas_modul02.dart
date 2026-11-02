List<Map<String, Object>> buatDaftarKiriman() => [
  {'resi': 'SLG-001', 'berat': 3.0},
  {'resi': 'SLG-002', 'berat': 12.5},
  {'resi': 'SLG-003', 'berat': 7.2},
  {'resi': 'SLG-004', 'berat': 4.8},
  {'resi': 'SLG-005', 'berat': 18.0},
  {'resi': 'SLG-006', 'berat': 9.5},
  {'resi': 'SLG-007', 'berat': 5.0},
  {'resi': 'SLG-008', 'berat': 6.3},
];

double totalBerat(List<Map<String, Object>> kiriman) => kiriman.fold(
  0,
  (total, item) => total + (item['berat'] as double),
);

double rataRataBerat(List<Map<String, Object>> kiriman) =>
    totalBerat(kiriman) / kiriman.length;

Map<String, Object> kirimanTerberat(List<Map<String, Object>> kiriman) =>
    kiriman.reduce(
      (a, b) => (a['berat'] as double) > (b['berat'] as double) ? a : b,
    );

Map<String, Object> kirimanTeringan(List<Map<String, Object>> kiriman) =>
    kiriman.reduce(
      (a, b) => (a['berat'] as double) < (b['berat'] as double) ? a : b,
    );

String kategoriKiriman(double berat) {
  if (berat <= 5) return 'Paket Kecil';
  if (berat <= 15) return 'Paket Sedang';
  return 'Kargo';
}

Map<String, int> jumlahPerKategori(List<Map<String, Object>> kiriman) {
  final jumlah = {'Paket Kecil': 0, 'Paket Sedang': 0, 'Kargo': 0};

  for (final item in kiriman) {
    final kategori = kategoriKiriman(item['berat'] as double);
    jumlah[kategori] = jumlah[kategori]! + 1;
  }

  return jumlah;
}

void tampilkanHasil(List<Map<String, Object>> kiriman) {
  final terberat = kirimanTerberat(kiriman);
  final teringan = kirimanTeringan(kiriman);
  final kategori = jumlahPerKategori(kiriman);

  print('Total berat       : ${totalBerat(kiriman).toStringAsFixed(2)} kg');
  print('Rata-rata berat   : ${rataRataBerat(kiriman).toStringAsFixed(2)} kg');
  print('Kiriman terberat  : ${terberat['resi']} (${terberat['berat']} kg)');
  print('Kiriman teringan  : ${teringan['resi']} (${teringan['berat']} kg)');
  print('Paket Kecil       : ${kategori['Paket Kecil']} kiriman');
  print('Paket Sedang      : ${kategori['Paket Sedang']} kiriman');
  print('Kargo              : ${kategori['Kargo']} kiriman');
}

void main() {
  final kiriman = buatDaftarKiriman();
  tampilkanHasil(kiriman);
}
