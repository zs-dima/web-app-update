// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
class VersionModel with _$VersionModel {
  const factory VersionModel({
    @JsonKey(name: 'app_name') String? appName,
    @JsonKey(name: 'version') String? version,
    @JsonKey(name: 'build_number') String? buildNumber,
    @JsonKey(name: 'package_name') String? packageName,
  }) = _VersionModel;

  factory VersionModel.fromJson(Map<String, dynamic> json) => _$VersionModelFromJson(json);
}
