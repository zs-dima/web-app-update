// ignore_for_file: use_build_context_synchronously, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_app_update/core/data/model/environment_model.dart';
import 'package:web_app_update/core/data/repository/environment_repository.dart';
import 'package:web_app_update/core/data/repository/update_check_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _appVersion;
  String? _appEnvironment;

  Future<String> _loadEnvironmentVariables() async {
    final environmentRepository = context.read<EnvironmentRepository>();
    final environmentModel = await environmentRepository.loadEnvironmentVariables();

    const warning = 'You could pass variables with\r\nenvironment.json or\r\n--dart-define for debug';
    _appEnvironment = (environmentModel.environment ??
            const String.fromEnvironment(EnvironmentNames.appEnvironment, defaultValue: warning))
        .toLowerCase();

    _appVersion =
        environmentModel.version ?? const String.fromEnvironment(EnvironmentNames.appVersion, defaultValue: warning);

    return _appVersion!;
  }

  Future _checkForUpdate(BuildContext context) async {
    HapticFeedback.mediumImpact().ignore();

    final updateCheckRepository = context.read<UpdateCheckRepository>();
    final newVersion = await updateCheckRepository.getNewVersion(_appEnvironment!);

    final snackBar = newVersion.isEmpty || _appVersion == newVersion
        ? const SnackBar(content: Text('The latest version already installed'))
        : SnackBar(
            content: Text('New version available: $newVersion, press "Update" to install'),
            action: SnackBarAction(
              label: 'Update',
              onPressed: () {
                html.window.location.reload();
              },
            ),
          );

    if (!context.mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger != null) scaffoldMessenger.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder(
            future: _loadEnvironmentVariables(),
            builder: (context, snapshot) => snapshot.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Environment type:'),
                      Text(
                        _appEnvironment ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      const Text('Application version:'),
                      Text(
                        _appVersion ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            icon: const Icon(Icons.update),
            onPressed: () => _checkForUpdate(context),
            tooltip: 'Check for update',
            label: const Text('Check for update'),
          ),
        ),
      );
}
