import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:majang_calcu/components/camera_controller.dart';
import 'package:native_cv/native_cv.dart';

class HomePage extends StatelessWidget {
  final NativeCv _nativeCv = NativeCv();
  final CameraDescription camera;
  HomePage({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Majang Calculator',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: TakePictureScreen(camera: camera),
      ),
      bottomSheet: Text(
        'OpenCV Version: ${_nativeCv.getOpenCvVersion()}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
