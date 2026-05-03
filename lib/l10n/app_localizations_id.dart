// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Pelacak Belanja Bulanan';

  @override
  String get homeTitle => 'Daftar Belanjaku';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get noListsYet => 'Perjalanan belanjamu dimulai di sini';

  @override
  String get noListsSub =>
      'Buat daftar pertamamu untuk mengatur belanja bulanan dengan presisi.';

  @override
  String get addList => 'Buat Daftar Baru';

  @override
  String get listName => 'Nama Daftar (misal: Mei 2024)';

  @override
  String get budget => 'Anggaran Bulanan (Opsional)';

  @override
  String get cancel => 'Batal';

  @override
  String get create => 'Buat';

  @override
  String get deleteList => 'Hapus Daftar?';

  @override
  String get deleteListConfirm =>
      'Ini akan menghapus semua item dalam daftar ini. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get delete => 'Hapus';

  @override
  String get items => 'item';

  @override
  String get totalSpent => 'Total Pengeluaran';

  @override
  String get overBudget => 'MELEBIHI ANGGARAN';

  @override
  String get insights => 'Wawasan Pengeluaran';

  @override
  String get aisleView => 'Tampilan Kategori';

  @override
  String get listView => 'Tampilan Daftar';

  @override
  String get noItemsYet => 'Daftar ini kosong';

  @override
  String get noItemsSub =>
      'Tambah item yang perlu dibeli dan kami akan membantu melacak pengeluaranmu.';

  @override
  String get newItem => 'Item Baru';

  @override
  String get itemName => 'Nama Item';

  @override
  String get category => 'Kategori';

  @override
  String get quantity => 'Jumlah';

  @override
  String get price => 'Harga';

  @override
  String suggestion(String price) {
    return 'Saran: Rp $price';
  }

  @override
  String get addToList => 'Tambah ke Daftar';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeMode => 'Mode Tema';

  @override
  String get categories => 'Kategori';

  @override
  String get addCustomCategory => 'Tambah Kategori Kustom';

  @override
  String get development => 'Pengembangan';

  @override
  String get seedData => 'Isi Data Dummy';

  @override
  String get dummyDataSuccess => 'Data dummy berhasil diisi!';

  @override
  String get systemDefault => 'Default Sistem';

  @override
  String get lightMode => 'Mode Terang';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get selectTheme => 'Pilih Tema';

  @override
  String get newCategory => 'Kategori Baru';

  @override
  String get categoryName => 'Nama kategori';

  @override
  String get add => 'Tambah';

  @override
  String get required => 'Wajib diisi';

  @override
  String get minQuantity => 'Min 1';
}
