.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: setup
setup: ## Initial project setup
	flutter pub get
	cd ios && pod install
	@echo "Setup complete! Don't forget to:"
	@echo "1. Copy .env.example to .env and fill in your values"
	@echo "2. Configure Firebase using 'make firebase-setup'"

.PHONY: firebase-setup
firebase-setup: ## Configure Firebase for the project
	dart pub global activate flutterfire_cli
	flutterfire configure
	firebase deploy --only firestore:rules,storage:rules

.PHONY: clean
clean: ## Clean build artifacts
	flutter clean
	cd ios && rm -rf Pods Podfile.lock
	cd android && ./gradlew clean
	rm -rf .dart_tool .packages pubspec.lock

.PHONY: deps
deps: ## Get Flutter dependencies
	flutter pub get

.PHONY: upgrade-deps
upgrade-deps: ## Upgrade Flutter dependencies
	flutter pub upgrade

.PHONY: format
format: ## Format code
	dart format .

.PHONY: format-check
format-check: ## Check code formatting
	dart format --set-exit-if-changed .

.PHONY: analyze
analyze: ## Analyze code
	flutter analyze

.PHONY: lint
lint: format-check analyze ## Run all linting

.PHONY: test
test: ## Run all tests
	flutter test --coverage

.PHONY: test-unit
test-unit: ## Run unit tests
	flutter test test/

.PHONY: test-widget
test-widget: ## Run widget tests
	flutter test test/widgets/

.PHONY: test-integration
test-integration: ## Run integration tests
	flutter test integration_test/

.PHONY: coverage
coverage: test ## Generate test coverage report
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

.PHONY: run-dev
run-dev: ## Run app in development mode
	flutter run --dart-define=ENVIRONMENT=development

.PHONY: run-staging
run-staging: ## Run app in staging mode
	flutter run --dart-define=ENVIRONMENT=staging

.PHONY: run-prod
run-prod: ## Run app in production mode
	flutter run --release --dart-define=ENVIRONMENT=production

.PHONY: build-apk
build-apk: ## Build Android APK
	flutter build apk --release --split-per-abi

.PHONY: build-aab
build-aab: ## Build Android App Bundle
	flutter build appbundle --release

.PHONY: build-ios
build-ios: ## Build iOS app
	flutter build ios --release

.PHONY: build-ipa
build-ipa: build-ios ## Build iOS IPA
	cd ios && xcodebuild -workspace Runner.xcworkspace \
		-scheme Runner \
		-sdk iphoneos \
		-configuration Release \
		-archivePath build/Runner.xcarchive \
		archive
	cd ios && xcodebuild -exportArchive \
		-archivePath build/Runner.xcarchive \
		-exportOptionsPlist ExportOptions.plist \
		-exportPath build/ipa

.PHONY: build-web
build-web: ## Build for web
	flutter build web --release

.PHONY: build-all
build-all: build-aab build-ipa build-web ## Build for all platforms

.PHONY: deploy-android-internal
deploy-android-internal: build-aab ## Deploy to Google Play internal track
	@echo "Uploading to Google Play Console internal track..."
	fastlane supply --aab build/app/outputs/bundle/release/app-release.aab --track internal

.PHONY: deploy-ios-testflight
deploy-ios-testflight: build-ipa ## Deploy to TestFlight
	@echo "Uploading to TestFlight..."
	fastlane pilot upload --ipa ios/build/ipa/Runner.ipa

.PHONY: icons
icons: ## Generate app icons
	flutter pub run flutter_launcher_icons:main

.PHONY: splash
splash: ## Generate splash screens
	flutter pub run flutter_native_splash:create

.PHONY: doctor
doctor: ## Check Flutter environment
	flutter doctor -v

.PHONY: devices
devices: ## List connected devices
	flutter devices

.PHONY: logs
logs: ## Show device logs
	flutter logs

.PHONY: install-hooks
install-hooks: ## Install git hooks
	@echo "#!/bin/sh" > .git/hooks/pre-commit
	@echo "make lint" >> .git/hooks/pre-commit
	@echo "make test" >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Git hooks installed!"

.PHONY: security-check
security-check: ## Run security checks
	dart pub global activate pana
	pana --no-warning --exit-code-threshold 0

.PHONY: bundle-check
bundle-check: ## Analyze app bundle size
	flutter build apk --analyze-size --target-platform android-arm64

.PHONY: performance
performance: ## Run performance profiling
	flutter run --profile

.PHONY: firebase-deploy
firebase-deploy: ## Deploy Firebase rules and functions
	firebase deploy --only firestore:rules,storage:rules,functions

.PHONY: generate-models
generate-models: ## Generate model classes from JSON
	flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: watch-models
watch-models: ## Watch and regenerate model classes
	flutter pub run build_runner watch --delete-conflicting-outputs

.PHONY: localize
localize: ## Generate localization files
	flutter gen-l10n

.PHONY: screenshots
screenshots: ## Take app screenshots for stores
	flutter screenshot

.PHONY: release-notes
release-notes: ## Generate release notes
	@echo "Generating release notes..."
	git log --pretty=format:"- %s" $(shell git describe --tags --abbrev=0)..HEAD > RELEASE_NOTES.md
	@echo "Release notes saved to RELEASE_NOTES.md"

.PHONY: bump-version
bump-version: ## Bump app version
	@read -p "Enter new version (current: $(shell grep 'version:' pubspec.yaml | sed 's/version: //')): " version; \
	sed -i '' "s/version: .*/version: $$version/" pubspec.yaml; \
	echo "Version bumped to $$version"

.PHONY: env-check
env-check: ## Check environment configuration
	@echo "Checking environment configuration..."
	@test -f .env || (echo "❌ .env file not found" && exit 1)
	@echo "✅ Environment configuration OK"

.PHONY: pre-release
pre-release: lint test security-check ## Run all checks before release
	@echo "✅ All pre-release checks passed!"

.PHONY: release
release: pre-release bump-version build-all ## Full release process
	@echo "🚀 Release build complete!"
	@echo "Next steps:"
	@echo "1. Deploy to app stores using 'make deploy-android-internal' and 'make deploy-ios-testflight'"
	@echo "2. Create a git tag: git tag v$(shell grep 'version:' pubspec.yaml | sed 's/version: //')"
	@echo "3. Push the tag: git push origin --tags"