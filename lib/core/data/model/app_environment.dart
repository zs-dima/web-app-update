import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_environment.freezed.dart';
part 'app_environment.g.dart';

@freezed
class AppEnvironment with _$AppEnvironment {
  const factory AppEnvironment({
    required String version,
    required String environment,
  }) = _AppEnvironment;

  factory AppEnvironment.fromJson(Map<String, dynamic> json) => _$AppEnvironmentFromJson(json);
}
