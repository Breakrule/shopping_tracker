import 'package:flutter/material.dart';

class AppSettings {
  final ThemeMode themeMode;
  final List<String> categories;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.categories = const ['Groceries', 'Household', 'Health', 'Personal', 'Other'],
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    List<String>? categories,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      categories: categories ?? this.categories,
    );
  }
}
