# Drivers' License Scanner Integration Guide

In this guide, we'll walk you through developing a Flutter application that can scan drivers' licenses using the [`Foundational APIs`](https://pub.dev/documentation/dynamsoft_capture_vision_flutter/latest/).

## Supported Drivers' License Types

### AAMVA DL/ID Standard Drivers's License

All versions of the AAMVA DL/ID specification (2000, 2003, 2005, 2009, 2010, 2011, 2012, 2013, 2016).

### South Africa Driver License

The fields parsed from the South African driver’s license are currently limited to some personal information, while the full information will be parsed in a future release.

## Requirements

### Dev tools

* Latest [Flutter SDK](https://flutter.dev/)
* For Android apps: Android SDK (API Level 21+), platforms and developer tools
* For iOS apps: iOS 13+, macOS with latest Xcode and command line tools

### Mobile platforms

* Android 5.0 (API Level 21) and higher
* iOS 13 and higher

## Installation

Run the following commands in the root directory of your flutter project to add `dynamsoft_barcode_reader_bundle_flutter` into dependencies, which will also include `dynamsoft_capture_vision_flutter`.

```bash
flutter pub add dynamsoft_barcode_reader_bundle_flutter
```

then run the command to install all dependencies:
```bash
flutter pub get
```

## Camera permissions

The Dynamsoft Barcode Reader SDK needs the camera permission to use the camera device, so it can capture from video stream.

### Android

Before opening camera to start capturing, you need to request camera permission from system.

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

PermissionUtil.requestCameraPermission();
```

### iOS

Add this camera permission description to **ios/{projectName}/Info.plist** inside the <dict> element:

```xml
<key>NSCameraUsageDescription</key>
    <string></string>
```

## Build the Drivers' License Scanner Widget

Now that the package is added, it's time to start building the Drivers' License Scanner Widget using the SDK.

### Initialize License

The first step in code configuration is to initialize a valid license via `LicenseManager.initLicense`.

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

LicenseManager.initLicense('DLS2eyJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSJ9').then((data) {
      final (isSuccess, message) = data;
      if (!isSuccess) {
        print("license error: $message");
      }
    });
```

> [!NOTE]
>
>- The license string here grants a time-limited free trial which requires network connection to work.
>- You can request a 30-day trial license via the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr&utm_source=guide&package=mobile) link.

## Implement Drivers' License Scanning from Video Stream

The basic workflow of scanning Drivers' License from video stream is as follows:

- Initialize the `CameraEnhancer` object
- Initialize the `CaptureVisionRouter` object
- Bind the `CameraEnhancer` object to the `CaptureVisionRouter` object
- Register a `CapturedResultReceiver` object to listen for parsed Drivers' License via the callback function `onParsedResultsReceived`
- Open the camera
- Start Drivers' License scanning via `startCapturing`

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final String _templateName = "ReadDriversLicense";
  final CaptureVisionRouter _cvr = CaptureVisionRouter.instance;
  final CameraEnhancer _camera = CameraEnhancer.instance;
  late final CapturedResultReceiver _receiver = CapturedResultReceiver()
    ..onParsedResultsReceived = (ParsedResult result) async {
      if (result.items?.isNotEmpty ?? false) {
        //stopCapturing is used to prevent frequent callbacks of results from affecting your actions on results
        _cvr.stopCapturing();
        DriverLicenseData? data = DriverLicenseData.fromParsedResultItem(result.items![0]);
        if (data != null) {
          //Do something with data
        } else {
          _cvr.startCapturing(_templateName); // restart capturing
        }
      }
    };

  @override
  void initState() {
    super.initState();
    PermissionUtil.requestCameraPermission();
    LicenseManager.initLicense('DLS2eyJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSJ9').then((data) {
      final (isSuccess, message) = data;
      if (!isSuccess) {
        print("license error: $message");
      }
    });
    initSdk();
  }

  void initSdk() async {
    await _cvr.setInput(_camera); //bind CameraEnhancer and CaptureVisonRouter
    _cvr.addResultReceiver(_receiver); //Register `CapturedResultReceiver` object to listen for parsed Drivers License
    _camera.open();
    try {
      await _cvr.startCapturing(_templateName); //Start capturing
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cvr.stopCapturing();
    _camera.close();
    _cvr.removeResultReceiver(_receiver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(child: CameraView(cameraEnhancer: _camera)), // Bind CameraView and CameraEnhancer
    );
  }
}
```

> [!NOTE]
>
> - The `DriverLicenseData.fromParsedResultItem()` function is a helper function to convert `ParsedResultItem` into an easier-to-read structure(`DriverLicenseData`). You can get the source code from [driver_license_scan_result.dart](ScanDriversLicense/lib/driver_license_scan_result.dart).

## Customize the Drivers' License Scanner

### Specify the Scan Region

You can also limit the scan region of the SDK so that it doesn't exhaust resources trying to read from the entire image or frame.

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

final CameraEnhancer _camera = CameraEnhancer.instance;

void initSdk() async {
  //......
  final scanRegion = DSRect(left: 0.1, top: 0.4, right: 0.9, bottom: 0.6, measuredInPercentage: true);
  _camera.setScanRegion(scanRegion);
}
```

## Run the project

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

If everything is set up _correctly_, you should see your new app running on your device.

## Full Sample Code

The full sample code is available [here](./ScanDriversLicense).

## License

- You can request a 30-day trial license via the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr&utm_source=github&package=mobile) link.

## Contact

https://www.dynamsoft.com/company/contact/
