# vintage_app

A Flutter application (project name: `vintage_app`).

This README documents how to set up, build, run, and contribute to the project across mobile, web, and desktop targets.

---

## Project summary

- Purpose: Starter Flutter application containing multiple screens, custom fonts, and a cross-platform runner for mobile, web, and desktop.
- Tech stack: Flutter (Dart), Android (Gradle/Kotlin), iOS (Xcode/Swift), Windows (CMake/Visual Studio), macOS (Xcode), Linux (CMake).
- Entry point: `lib/main.dart` (routes and layout live under `lib/core/` and `lib/screens/`).

---

## Detected versions & repository hints

Detected from project files in this repository:

- Dart SDK constraint: `^3.10.7` (from `pubspec.yaml`).
- Flutter SDK (lockfile hint): `>=3.27.0` (see `pubspec.lock`).
- Gradle wrapper: `gradle-8.14` (from `android/gradle/wrapper/gradle-wrapper.properties`).
- Java compatibility: Java 17 (see `android/app/build.gradle.kts`).
- AndroidX: enabled (see `android/gradle.properties`).
- Fonts declared: `Inter` and `Montserrat` (registered in `pubspec.yaml`).
- Assets present under `assets/images/` and `assets/fonts/`.

Notes: some Android SDK values are delegated to the Flutter tool (e.g., `flutter.compileSdkVersion`) so ensure your local Flutter SDK is compatible.

---

## Required tools & recommended versions

