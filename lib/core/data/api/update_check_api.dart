// ignore_for_file: argument_type_not_assignable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_app_update/core/data/model/version_model.dart';

abstract class UpdateCheckApi {
  Future<String> getNewVersion(String environment);
}

class UpdateCheckApiImpl implements UpdateCheckApi {
  static final UpdateCheckApiImpl _instance = UpdateCheckApiImpl._internal();

  factory UpdateCheckApiImpl() => _instance;

  UpdateCheckApiImpl._internal();

  @override
  Future<String> getNewVersion(String environment) async {
    final uri = Uri.base.removeFragment().replace(path: '/version.json');
    final response = await http.get(uri);

    final versionModel = VersionModel.fromJson(json.decode(response.body));

    if (versionModel.version == null) return '';
    return '${versionModel.version}b${versionModel.buildNumber}${environment[0]}';
  }
}
