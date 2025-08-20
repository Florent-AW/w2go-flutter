// core/domain/repositories/settings_repository.dart

abstract class SettingsRepository {
  Stream<bool> watchFlag(String key, {bool defaultValue = true});
  Future<bool> getFlag(String key, {bool defaultValue = true});
  Future<void> setFlag(String key, bool value);
}