- Flutter SDK: >= 3.27.0 (install from https://flutter.dev). Flutter includes a compatible Dart SDK (Dart >= 3.10.7 as constrained).
- Android Studio or Android SDK & command-line tools.
  - Android SDK Platform (API 33+ recommended).
  - Java JDK 17 (OpenJDK 17) for Gradle builds.
- Xcode (macOS): Xcode 14+ for building iOS/macOS targets.
- Visual Studio 2022 (Windows) with "Desktop development with C++" workload for Windows desktop.
- CMake and Ninja for desktop builds on Linux/macOS where required.
- Git, a code editor (VS Code / IntelliJ / Android Studio).

Run `flutter doctor -v` after installing the above to verify your environment.

---

## Quick start (common commands)

Open a terminal in the repository root (where `pubspec.yaml` lies) and run:

- Install packages: flutter pub get
- Run tests: flutter test
- Run on the default device: flutter run
- List connected devices: flutter devices

All platform-specific commands below assume you've run `flutter pub get` first.

---

## Platform-specific setup & build/run

Commands are PowerShell-friendly for Windows users; otherwise use your shell of choice.

Android

- Start an emulator or connect an Android device.
- Run (debug): flutter run -d <device-id> (e.g., `flutter run -d android`).
- Build release APK: flutter build apk --release
- Build App Bundle: flutter build appbundle --release

Notes:
- Ensure Android SDK Platform (API 33+) is installed and that `JAVA_HOME` points to JDK 17.
- If you encounter Gradle or Java version issues, ensure the Java version used by Gradle is 17.

iOS (macOS only)

- Install Xcode and agree to the license: `sudo xcodebuild -runFirstLaunch`.
- Run on simulator: flutter run -d ios
- Build release: flutter build ios --release

Notes:
- For device/App Store builds ensure correct provisioning, signing, and an Apple developer account.
- Open `ios/Runner.xcworkspace` in Xcode to manage signing or capabilities.

Web

- Run locally: flutter run -d chrome
- Build: flutter build web
- Serve the build folder (`build/web`) with any static server.

Windows

- Prereqs: Visual Studio 2022 with the "Desktop development with C++" workload.
- Run locally: flutter run -d windows
- Build: flutter build windows

macOS

- Prereqs: Xcode and macOS desktop toolchain.
- Run locally: flutter run -d macos
- Build: flutter build macos

Linux

- Prereqs: Build essentials, CMake, and GTK headers.
- Run locally: flutter run -d linux
- Build: flutter build linux

---

## Running tests

- Unit & widget tests: flutter test
- If integration tests exist under `integration_test/`: run them via `flutter test integration_test/<name>.dart` or `flutter drive` depending on the setup.

Example: flutter test test/widget_test.dart

---

## Assets and fonts

This project already declares assets and fonts in `pubspec.yaml`:

- Assets: `assets/images/` and `assets/fonts/`
- Fonts: `Inter` and `Montserrat`

Add an image asset:
1. Copy the image into `assets/images/`.
2. If your `pubspec.yaml` already includes the containing path (it does), run: `flutter pub get`.

Add a custom font:
1. Add the font files under `assets/fonts/YourFont/`.
2. Edit `pubspec.yaml` under `flutter:` → `fonts:` to register the family and asset path.
3. Run: `flutter pub get`.
4. Use it: Text('Hi', style: TextStyle(fontFamily: 'YourFont'))

---

## Notable files & directories

- `lib/` — Dart source code. Entry point: `lib/main.dart`.
- `lib/core/routes.dart` — Routing and navigation setup.
- `lib/screens/` — App screens (e.g., `home.dart`, `intro/`).
- `assets/` — Images and fonts.
- `android/`, `ios/`, `windows/`, `macos/`, `linux/` — Platform-specific projects.
- `pubspec.yaml` — Package manifest and assets registration.
- `pubspec.lock` — Locked dependency versions.

---

## Troubleshooting

Common issues and quick fixes:

- flutter doctor shows missing dependencies: run `flutter doctor -v` and follow the recommendations.
- Gradle/Java errors on Android: ensure JDK 17 is installed and `JAVA_HOME` is set to it. Try `flutter clean; flutter pub get; flutter build apk`.
- iOS code signing errors: open `ios/Runner.xcworkspace` in Xcode and set a valid Team and provisioning profile.
- Missing assets at runtime: verify the paths in `pubspec.yaml` and check for typos or capitalization differences.
- Windows desktop build issues: ensure Visual Studio 2022 with C++ workload is installed.
- Dependency or build cache problems: try `flutter pub cache repair` or remove `pubspec.lock` and run `flutter pub get` (be cautious — this changes locked versions).

---

## Suggested badges

Add badges for build status, Flutter/Dart versions, and package version if published.

Example (replace placeholders):

- Flutter: `![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.27.0-blue)`
- CI: `![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)`
- pub.dev: `![pub package](https://img.shields.io/pub/v/<package-name>.svg)`

---

## Continuous Integration / Release Workflow

This repository contains a GitHub Actions workflow at `.github/workflows/deploy.yml` that builds an Android release APK and creates a GitHub release when commits are pushed to the `main` branch. Below are the findings, security notes, and recommended improvements so the CI behaves reliably for this Flutter project.

What the current workflow does (summary)

- Trigger: push to `main` branch.
- Environment: `ubuntu-latest` runner with Java 17 and Flutter provided by `subosito/flutter-action@v2`.
- Steps: checks out code, sets up Java, installs Flutter, runs `flutter pub get`, runs `flutter build apk --release`, creates a GitHub Release, uploads `build/app/outputs/flutter-apk/app-release.apk` to the release, and sends an email notification using repository secrets.

Files:
- Workflow: `.github/workflows/deploy.yml`

Findings (quick)

- Flutter version mismatch: the workflow pins `flutter-version: '3.19.0'` while this repo's `pubspec.yaml` and other hints recommend Flutter >= 3.27.0. Use a Flutter version compatible with the project (e.g., `stable` or `3.27.x`+) to avoid build/runtime inconsistencies.

- Unsigned APK / signing missing: the workflow runs `flutter build apk --release` but does not configure Android keystore signing. The produced `app-release.apk` will be unsigned or signed with a debug key (not suitable for Play Store). For Play Store distribution you should sign the APK/AAB with your release keystore in the workflow.

- Secrets used: the workflow references `EMAIL_USERNAME` and `EMAIL_PASSWORD` for the email step and uses the automatically provided `GITHUB_TOKEN` for the release. Storing or using account passwords directly is risky—prefer app-specific passwords, tokens, or alternate notification channels (Slack, Teams, or GitHub Notifications).

- Artifact type: the workflow publishes an APK. Google Play prefers Android App Bundles (`.aab`) and offers smaller downloads and dynamic delivery. Consider using `flutter build appbundle --release` and uploading the `.aab` instead.

- Optimizations missing: caching `~/.pub-cache`, and using Gradle or Flutter build caches can speed CI and reduce flakiness.

Recommended workflow improvements (prioritized)

1. Update the Flutter version to match the project constraint (for example, `flutter-version: '3.27.0'` or `flutter-version: 'stable'`).
2. Add Android keystore signing: store keystore in GitHub Secrets (or as a base64-encoded secret) and configure the workflow to write the keystore file, set `key.properties` or Gradle signingConfigs, and run the release build. Required secrets (suggested names):
   - `ANDROID_KEYSTORE_BASE64` (base64 of your `.jks`/`.keystore` file)
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS`
   - `ANDROID_KEY_PASSWORD`

   Example approach: decode the base64 secret into `keystore.jks` in a workflow step and set `./gradlew` properties or `key.properties` before building.

3. Switch to building an App Bundle for Play Store: `flutter build appbundle --release` and upload `build/app/outputs/bundle/release/app-release.aab` to the release (or upload to Play Console using `r0adkll/upload-google-play` action).

4. Replace email password usage with a safer notification method or an app-specific SMTP password. Avoid storing or printing raw passwords in logs.

5. Add caching for pub packages and Gradle to speed up builds.

6. Optionally restrict workflow to tags for release builds (e.g., `on: push: tags: - 'v*'`) if you only want permanent releases for tagged commits.

Required GitHub secrets (minimum)

- `GITHUB_TOKEN` — automatically provided by GitHub Actions (used for creating releases).
- `EMAIL_USERNAME` — username for email notifications (if you keep email step).
- `EMAIL_PASSWORD` — password or app-specific password for the email account (prefer app-specific).

Optional but recommended for release signing and Play upload

- `ANDROID_KEYSTORE_BASE64` — base64-encoded keystore file content.
- `ANDROID_KEYSTORE_PASSWORD` — keystore password.
- `ANDROID_KEY_ALIAS` — keystore alias.
- `ANDROID_KEY_PASSWORD` — alias password.
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` — base64-encoded JSON key if you want automated Play Console uploads.

How to add GitHub secrets

1. In your repository on GitHub: Settings → Secrets and variables → Actions → New repository secret.
2. Add the secret name and value (paste the raw value; for keystore you can `base64` it locally and paste the base64 string).
3. Update the workflow to reference `${{ secrets.YOUR_SECRET_NAME }}`.

Quick example snippet (concept only) for keystore decode step in a workflow:

```yaml
- name: Restore Android keystore
  run: |
    echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks
```

And then ensure your Gradle signing config uses `android/app/keystore.jks` and the passwords from secrets.

Suggested next steps for maintainers

- Update `.github/workflows/deploy.yml` to align Flutter version and add signing steps if you want to publish Play-ready releases.
- Consider changing the build from APK to App Bundle for Play Store distribution.
- Replace raw email credentials with an app-specific password or a more secure notification system.

Exact README snippet for repository (this section)

- This section is intended to be present in the README to help maintainers find and secure the CI pipeline. If you prefer, it can be moved to a separate `CI.md` or `ops/` documentation.

---

## Contributing

- Run `flutter pub get` after updating `pubspec.yaml`.
- Follow existing lint rules in `analysis_options.yaml`.
- Add tests for new features when possible.

---

## License & authors

- This repository does not include a license file by default. Add a `LICENSE` file if required.
- Add any maintainer or contact details here.

---

## Assumptions made

- Flutter >= 3.27.0 and Dart >= 3.10.7 are acceptable for development.
- Java 17 is required for Android Gradle builds.
- CI badges are placeholders; no CI config was modified.
- Signing keys, provisioning profiles, and keystores are intentionally not included here.


---

If you'd like, I can also:
- Add CI example workflow files (GitHub Actions) for building and testing,
- Add a `CONTRIBUTING.md` and `LICENSE` file,
- Or insert a project-specific badge set — tell me your preferred CI or package name.
