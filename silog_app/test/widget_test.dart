import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silog_app/main.dart';
import 'package:silog_app/tampilan/detail_pengiriman_page.dart';
import 'package:silog_app/widget/kartu_pengiriman.dart';

void main() {
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
