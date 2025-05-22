import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

// Load our C lib
final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative_cv.so")
    : DynamicLibrary.process();

// C-style struct for Detection
final class CDetection extends Struct {
  external Pointer<Utf8> label_prob;
}

// C-style struct for DetectionResult
final class CDetectionResult extends Struct {
  external Pointer<CDetection> detections;
  @Int32()
  external int count;
}

// Typedefs for get_opencv_version
typedef _c_get_opencv_version = Pointer<Utf8> Function();
typedef _dart_get_opencv_version = Pointer<Utf8> Function();
final _get_opencv_version =
    nativeLib.lookupFunction<_c_get_opencv_version, _dart_get_opencv_version>(
        'get_opencv_version');

// Typedefs for yolo_detect_ffi
typedef _c_yolo_detect_ffi = Pointer<CDetectionResult> Function(
    Pointer<Utf8> parampath,
    Pointer<Utf8> modelpath,
    Pointer<Utf8> imgpath,
    Int32 target_size,
    Int32 use_gpu,
    Pointer<Utf8> outpath);
typedef _dart_yolo_detect_ffi = Pointer<CDetectionResult> Function(
    Pointer<Utf8> parampath,
    Pointer<Utf8> modelpath,
    Pointer<Utf8> imgpath,
    int target_size,
    int use_gpu,
    Pointer<Utf8> outpath);
final _yolo_detect_ffi =
    nativeLib.lookupFunction<_c_yolo_detect_ffi, _dart_yolo_detect_ffi>(
        'yolo_detect_ffi');

// Typedefs for free_detection_result
typedef _c_free_detection_result = Void Function(
    Pointer<CDetectionResult> result);
typedef _dart_free_detection_result = void Function(
    Pointer<CDetectionResult> result);
final _free_detection_result = nativeLib.lookupFunction<
    _c_free_detection_result,
    _dart_free_detection_result>('free_detection_result');

class NativeCv {
  static const MethodChannel _channel = MethodChannel('native_cv');
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  String getOpenCvVersion() {
    return _get_opencv_version().toDartString();
  }

  List<String> yoloDetect(String paramPath, String modelPath, String imgPath,
      int targetSize, bool useGpu, String outPath) {
    final paramPathC = paramPath.toNativeUtf8();
    final modelPathC = modelPath.toNativeUtf8();
    final imgPathC = imgPath.toNativeUtf8();
    final outPathC = outPath.toNativeUtf8();

    final Pointer<CDetectionResult> resultC = _yolo_detect_ffi(
      paramPathC,
      modelPathC,
      imgPathC,
      targetSize,
      useGpu ? 1 : 0,
      outPathC,
    );

    final List<String> results = [];
    if (resultC.address != nullptr.address) {
      try {
        final detectionResult = resultC.ref;
        for (int i = 0; i < detectionResult.count; i++) {
          final detection = detectionResult.detections.elementAt(i).ref;
          if (detection.label_prob.address != nullptr.address) {
            results.add(detection.label_prob.toDartString());
          }
        }
      } finally {
        // Free the C-allocated memory
        _free_detection_result(resultC);
      }
    }

    // Free the Utf8 pointers
    malloc.free(paramPathC);
    malloc.free(modelPathC);
    malloc.free(imgPathC);
    malloc.free(outPathC);

    return results;
  }
}
