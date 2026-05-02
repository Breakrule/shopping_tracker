import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Vibrant Indigo
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E2C),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F17),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E2C),
          elevation: 8,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
