import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monthly_shop_tracker/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/settings/data/models/app_settings_model.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/shopping/data/models/item_model.dart';
import 'features/shopping/data/models/shopping_list_model.dart';
import 'features/shopping/presentation/screens/splash_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(ShoppingListModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(AppSettingsModelAdapter());

  // Open Boxes with migration/reset handling
  try {
    await Hive.openBox<ShoppingListModel>('shopping_lists');
    await Hive.openBox<ItemModel>('items');
    await Hive.openBox<AppSettingsModel>('settings');
  } catch (e) {
    debugPrint('Hive initialization error, resetting boxes: $e');
    // If opening fails (e.g. due to schema changes), clear and retry
    await Hive.deleteBoxFromDisk('shopping_lists');
    await Hive.deleteBoxFromDisk('items');
    await Hive.deleteBoxFromDisk('settings');
    
    // Give the file system a moment to breathe
    await Future.delayed(const Duration(milliseconds: 200));
    
    await Hive.openBox<ShoppingListModel>('shopping_lists');
    await Hive.openBox<ItemModel>('items');
    await Hive.openBox<AppSettingsModel>('settings');
  }

  // Run app with Riverpod ProviderScope
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final themeMode = settingsAsync.value?.themeMode ?? ThemeMode.system;

    return MaterialApp(
      title: 'Monthly Shop Tracker',
      themeMode: themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: -1),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: -0.5),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          primary: const Color(0xFF818CF8),
          surface: const Color(0xFF1E1E2C),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F17),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E2C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: -1),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: -0.5),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
          surface: const Color(0xFFF8F9FE),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: const Color(0xFF6366F1).withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
