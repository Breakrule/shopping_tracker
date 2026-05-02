import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 2)
class AppSettingsModel {
  @HiveField(0)
  final int themeModeIndex;

  @HiveField(1)
  final List<String>? categories;

  AppSettingsModel({
    required this.themeModeIndex,
    this.categories,
  });

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      themeModeIndex: entity.themeMode.index,
      categories: entity.categories,
    );
  }

  AppSettings toEntity() {
    return AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      categories: categories ?? ['Groceries', 'Household', 'Health', 'Personal', 'Other'],
    );
  }
}
