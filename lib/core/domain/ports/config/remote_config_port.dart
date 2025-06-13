// lib/core/domain/ports/config/remote_config_port.dart

import '../../models/config/home_section_config.dart';
import '../../models/config/app_remote_config.dart';
import '../../models/config/subcategory_section_config.dart';

abstract class RemoteConfigPort {
  Future<List<HomeSectionConfig>> getHomeSections();
  Future<List<AppRemoteConfig>> getAppConfig();
  Future<List<SubcategorySectionConfig>> getSubcategorySections(String? subcategoryId);  // Nouveau
}

