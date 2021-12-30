<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# theta lib for building API test apps

RICOH THETA API tester built with dio.

## Features

![video screengrab](docs/images/live_preview.gif)

* http post
* http get
* theta commands (osc/commands/execute)
* theta options (osc/commands/execute with payload `setOptions`)
* get live preview - returns a stream


## Getting started

<!--
TODO: List prerequisites and provide or point to information on how to
start using the package.
-->

Works with RICOH THETA Z1 and V.  Some features work with the SC2.

### Android

Enable use with http instead of the default https only.

`project_home/android/app/src/debug/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.tpreview_flutter">
    <!-- Flutter needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <application android:usesCleartextTraffic="true" />
</manifest>
```

## Usage
<!-- 
TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
``` -->

Get camera information

```dart
import 'package:theta/theta.dart';
String response = await ThetaBase.get('info');
```

take picture

```dart
import 'package:theta/theta.dart';
String response = await command('takePicture');
```

set option

```dart
import 'package:theta/theta.dart';
String response = await setOption(
    name: 'captureMode', value: 'image');
```

check command status to see when camera is ready for next command.
For example, if you use `command('takePicture')`, you may want to
wait for the camera to be ready before you issue another command. 
The SC2 take 8 to 9 seconds to be ready for another command.

```dart
import 'package:theta/theta.dart' as theta;

while (await theta.commandStatus(id) != 'done') {
  await theta.commandStatus(id);
```

### live preview

Example shows how to save frame to file for inspection and testing.
Full code for this example is in the examples section of the library.

```dart
var frameCount = 0;
var preview = Preview(controller);
await preview.getLivePreview(frames: frames, frameDelay: delay);
controller.stream.listen((frame) {
  listOfFiles[frameCount].writeAsBytes(frame);
  frameCount++;
});
```

## Additional information

<!-- TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more. -->
* [Official RICOH THETA API Reference](https://api.ricoh/docs/theta-web-api-v2.1/)

Post questions to:

* [RICOH THETA Developer community](https://community.theta360.guide)
