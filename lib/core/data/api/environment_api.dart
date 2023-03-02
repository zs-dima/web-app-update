// ignore_for_file: argument_type_not_assignable

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web_app_update/core/data/model/environment_model.dart';
import 'package:web_app_update/core/gen/const/assets.gen.dart';

abstract class EnvironmentApi {
  Future<EnvironmentModel> loadEnvironmentVariables();
}

class EnvironmentApiImpl implements EnvironmentApi {
  static final EnvironmentApiImpl _instance = EnvironmentApiImpl._internal();

  factory EnvironmentApiImpl() => _instance;

  EnvironmentApiImpl._internal();

  @override
  Future<EnvironmentModel> loadEnvironmentVariables() async {
    final envJson = await rootBundle.loadString(Assets.environment);
    return EnvironmentModel.fromJson(json.decode(envJson));
  }
}
