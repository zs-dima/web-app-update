.PHONY: init build-android build-web build-ios pigeon deploy serve

init:
	@npm install -g firebase-tools
	@firebase init
	-firebase login
	@flutter pub global activate flutter_gen
	@dart pub global activate flutterfire_cli
	@flutterfire configure \
		-i com.test \
		-m com.test \
		-a com.test \
		-p osek \
		-e belojar@gmail.com \
		-o lib/app/constant/firebase.options.g.dart

build-android: clean
	@echo "Building Android APK"
	@fvm flutter build apk --no-pub --no-shrink
    #@flutter build apk --release --tree-shake-icons --no-shrink
    #--target-platform android-x64 --shrink // --split-per-abi  --target-platform android-x86,android-arm,android-arm64
    #flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --release

build-web: clean
	@echo "Building Web app"
	@fvm flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --no-pub --no-source-maps --pwa-strategy offline-first
    #@flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true --no-source-maps --pwa-strategy offline-first
    #--web-renderer auto --base-href /

build-ios: clean
	@echo "Building iOS IPA"
	@fvm flutter build ipa --no-pub

#pigeon: pub-get
#	@echo "Running pigeon codegeneration"
#	flutter pub run pigeon \
#      --input pigeon/***.dart \
#      --copyright_header pigeon/copyright.txt \
#      --dart_out lib/***/***.pg.dart \
#      --objc_header_out ios/Runner/pigeon/***.h \
#      --objc_source_out ios/Runner/pigeon/***.m \
#      --java_out ./android/app/src/main/java/dev/pigeon/***.java \
#      --java_package "dev.flutter.pigeon" \
#      --dart_null_safety

deploy:
	@firebase deploy

serve:
	@firebase serve --only hosting -p 80
 
 