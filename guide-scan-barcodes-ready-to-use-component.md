# BarcodeScanner Integration Guide

In this guide, we will guide you to develop a barcode scanning app with the [`BarcodeScanner`](https://dynamsoft.github.io/barcode-reader-flutter-samples/APIReferences/dynamsoft-barcode-reader-bundle-flutter/dynamsoft-barcode-reader-bundle-flutter/) component.

We provide `BarcodeScanner` APIs, which is a ready-to-use component that allows developers to quickly set up a barcode scanning app.
With the built-in component, it streamlines the integration of barcode scanning functionality into any application.

In the `BarcodeScanner` APIs, we provide some customization features based on easy integration to meet your needs. 

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

Run the following commands in the root directory of your flutter project to add `dynamsoft-barcode-reader-bundle-flutter` into dependencies

```bash
flutter pub add dynamsoft-barcode-reader-bundle-flutter
```

then run the command to install all dependencies:
```bash
flutter pub get
```

## Camera permissions

The Dynamsoft Barcode Reader SDK needs the camera permission to use the camera device, so it can capture from video stream.

### Android

For Android, we have defined camera permission within the SDK, you don't need to do anything.

### iOS

Add this camera permission description to **ios/{projectName}/Info.plist** inside the <dict> element:

```xml
<key>NSCameraUsageDescription</key>
    <string></string>
```

## Build the BarcodeScanner Component

Now that the package is added, it's time to start building the `BarcodeScanner` Widget using the SDK.

### Import
To use the BarcodeScanner API, please import `dynamsoft_barcode_reader_bundle_flutter` in your dart file:
```dart
import 'package:dynamsoft_barcode_reader_bundle_flutter/dynamsoft_barcode_reader_bundle_flutter.dart';
```

### Simplest Example
```dart
import 'package:dynamsoft_barcode_reader_bundle_flutter/dynamsoft_barcode_reader_bundle_flutter.dart';

void _launchBarcodeScanner() async{
  var config = BarcodeScannerConfig(
    license: 'DLS2eyJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSJ9',
  );
  const result = await BarcodeScanner.launch(config);
  if(result.status == EnumResultStatus.finished){
    // handle the result
  }
}
```

You can call the above function anywhere (e.g., when the app starts, on a button click, etc.) to achieve the effect: 
open a barcode scanning interface, and after scanning is complete (with `BarcodeScanConfig.scanningMode` determining whether a single barcode or multiple barcodes are captured), 
close the interface and return the result. Following is the simplest example of how to use the `_launchBarcodeScanner` function:

```dart
import 'package:flutter/material.dart';
import 'package:dynamsoft_barcode_reader_bundle_flutter/dynamsoft_barcode_reader_bundle_flutter.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _launchBarcodeScanner() async {
    //...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: _launchBarcodeScanner,
                    child: const Text("Scan Barcodes"),
                  ),
                ],
              ),
            )
    );
  }
}
```

> [!NOTE]
>- The license string here grants a time-limited free trial which requires network connection to work.
>- You can request a 30-day trial license via the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr&utm_source=guide&package=mobile) link.

