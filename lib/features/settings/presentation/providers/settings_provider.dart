import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings.dart';
import 'settings_repository_provider.dart';

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repository = ref.watch(settingsRepositoryProvider);
    return await repository.getSettings();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(themeMode: mode);
    
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveSettings(newSettings);
      return newSettings;
    });
  }

  Future<void> addCategory(String category) async {
    final currentSettings = state.value ?? const AppSettings();
    if (currentSettings.categories.contains(category)) return;
    
    final newSettings = currentSettings.copyWith(
      categories: [...currentSettings.categories, category],
    );
    
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveSettings(newSettings);
      return newSettings;
    });
  }

  Future<void> deleteCategory(String category) async {
    final currentSettings = state.value ?? const AppSettings();
    final newSettings = currentSettings.copyWith(
      categories: currentSettings.categories.where((c) => c != category).toList(),
    );
    
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveSettings(newSettings);
      return newSettings;
    });
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});
