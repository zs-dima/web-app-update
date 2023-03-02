import 'package:web_app_update/core/data/api/environment_api.dart';
import 'package:web_app_update/core/data/model/environment_model.dart';

class EnvironmentRepository {
  final EnvironmentApi _environmentApi;

  EnvironmentRepository({required EnvironmentApi environmentApi}) //
      : _environmentApi = environmentApi;

  Future<EnvironmentModel> loadEnvironmentVariables() => _environmentApi.loadEnvironmentVariables();
}
