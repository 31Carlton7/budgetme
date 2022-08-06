// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

final screenshotDevices = <DeviceInfo>[
  Devices.ios.iPhone13ProMax,
  Devices.ios.iPhoneSE,
  Devices.ios.iPad12InchesGen2,
  Devices.ios.iPad12InchesGen4,
  Devices.android.samsungGalaxyS20,
  Devices.android.smallTablet,
  Devices.android.mediumTablet,
];

Future<void> onScreenshot(BuildContext context, DeviceScreenshot screenshot) async {
  final isFrameVisible = context.read<DevicePreviewStore>().data.isFrameVisible;

  final timestamp = DateTime.now();
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/${screenshot.device.name}_$timestamp.png').create();
  if (isFrameVisible) {
    file.writeAsBytesSync(screenshot.bytes);
  } else {
    final rawImage = img.decodePng(screenshot.bytes);
    final resizedImage = img.copyResize(
      rawImage!,
      width: (screenshot.device.screenSize.width * screenshot.device.pixelRatio).toInt(),
      height: (screenshot.device.screenSize.height * screenshot.device.pixelRatio).toInt(),
    );
    file.writeAsBytesSync(img.encodePng(resizedImage));
  }

  final message = 'mv ${file.parent.path}/*.png ~/Desktop';
  if (!kReleaseMode) {
    print(message);
  }
  await Clipboard.setData(
    ClipboardData(text: 'mv ${file.parent.path}/*.png ~/Desktop'),
  );
}
