# Foundational Barcode Reader Integration Guide

In this guide, we will guide you to develop a barcode scanning app with the [`Foundational APIs`](https://dynamsoft.github.io/barcode-reader-react-native-samples/APIReferences/dynamsoft-capture-vision-react-native) of Dynamsoft Barcode Reader SDK.

## Supported Barcode Symbologies

| Linear Barcodes (1D) | 2D Barcodes | Others |
| :------------------- | :---------- | :----- |
| Code 39 (including Code 39 Extended)<br>Code 93<br>Code 128<br>Codabar<br>Interleaved 2 of 5<br>EAN-8<br>EAN-13<br>UPC-A<br>UPC-E<br>Industrial 2 of 5<br><br><br><br><br><br><br><br> | QR Code (including Micro QR Code and Model 1)<br>Data Matrix<br>PDF417 (including Micro PDF417)<br>Aztec Code<br>MaxiCode (mode 2-5)<br>DotCode<br><br><br><br><br><br><br><br><br><br><br><br> | Patch Code<br><br>GS1 Composite Code<br><br>GS1 DataBar<br><li>Omnidirectional</li><li>Truncated, Stacked</li><li>Stacked Omnidirectional, Limited</li><li>Expanded, Expanded Stacked</li><br>Postal Codes<br><li>USPS Intelligent Mail</li><li>Postnet</li><li>Planet</li><li>Australian Post</li><li>UK Royal Mail</li> |

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

## Build the Barcode Reader Widget

Now that the package is added, it's time to start building the barcode reader Widget using the SDK.

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
>- You can request a 30-day trial license via the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dcv&utm_source=guide&package=mobile) link.

### Implement Barcode Scanning from Video Stream

The basic workflow of scanning barcodes from video stream is as follows:

- Initialize the `CameraEnhancer` object
- Initialize the `CaptureVisionRouter` object
- Bind the `CameraEnhancer` object to the `CaptureVisionRouter` object
- Register a `CapturedResultReceiver` object to listen for decoded barcodes via the callback function `onDecodedBarcodesReceived`
- Open the camera
- Start barcode scanning via `startCapturing`

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final String _templateName = EnumPresetTemplate.readBarcodes;
  final CaptureVisionRouter _cvr = CaptureVisionRouter.instance;
  final CameraEnhancer _camera = CameraEnhancer.instance;
  late final CapturedResultReceiver _receiver = CapturedResultReceiver()
    ..onDecodedBarcodesReceived = (DecodedBarcodesResult result) async {
      if (result.items?.isNotEmpty ?? false) {
        var displayString = result.items?.map((item) => "Format: ${item.formatString}\nText: ${item.text}").join('\n\n');
        //You can do whatever you want with the result.items which is list of BarcodeResultItem.        
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
    _cvr.addResultReceiver(_receiver); //Register `CapturedResultReceiver` object to listen for parsed decoded barcodes result
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

## Customize the Barcode Reader

### Specify Barcode Formats and Count

There are several ways in which you can customize the Barcode Reader.

- Using the `SimplifiedCaptureVisionSettings` class and `updateSettings` API. It must be called before `CaptureVisionRouter.startCapturing`

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

final _cvr = CaptureVisionRouter.instance;
final _templateName = EnumPresetTemplate.readBarcodes; //"ReadBarcodes_Default"

void initSdk() async {
  //...
  SimplifiedCaptureVisionSettings? settings =  await _cvr.getSimplifiedSettings(_templateName);
  settings!.timeout = 1000; // set timeout to 1 second for each frame scan

  // Set the expected barcode count to 0 when you are not sure how many barcodes you are scanning.
  // Set the expected barcode count to 1 can maximize the barcode decoding speed.
  settings.barcodeSettings!.expectedBarcodesCount = 0;
  
  settings.barcodeSettings!.barcodeFormatIds = EnumBarcodeFormat.oned |EnumBarcodeFormat.qrCode | EnumBarcodeFormat.pdf417 | EnumBarcodeFormat.datamatrix;
  //In this case, only timeout, expectedBarcodesCount and barcodeFormatIds will be updated and undefined properties will retain their original values.
  _cvr.updateSettings(settings, _templateName);
  _cvr.startCapturing(_templateName);
  //...
}
```

- Using the `initSettings` API. It must be called before `CaptureVisionRouter.startCapturing`

```dart
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
final _cvr = CaptureVisionRouter.instance;

void initSettings() async {
  //...
  _cvr.initSettings("{your raw Json template String}");
  //...
  router.startCapturing("{your template name in the template String}");
}
```

> [!NOTE]
>
> - A template file is a JSON file that includes a series of algorithm parameter settings. It is always used to customize the performance for different usage scenarios. [Contact us](https://www.dynamsoft.com/company/contact/) to get a customized template for your barcode scanner.


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
The full sample code is available [here](./ScanBarcodes_FoundationalAPI).

## License

- You can request a 30-day trial license via the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr&utm_source=github&package=mobile) link.

## Contact

https://www.dynamsoft.com/company/contact/
