import 'package:package_info_plus/package_info_plus.dart';
import 'package:web_app_update/core/data/api/environment_api.dart';
import 'package:web_app_update/core/data/model/app_environment.dart';
import 'package:web_app_update/core/data/model/environment_model.dart';

class EnvironmentRepository {
  final EnvironmentApi _environmentApi;

  EnvironmentRepository({
    required EnvironmentApi environmentApi,
  }) : _environmentApi = environmentApi;

  Future<AppEnvironment> loadEnvironmentVariables() async {
    final environmentModel = await _environmentApi.loadEnvironmentVariables();

    // You could pass variables with environment.json or --dart-define for debug
    final appEnvironment = (environmentModel.environment ??
            const String.fromEnvironment(EnvironmentNames.appEnvironment, defaultValue: 'unknown'))
        .toLowerCase();

    var appVersion = environmentModel.version ?? const String.fromEnvironment(EnvironmentNames.appVersion);

    if (appVersion.isEmpty) {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version}b${packageInfo.buildNumber}${appEnvironment[0]}';
    }

    return AppEnvironment(version: appVersion, environment: appEnvironment);
  }
}
