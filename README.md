# Dynamsoft Barcode Reader Flutter Samples

This repository contains multiple samples that show you how use the Dynamsoft Capture Vision Flutter SDK.

## Requirements

### Dev tools

* Latest [Flutter SDK](https://flutter.dev/)
* For Android apps: Android SDK (API Level 21+), platforms and developer tools
* For iOS apps: iOS 13+, macOS with latest Xcode and command line tools

### Mobile platforms

* Android 5.0 (API Level 21) and higher
* iOS 13 and higher

## Integration Guide For Your Project

- [Guide for Scanning Barcodes with Ready-to-use Component](./guide-scan-barcodes-ready-to-use-component.md)
- [Guide for Scanning Barcodes with Foundational APIs](./guide-scan-barcodes-foundational-api.md)
- [Guide for Scanning Drivers' License](./guide-scan-drivers-license.md)

## Samples

| Sample Name                                                          | Description                                                                                                         |
|----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| [ScanBarcodes_ReadyToUseComponent](ScanBarcodes_ReadyToUseComponent) | This sample illustrates the simplest way of using `Barcode Scanner API` to recognize barcodes from video streaming. |
| [ScanBarcodes_FoundationalAPI](ScanBarcodes_FoundationalAPI)         | This sample illustrates the simplest way of using Foundational API to recognize barcodes from video streaming.      |
| [ScanDriversLicense](ScanDriversLicense)                             | This sample illustrates how to scan drivers' license from video streaming.                                          |

## How to build and run a sample

### Step 1: Enter a sample folder that you want to try

```bash
cd ScanBarcodes_ReadyToUseComponent
```

or

```bash
cd ScanBarcodes_FoundationalAPI
 ```

or

```bash
cd ScanDriversLicense
 ```

### Step 2: Fetch and install the dependencies of this example project via Flutter CLI:

```
flutter pub get
```

Connect a mobile device via USB and run the app.

### Step 3: Start your application

**Android:**

```
flutter run -d <DEVICE_ID>
```

You can get the IDs of all connected devices with `flutter devices`.

**iOS:**

Install Pods dependencies:

```
cd ios/
pod install --repo-update
```

Open the **workspace**(!) `ios/Runner.xcworkspace` in Xcode and adjust the *Signing / Developer Account* settings. Then, build and run the app in Xcode.

> [!NOTE]
>- The license string here grants a time-limited free trial which requires network connection to work.
>- You can request a 30-day trial license via
   the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr&utm_source=guide&package=mobile) link.

## Request Dynamsoft Trial License Key

- You can request a 30-day trial license via
  the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr&utm_source=github&package=mobile) link.

## Support

https://www.dynamsoft.com/company/contact/

## License

[Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0)
