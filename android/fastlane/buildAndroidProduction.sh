#!/usr/bin/env sh

cd ../../;
flutter clean && \
flutter pub get &&
flutter packages pub run build_runner build --delete-conflicting-outputs;

flutter build apk --debug
flutter build apk --profile
flutter build apk --release --target-platform android-arm,android-arm64,android-x64 --split-per-abi;