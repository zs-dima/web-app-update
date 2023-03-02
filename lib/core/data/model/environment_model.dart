// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'environment_model.freezed.dart';
part 'environment_model.g.dart';

@freezed
class EnvironmentModel with _$EnvironmentModel {
  const factory EnvironmentModel({
    @JsonKey(name: EnvironmentNames.appVersion) String? version,
    @JsonKey(name: EnvironmentNames.appEnvironment) String? environment,
  }) = _EnvironmentModel;

  factory EnvironmentModel.fromJson(Map<String, dynamic> json) => _$EnvironmentModelFromJson(json);
}

class EnvironmentNames {
  static const appEnvironment = 'app_environment';
  static const appVersion = 'app_version';
}
