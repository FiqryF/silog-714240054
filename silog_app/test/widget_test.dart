import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silog_app/main.dart';
import 'package:silog_app/model/stok.dart';
import 'package:silog_app/tampilan/detail_pengiriman_page.dart';
import 'package:silog_app/tampilan/form_stok_page.dart';
import 'package:silog_app/widget/kartu_pengiriman.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('mode gelap diterapkan dan dimuat ulang dari preferensi', (
    tester,
  ) async {
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Aktifkan mode gelap'));
    await tester.pumpAndSettle();
    final preferensi = await SharedPreferences.getInstance();
    expect(preferensi.getBool('mode_gelap'), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();
    final konteks = tester.element(find.text('Daftar Pengiriman'));
    expect(Theme.of(konteks).brightness, Brightness.dark);

    await tester.tap(find.byTooltip('Aktifkan mode terang'));
    await tester.pumpAndSettle();
    expect(Theme.of(konteks).brightness, Brightness.light);
    expect(preferensi.getBool('mode_gelap'), isFalse);
  });

  testWidgets('form stok menolak data kosong dan mengembalikan data valid', (
    tester,
  ) async {
    Stok? stok;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  stok = await Navigator.push<Stok>(
                    context,
                    MaterialPageRoute<Stok>(
                      builder: (_) => const FormStokPage(kodeGudang: 'GD-BDG'),
                    ),
                  );
                },
                child: const Text('Buka form'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Buka form'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan Stok'));
    await tester.pumpAndSettle();
    expect(find.text('Kode barang wajib diisi'), findsOneWidget);
    expect(find.text('Nama barang wajib diisi'), findsOneWidget);
    expect(find.text('Jumlah wajib diisi'), findsOneWidget);

    final field = find.byType(TextFormField);
    await tester.enterText(field.at(0), ' B-001 ');
    await tester.enterText(field.at(1), ' Kardus A.1 ');
    for (final tidakSah in ['0', '-1', '1.5']) {
      await tester.enterText(field.at(2), tidakSah);
      await tester.pumpAndSettle();
      expect(find.textContaining('bilangan bulat positif'), findsOneWidget);
    }
    await tester.enterText(field.at(2), '10');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan Stok'));
    await tester.pumpAndSettle();
    expect(stok?.kodeBarang, 'B-001');
    expect(stok?.namaBarang, 'Kardus A.1');
    expect(stok?.kodeGudang, 'GD-BDG');
    expect(stok?.jumlah, 10);
  });

  test('format rupiah memakai pemisah ribuan', () {
    expect(formatRupiah(24325000), 'Rp24.325.000');
    expect(formatRupiah(4500000), 'Rp4.500.000');
    expect(formatRupiah(0), 'Rp0');
  });

  for (final width in [400.0, 1280.0]) {
    testWidgets('filter dan navigasi pada lebar $width', (tester) async {
      tester.view.physicalSize = Size(width, 860);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const SiLogApp());
      await tester.pumpAndSettle();

      expect(find.byType(KartuPengiriman), findsNWidgets(3));
      expect(find.text('Rp24.325.000'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.widgetWithText(Tab, 'Dalam Perjalanan'));
      await tester.pumpAndSettle();
      expect(find.byType(KartuPengiriman), findsOneWidget);
      expect(find.text('SLG-2026-0001'), findsOneWidget);
      expect(find.text('SLG-2026-0002'), findsNothing);
      expect(find.text('SLG-2026-0003'), findsNothing);
      expect(find.text('Rp24.325.000'), findsOneWidget);

      await tester.tap(find.widgetWithText(Tab, 'Diterima'));
      await tester.pumpAndSettle();
      expect(find.byType(KartuPengiriman), findsOneWidget);
      expect(find.text('SLG-2026-0003'), findsOneWidget);
      expect(find.text('SLG-2026-0001'), findsNothing);

      await tester.tap(find.widgetWithText(Tab, 'Semua'));
      await tester.pumpAndSettle();
      expect(find.byType(KartuPengiriman), findsNWidgets(3));
      await tester.tap(find.text('SLG-2026-0001'));
      await tester.pumpAndSettle();
      expect(find.byType(DetailPengirimanPage), findsOneWidget);
      expect(find.text('Surabaya'), findsOneWidget);
      expect(find.text('Rp4.500.000'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Kembali ke Daftar'));
      await tester.tap(find.text('Kembali ke Daftar'));
      await tester.pumpAndSettle();
      expect(find.byType(KartuPengiriman), findsNWidgets(3));

      await tester.tap(find.text('SLG-2026-0003'));
      await tester.pumpAndSettle();
      expect(find.text('Medan'), findsOneWidget);
      expect(find.text('Rp9.625.000'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(KartuPengiriman), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }
}
