// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  // Name of the environment type variable
  const envSettingName = 'app_environment';

  // Path to the Nginx container web root
  const webRoot = '/usr/share/nginx/html';

  // Environment json file name and location
  const envFileName = 'environment.json';
  const envJsonPath = '$webRoot/assets/asset/$envFileName';

  // Locations of the Web application files we are going to update
  const indexHtmlPath = '$webRoot/index.html';
  const flutterJsPath = '$webRoot/flutter.js';
  const workerJsPath = '$webRoot/flutter_service_worker.js';
  const versionJsonPath = '$webRoot/version.json';

  // Lets use staging as default environment
  var appEnvironment = 'staging';

  final envJson = <String, Object>{};
  // Iterate over all arguments and add compose environment variables json
  for (final argument in arguments) {
    // We are expecting arguments in format: name=value, without spaces around '='
    if (argument.contains('=')) {
      final split = argument.split('=');
      final arg = split.first.toLowerCase();
      final value = split.last;
      if (arg.isEmpty || value.isEmpty) {
        continue;
      }

      // Try to parse variable type
      if (int.tryParse(value) != null) {
        envJson[arg] = int.parse(value);
      } else if (double.tryParse(value) != null) {
        envJson[arg] = double.parse(value);
      } else if (value.toLowerCase() == 'true') {
        envJson[arg] = true;
      } else if (value.toLowerCase() == 'false') {
        envJson[arg] = false;
      } else {
        envJson[arg] = value;
      }

      // Store environment type if it is specified
      if (arg == envSettingName) {
        appEnvironment = value;
      }
    }
  }

  // Compose app version by adding build_number and environment type
  final versionJsonFile = File(versionJsonPath);
  final versionJson = jsonDecode(await versionJsonFile.readAsString());
  final appVersion = '${versionJson['version']}b${versionJson['build_number']}${appEnvironment[0]}'.trim();

  // Save environment json file
  final envFile = File(envJsonPath);
  final envFileContent = const JsonEncoder.withIndent('    ').convert(envJson);
  // MD5 always going to be new, but you could use md5.convert(utf8.encode(envFileContent)).toString(); as well
  final envFileMd5 = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  await envFile.writeAsString(envFileContent);

  // Update flutter.js file by specifying app version to the main.dart.js and flutter_service_worker.js files
  final flutterJsFile = File(flutterJsPath);
  final flutterJsContent = await flutterJsFile.readAsString();
  final flutterJsReplaced = flutterJsContent
      .replaceAll('main.dart.js', 'main.dart.js?$appVersion')
      .replaceAll('flutter_service_worker.js?v=', 'flutter_service_worker.js?v=$appVersion');
  if (flutterJsContent != flutterJsReplaced) {
    await flutterJsFile.writeAsString(flutterJsReplaced);
  }

  // Update index.html file by specifying app version to the flutter.js file
  final indexHtmlFile = File(indexHtmlPath);
  final indexHtml = await indexHtmlFile.readAsString();
  final indexHtmlReplaced = indexHtml.replaceAll('"flutter.js"', '"flutter.js?$appVersion"');
  if (indexHtml != indexHtmlReplaced) {
    await indexHtmlFile.writeAsString(indexHtmlReplaced);
  }

  // Update flutter_service_worker.js file by specifying environment.json MD5 hash
  final workerJsFile = File(workerJsPath);
  final workerJsContent = await workerJsFile.readAsString();
  final workerJsReplaced = workerJsContent.replaceAll(
    RegExp('"assets/asset/$envFileName": "[0-9a-f]{32}"'),
    '"assets/asset/$envFileName": "$envFileMd5"',
  );
  if (workerJsContent != workerJsReplaced) {
    await workerJsFile.writeAsString(workerJsReplaced);
  }
}
