fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## Android
### android build_debug
```
fastlane android build_debug
```
Build Debug
### android build_production
```
fastlane android build_production
```
Build Production
### android build
```
fastlane android build
```
Build
### android alpha
```
fastlane android alpha
```
Deploy a new version to the Google Play as Alpha
### android beta
```
fastlane android beta
```
Deploy a new version to the Google Play as Beta
### android deploy
```
fastlane android deploy
```
Deploy a new version to the Google Play

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
