import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_update/core/data/api/environment_api.dart';
import 'package:web_app_update/core/data/api/update_check_api.dart';
import 'package:web_app_update/core/data/repository/environment_repository.dart';
import 'package:web_app_update/core/data/repository/update_check_repository.dart';
import 'package:web_app_update/future/home/home_page.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Web auto-update Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MultiProvider(
          providers: [
            Provider<EnvironmentRepository>(
              create: (_) => EnvironmentRepository(
                environmentApi: EnvironmentApiImpl(),
              ),
            ),
            Provider<UpdateCheckRepository>(
              create: (_) => UpdateCheckRepository(
                updateCheckApi: UpdateCheckApiImpl(),
              ),
            ),
          ],
          child: const HomePage(title: 'Flutter Web auto-update Demo'),
        ),
      );
}
