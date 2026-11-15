import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import '../model/stok.dart';

class StokRepository {
  static final StokRepository instance = StokRepository._();

  StokRepository._();

  Future<Database>? _pembukaan;
  final _store = intMapStoreFactory.store('stok');

  Future<Database> get _database => _pembukaan ??= _bukaDatabase();

  Future<Database> _bukaDatabase() async {
    try {
      if (kIsWeb) {
        return await databaseFactoryWeb.openDatabase('silog.db');
      }
      final dir = await getApplicationDocumentsDirectory();
      return await databaseFactoryIo.openDatabase('${dir.path}/silog.db');
    } catch (_) {
      _pembukaan = null;
      rethrow;
    }
  }

  Future<int> simpan(Stok stok) async {
    final db = await _database;
    return _store.add(db, stok.toMap());
  }

  Future<List<Stok>> ambilSemua({
    String? kodeGudang,
    String? namaBarang,
  }) async {
    final db = await _database;
    final kataKunci = namaBarang?.trim() ?? '';
    final filter = <Filter>[
      if (kodeGudang != null) Filter.equals('kodeGudang', kodeGudang),
      if (kataKunci.isNotEmpty)
        Filter.matchesRegExp(
          'namaBarang',
          RegExp(RegExp.escape(kataKunci), caseSensitive: false),
        ),
    ];
    final finder = Finder(
      filter: filter.isEmpty ? null : Filter.and(filter),
      sortOrders: [SortOrder('namaBarang')],
    );
    final rekaman = await _store.find(db, finder: finder);
    return rekaman.map((r) => Stok.fromMap(r.key, r.value)).toList();
  }

  Future<Stok?> ambilSatu(int id) async {
    final db = await _database;
    final nilai = await _store.record(id).get(db);
    return nilai == null ? null : Stok.fromMap(id, nilai);
  }

  Future<void> perbarui(Stok stok) async {
    final id = stok.id;
    if (id == null) {
      throw ArgumentError('Data tanpa id tidak dapat diperbarui');
    }
    final db = await _database;
    await _store.record(id).update(db, stok.toMap());
  }

  Future<void> hapus(int id) async {
    final db = await _database;
    await _store.record(id).delete(db);
  }

  Future<int> totalStokGudang(String kodeGudang) async {
    final daftar = await ambilSemua(kodeGudang: kodeGudang);
    return daftar.fold<int>(0, (total, stok) => total + stok.jumlah);
  }

  Future<void> kosongkan() async {
    final db = await _database;
    await _store.delete(db);
  }
}
