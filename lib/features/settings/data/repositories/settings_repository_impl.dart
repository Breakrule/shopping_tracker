import 'package:hive/hive.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final Box<AppSettingsModel> _box;
  static const String _settingsKey = 'app_settings';

  SettingsRepositoryImpl(this._box);

  @override
  Future<AppSettings> getSettings() async {
    final model = _box.get(_settingsKey);
    return model?.toEntity() ?? const AppSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_settingsKey, AppSettingsModel.fromEntity(settings));
  }
}
