import 'package:web_app_update/core/data/api/update_check_api.dart';

class UpdateCheckRepository {
  final UpdateCheckApi _updateCheckApi;

  UpdateCheckRepository({required UpdateCheckApi updateCheckApi}) //
      : _updateCheckApi = updateCheckApi;

  Future<String> getNewVersion(String environment) => _updateCheckApi.getNewVersion(environment);

  Future<void> updateApplication() => _updateCheckApi.updateApplication();

  Future<void> tryReloadApplication() => _updateCheckApi.tryReloadApplication();
}