### Barcode Scan Result
Also see it in the [BarcodeScanResult](https://dynamsoft.github.io/barcode-reader-flutter-samples/APIReferences/dynamsoft-barcode-reader-bundle-flutter/dynamsoft-barcode-reader-bundle-flutter/BarcodeScanResult-class.html) section of API References.

`BarcodeScanResult` structure:
- resultStatus: The status of the barcode result, of type `EnumResultStatus`.
  - finished: The barcode scan was successful.
  - canceled: The barcode scanning activity is closed before the process is finished.
  - exception: Failed to start barcode scanning or an error occurs when scanning the barcodes.
- errorCode: The error code indicates if something went wrong during the barcode scanning process (0 means no error).
- errorString: The error message associated with the error code if an error occurs during barcode scanning process.
- barcodes: An array of `BarcodeResultItem`.

### (Optional) Change the BarcodeScanConfig to meet your needs
Also see it in the [BarcodeScanConfig](https://dynamsoft.github.io/barcode-reader-flutter-samples/APIReferences/dynamsoft-barcode-reader-bundle-flutter/dynamsoft-barcode-reader-bundle-flutter/BarcodeScannerConfig-class.html) section of API References.
```dart

const config = BarcodeScanConfig(
  
  ///The license key required to initialize the BarcodeScanner.
  license: "DLS2eyJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSJ9", //The license string here grants a time-limited free trial which requires network connection to work.
  
  ///Sets the barcode format(s) to read.
  ///This value is a combination of EnumBarcodeFormat flags that determine which barcode types to read.
  ///For example, to scan QR codes and OneD codes,
  ///set the value to `EnumBarcodeFormat.BF_QR_CODE | EnumBarcodeFormat.BF_ONED`.
  barcodeFormats: EnumBarcodeFormat.BF_QR_CODE | EnumBarcodeFormat.BF_ONED,
  
  ///Defines the scanning area as a DSRect object where barcodes will be detected.
  ///Only the barcodes located within this defined region will be processed. 
  ///Default is undefined, which means the full screen will be scanned.
  scanRegion: DSRect(top: 0.25, bottom: 0.75, left: 0.25, right: 0.75, measuredInPercentage: true), // scan the middle 50% of the screen
  
  ///Determines whether the torch (flashlight) button is visible in the scanning UI.
  ///Set to true to display the torch button, enabling users to turn the flashlight on/off. Default is true.
  isTorchButtonVisible: true,

  ///Specifies if a beep sound should be played when a barcode is successfully detected.
  ///Set to true to enable the beep sound, or false to disable it. Default is false.
  isBeepEnabled: false,

  ///Enables or disables the auto-zoom feature during scanning.
  ///When enabled (true), the scanner will automatically zoom in to improve barcode detection. Default is false.
  isAutoZoomEnabled: false,

  ///Determines whether the close button is visible on the scanner UI.
  ///This button allows users to exit the scanning interface. Default is true.
  isCloseButtonVisible: true,

  ///Specifies whether the camera toggle button is displayed.
  ///This button lets users switch between available cameras (e.g., front and rear). Default is false.
  isCameraToggleButtonVisible: false,

  ///Determines if a scanning laser overlay is shown on the scanning screen.
  ///This visual aid (scan laser) helps indicate the scanning line during barcode detection. Default is true.
  isScanLaserVisible: true,

  ///Sets the scanning mode for the BarcodeScanner.
  ///The mode is defined by the EnumScanningMode and affects the scanning behavior. Default is `EnumScanningMode.single`.
  scanningMode: EnumScanningMode.single,

  ///Defines the expected number of barcodes to be scanned.
  ///The scanning process will automatically stop when the number of detected barcodes reaches this count.
  ///Only available when `scanningMode` is set to `EnumScanningMode.multiple`. Default is 999.
  expectedBarcodesCount: 999,

  ///Specifies the maximum number of consecutive stable frames to process before exiting scanning.
  ///A "stable frame" is one where no new barcode is detected.
  ///Only available when `scanningMode` is set to `EnumScanningMode.multiple`. Default is 10.
  maxConsecutiveStableFramesToExit: 10,

  ///Specifies the template configuration for the BarcodeScanner.
  ///This can be either a file path or a JSON string that defines various scanning parameters.
  ///Default is undefined, which means the default template will be used.
  templateFile: "JSON template string",
);
```

## Run the Project

Go to your project folder, open a _new_ terminal and run the following command:

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
The full sample code is available [here](./ScanBarcodes_ReadyToUseComponent).

## License

- You can request a 30-day trial license via the [Request a Trial License](https://www.dynamsoft.com/customer/license/trialLicense?product=mrz&utm_source=github&package=mobile) link.

## Contact

https://www.dynamsoft.com/company/contact/
