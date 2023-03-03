// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_app_update/core/data/model/app_environment.dart';
import 'package:web_app_update/core/data/repository/environment_repository.dart';
import 'package:web_app_update/core/data/repository/update_check_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppEnvironment _appEnvironment;

  Future<String> _loadEnvironmentVariables() async {
    _appEnvironment = await context.read<EnvironmentRepository>().loadEnvironmentVariables();

    // Check for update after application loaded
    final updateCheckRepository = context.read<UpdateCheckRepository>();
    final newVersion = await updateCheckRepository.getNewVersion(_appEnvironment.environment);
    if (newVersion != null && _appEnvironment.version != newVersion) {
      // Try to reload website second time after application updated,
      // as first reload updates scripts only
      await updateCheckRepository.tryReloadApplication();
    }

    return _appEnvironment.version;
  }

  Future _checkForUpdate(BuildContext context) async {
    HapticFeedback.mediumImpact().ignore();

    final updateCheckRepository = context.read<UpdateCheckRepository>();
    final newVersion = await updateCheckRepository.getNewVersion(_appEnvironment.environment);

    final snackBar = newVersion == null || _appEnvironment.version == newVersion
        ? const SnackBar(content: Text('The latest version already installed'))
        : SnackBar(
            content: Text('New version available: $newVersion, press "Update" to install'),
            action: SnackBarAction(
              label: 'Update',
              onPressed: updateCheckRepository.updateApplication,
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
                        _appEnvironment.environment,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      const Text('Application version:'),
                      Text(
                        _appEnvironment.version,
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
            label: const Text('Check for update'),
          ),
        ),
      );
}
