import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

// Load our C lib
final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative_cv.so")
    : DynamicLibrary.process();

typedef _c_get_opencv_version = Pointer<Utf8> Function();
typedef _dart_get_opencv_version = Pointer<Utf8> Function();
final _get_opencv_version =
    nativeLib.lookupFunction<_c_get_opencv_version, _dart_get_opencv_version>(
        'get_opencv_version');

class NativeCv {
  static const MethodChannel _channel = MethodChannel('native_cv');
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  String getOpenCvVersion() {
    return _get_opencv_version().toDartString();
  }
}
