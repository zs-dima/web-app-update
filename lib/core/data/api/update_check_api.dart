// ignore_for_file: argument_type_not_assignable, avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_app_update/core/data/model/version_model.dart';

abstract class UpdateCheckApi {
  Future<String> getNewVersion(String environment);
  Future<void> updateApplication();
  Future<void> tryReloadApplication();
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

  @override
  Future<void> updateApplication() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('wait_update', true);

    html.window.location.reload();
  }

  @override
  Future<void> tryReloadApplication() async {
    final preferences = await SharedPreferences.getInstance();
    final waitUpdate = preferences.getBool('wait_update') ?? false;
    if (!waitUpdate) return;

    await preferences.setBool('wait_update', false);

    html.window.location.reload();
  }
}
