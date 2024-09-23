import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_cv_platform_interface.dart';

/// An implementation of [NativeCvPlatform] that uses method channels.
class MethodChannelNativeCv extends NativeCvPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_cv');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
