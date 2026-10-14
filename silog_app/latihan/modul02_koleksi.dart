int estimasiHariSampai(String kota) {
  switch (kota.toLowerCase()) {
    case 'bandung':
    case 'jakarta':
      return 1;
    case 'yogyakarta':
    case 'surabaya':
      return 2;
    case 'medan':
    case 'makassar':
      return 3;
    case 'jayapura':
      return 5;
    default:
      return 7;
  }
}

main() {
  final Map<String, double> tarifZona = {
    'Bandung': 6000,
    'Surabaya': 8500,
    'Makassar': 14000,
    'Jayapura': 21000,
    'Medan': 12000,
    'Jakarta': 7000,
    'Yogyakarta': 8000,
  };
  final List<Map<String, Object>> kiriman = [
    {'resi': 'SLG-001', 'kota': 'Bandung', 'berat': 3.0},
    {'resi': 'SLG-002', 'kota': 'Surabaya', 'berat': 12.5},
    {'resi': 'SLG-003', 'kota': 'Makassar', 'berat': 7.2},
    {'resi': 'SLG-004', 'kota': 'Surabaya', 'berat': 4.8},
    {'resi': 'SLG-005', 'kota': 'Jayapura', 'berat': 18.0},
    {'resi': 'SLG-006', 'kota': 'Medan', 'berat': 9.5},
    {'resi': 'SLG-007', 'kota': 'Jakarta', 'berat': 5.0},
    {'resi': 'SLG-008', 'kota': 'Yogyakarta', 'berat': 6.3},
  ];
  double totalPendapatan = 0;
  final Map<String, double> rekapPerKota = {};
  for (final item in kiriman) {
    final kota = item['kota'] as String;
    final berat = item['berat'] as double;
    final tarif = tarifZona[kota] ?? 0;
    final biaya = berat * tarif;
    totalPendapatan += biaya;
    rekapPerKota[kota] = (rekapPerKota[kota] ?? 0) + biaya;
    final estimasi = estimasiHariSampai(kota);
    print(
      '${item['resi']} $kota ${berat}kg Rp${biaya.toStringAsFixed(0)} ($estimasi hari)',
    );
  }
  print('\n--- Rekapitulasi per Kota ---');
  rekapPerKota.forEach((kota, total) {
    print('$kota : Rp${total.toStringAsFixed(0)}');
  });
  print('Total pendapatan : Rp${totalPendapatan.toStringAsFixed(0)}');
}
