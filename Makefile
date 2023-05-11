.PHONY: setup
setup:
	use stable
	 fvm flutter upgrade
	 fvm flutter pub get
	cd ios/ && pod install && cd ..

.PHONY: dependencies
dependencies:
	fvm flutter clean &&  fvm flutter pub get dependencies &&  fvm flutter packages get

.PHONY: run
run:
	fvm flutter run --flavor development --target lib/main_development.dart --verbose

.PHONY: analyze
analyze:
	fvm flutter analyze

.PHONY: format
format:
	dart format -l 80 lib/

.PHONY: build
build:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: watch
watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

.PHONY: unit-test
unit-test:
	fvm flutter test --coverage --coverage-path=./coverage/lcov.info

.PHONY: invalidate-cache
invalidate-cache:
	android/gradlew cleanBuildCache

.PHONY: staging
staging:
	fvm flutter run --release --flavor staging --target lib/main_staging.dart

.PHONY: production
production:
	fvm flutter run --release --flavor production --target lib/main_production.dart

.PHONY: development
development:
	fvm flutter run --release --flavor development --target lib/main_development.dart

.PHONY: build-dev-apk
build-dev-apk:
	fvm flutter clean
	fvm flutter pub get
	fvm flutter pub run build_runner build --delete-conflicting-outputs
	dart format -l 80 lib/
	fvm flutter build apk --release --split-per-abi --flavor development --target lib/main_development.dart

.PHONY: build-prod-apk
build-prod-apk:
	fvm flutter clean
	fvm flutter pub get
	fvm flutter pub run build_runner build --delete-conflicting-outputs
	dart format -l 80 lib/
	fvm flutter build apk --release --split-per-abi --flavor production --target lib/main_production.dart

.PHONY: bundle
bundle:
	fvm flutter clean
	fvm flutter pub get
	fvm flutter pub run build_runner build --delete-conflicting-outputs
	dart format -l 80 lib/
	fvm flutter build appbundle --flavor production --target lib/main_production.dart

.PHONY: delivery
delivery:
	fvm flutter clean
	fvm flutter pub get
	fvm flutter pub run build_runner build --delete-conflicting-outputs
	fvm format -l 80 lib/
	fvm flutter build apk --release --split-per-abi --flavor production --target lib/main_production.dart
	fvm flutter build appbundle --flavor production --target lib/main_production.dart