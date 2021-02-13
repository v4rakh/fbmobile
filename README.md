# README

A mobile flutter app for [FileBin](https://github.com/Bluewind/filebin).

Available on the [Play Store](https://play.google.com/store/apps/details?id=de.varakh.fbmobile).

## Getting Started

This project is a starting point for a Flutter application.

* In [Intellij](https://www.jetbrains.com/idea/) or [Android Studio](https://developer.android.com/studio/) (recommended), install the flutter and dart (dependency of flutter) plugins
* Set up Android SDK:
    * Install via IDE in a folder of your choice (you probably want it not be to installed as superuser)
    * Set the `ANDROID_HOME` variable so that IDE can detect it automatically
    
        ```
        export ANDROID_HOME="$HOME/.android_sdk"
        export PATH=$PATH:$ANDROID_HOME/tools/bin
        export PATH=$PATH:$ANDROID_HOME/platform-tools
        ```
        
* Set up [flutter SDK](https://flutter.dev/docs/get-started/install), you probably want this also on your `PATH` like `ANDROID_HOME`

    ```
    export PATH="$HOME/.flutter_sdk/bin/:$PATH"
    ```

* In the IDE, set the correct SDK paths (e.g. to flutter, dart, Android)

Start by installing dependencies and generating entities!

### Working versions for SDK

```
[✓] Flutter (Channel stable, 1.22.6, on Linux, locale en_US.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
```

## Dependencies
* Run `flutter packages pub get` in project root folder to get dependencies or open the `pubspec.yaml` and click on the buttons provided by the IDE plugins

## JSON Serialization Files
Generate required entities by using these commands:

* Build once: `flutter packages pub run build_runner build --delete-conflicting-outputs`
* File watcher: `flutter packages pub run build_runner watch`

## Architecture

* Views have models
* Model classes use services
* Service classes use data repositories
* Data repositories use the `Api` class

Resulting data workflow: `USER -> view -> model -> service -> repository -> API`.

* *NEVER* use services in views (except for `NavigationService` or `DialogService` if needed)! Create a model function instead. The UI is then fully decoupled from any business logic.
* *DON'T* swallow exceptions with `catch (_/e)`
* *ONLY* handle `ServiceException`! Other exceptions are serious errors and should therefore result in an error (or get caught by a global catcher)
* *ONLY* handle `ServiceException`  in *model* classes to show the user a result
* *ALWAYS* use the `DialogService` (also possible from within a service/model) and *DON'T* create separate dialogs
* *ALWAYS* use the `NavigationService` for navigation and *NOT* `Navigation.of(...)`

## Build & Release

### Release with Fastlane

You need [fastlane](https://fastlane.tools/) installed locally. Look at the initial setup on how to do that.

Fastlane is used to manage the app store presentation and automatic uploading to the Play Store and 
to the App Store. With fastlane you can do common tasks in a collaborative way, e.g. publishing 
to or adapting the texts for the different stores from the commandline.

Before using fastlane you need to properly setup signing, otherwise building will not work.

Initial setup should already be done but this link helps for initial project setup:
[https://flutter.dev/docs/deployment/cd](https://flutter.dev/docs/deployment/cd).

#### Signing & store access setup

You need to setup individually on your machine for signing and afterwards publish an app for the
different platforms.

##### Android

* Copy `android/key.properties.example` to `android/key.properties`
* Adjust properties matching your setup and folder structure
* Point to the `android/fastlane/secrets/key.jks` you just extracted and ask for the store password.
* Copy the `api-access.json` file into `android/fastlane/secrets/`

##### iOS

fastlane's [match](https://docs.fastlane.tools/actions/match/) capability helps with Apple's
singing, secure keys, and profiles. Use `fastlane match` in the `ios` folder to download existing
profiles. They're stored in a separate git repository and are encrypted. 

You need access to the git repository in which those private files reside. 

#### Usage

Go into the platform directory you want to build for, e.g. `ios/` or `android/` and then look into the
`Fastlane` file which lanes are present. Run a lane via `fastlane <platform> <lane>`, e.g. use the
following to build for Android `fastlane android build`.

**Important!** For iOS you need to execute `pod install` first. You also need `cocoapods` installed.

##### Android

Use `fastlane android beta` to build and upload a new beta version to the Play Store.

##### iOS

For iOS you need to execute `fastlane ios build` before uploading to testflight with
`fastlane ios beta`.

### Release manually (not recommended)

See the following links on how to setup:
* [https://flutter.dev/docs/deployment/android](https://flutter.dev/docs/deployment/android)
* [https://flutter.dev/docs/deployment/ios](https://flutter.dev/docs/deployment/ios)

To have a clean environment, when building please follow the steps precisely:

* Clean your local setup with `flutter clean`
* Fetch dependencies with `flutter pub get`
* Generate model files with `flutter packages pub run build_runner build --delete-conflicting-outputs`
* Increase version in `pubspec.yaml` if needed or not already done
* Build Android and iOS apps
    * For **Android** generate an app bundle with `flutter build appbundle` or `flutter build apk`.
    * For **iOS** use `flutter build ios --release --no-codesign`

### Debug

You should use an emulator or real device and Android Studio's internal capability to communicate
and to deploy on it. If you want to build a plain debug version, ensure to have a clean environment
like mentioned above and then execute the following:

```
flutter build apk --debug
flutter build ios --debug
```

## Troubleshooting

##### Seeing something like the following? Remove your `.gradle/` folder!

```
java.util.concurrent.ExecutionException: com.android.builder.internal.aapt.v2.Aapt2InternalException: AAPT2 aapt2-3.2.1-4818971-linux Daemon #0: Daemon startup failed
This should not happen under normal circumstances, please file an issue if it does.
```

##### Flutter problems?

Ensure to be on the version mentioned above which should be in the stable branch. If everything
breaks, start from fresh via `flutter clean` and maybe re-do all necessary steps to get the app
working in the first place.