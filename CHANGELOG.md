## 4.1.5
* Bumped to android SDK 2.3.2 
  * Fixes crash for a split app view and similar cases

## 4.1.4
* Extended automatic navigation tracking
* Fixed transition sensitivity
* Bumped to android SDK 2.3.1
* Bump iOS SDK to 2.2.7

## 4.1.4-beta.2
* Added logic for covering BottomSheet transitions sensitivity

## 4.1.4-beta.1
* Extended automatic navigation tracking
* Fixed transition sensitivity

## 4.1.3
* Enable setting region US/EU
* Possible fix for releasing to App Store

## 4.1.2
* Enable building for Web platform

## 4.1.1
* Improve iOS sensitivity for TextField and TextFormField
* Improve significantly performance of wireframe from images
* Bump iOS SDK to 2.2.4
* **BREAKING**: Added class RawMagnifier to sensitive elements
* **BREAKING**: Listeners callback parameter set to String

## 4.1.0
* Bump android SDK to 2.2.2
* Bump iOS SDK to 2.2.3
* Added wireframe rendering mode
* Added sensitivity for elements and classes
* Extended sensitivity for native elements 
* **BREAKING** **REFACTOR**: listeners changed to be more similar to native SDKs
* **BREAKING** **REFACTOR**: TextField and TextFormField are set to sensitive by default


## 4.0.8
* **FIX**: URL getters fixed to return correct form now

## 4.0.7

* **FIX**: bump android SDK to 2.1.6
* **FIX**: fix getUrlWithTimeStamp getter
* **FIX**: set adaptiveFramerate on iOS by default to false on first start of recording, 
  should prevent from occasional lagging of recording

## 4.0.6

* **FIX**: bumped android SDK to 2.1.5 web view fixes
* **FIX**: recording mask set to null fix

## 4.0.5

* **FIX**: bumped android SDK to 2.1.4 to prevent crashes with async task

## 4.0.4

* **FIX**: bumped android SDK to 2.1.3 to prevent crashes with Kotlin versions lower than 1.6.0

## 4.0.3

* **FIX**: bumped android SDK to 2.1.2 to prevent occasional crashes
* all used classes can now be imported and are also visible in generated docs

## 4.0.2

* **BREAKING** **REFACTOR**: trackEvent, trackNavigationEnter, trackNavigationExit parameter `key` changed to `name`
* added or extended documentation for methods and classes


## 4.0.1

* **FIX**: iOS did not build with `use_frameworks!` inside your podfile. Now it requires it to build

## 4.0.0

> Note: This release has breaking changes.

* Update Smartlook Android and iOS SDK to v2.1.0
* **BREAKING** **REFACTOR**: static methods converted to instance methods
* **BREAKING** **REFACTOR**: method namings and functionality may differ
* **BREAKING** **REFACTOR**: missing wireframe - will be released in next version
* Java converted into Kotlin
* Objective C converted into Swift

## 3.0.10

* Android waiting for futures fixed
* Fixed not working example
* Update Android Smartlook SDK to v1.8.13

## 3.0.9

* Revert iOS Smartlook SDK back to 1.7.10
  * Should fix the iOS build issue

## 3.0.8

* Update Android Smartlook SDK to v1.8.11
  * Should fix some rare crashes on Samsung Galaxy phones
* Update iOS Smartlook SDK to v1.8.6

## 3.0.7

* Update Android Smartlook SDK to v1.8.10

## 3.0.6

* Remove `startFullscreenSensitiveMode()` method
  * use `Smartlook.setRenderingMode(SmartlookRenderingMode.no_rendering);`
* Remove `stopFullscreenSensitiveMode()` method
  * use `Smartlook.setRenderingMode(SmartlookRenderingMode.native);`
* Remove `isFullscreenSensitiveModeActive()` method
* Remove jcenter from gradle

## 3.0.5

* Bug fixes

## 3.0.4

* Bug fixes

## 3.0.3

* Switch back to Smartlook.xcframework compiled by Xcode 12 to fix compatibility issues.

## 3.0.2

* Fix gradle build issue

## 3.0.1

* Update of Android SDK

## 3.0.0

* New name - flutter_smartlook
* Support of "wireframe" mode
* Update of both iOS and Android SDKs -> performance and stability improvements
* Support of latest Flutter versions