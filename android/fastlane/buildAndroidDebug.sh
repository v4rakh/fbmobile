#!/usr/bin/env sh

cd ../../;
flutter clean && \
flutter pub get &&
flutter packages pub run build_runner build --delete-conflicting-outputs;

flutter build apk --debug;