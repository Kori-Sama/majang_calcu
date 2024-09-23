import 'package:flutter/material.dart';
import "package:native_cv/native_cv.dart";

class VersionPage extends StatelessWidget {
  NativeCv _nativeCv = NativeCv();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('${_nativeCv.toString()}\n'
              'OpenCV: ${_nativeCv.getOpenCvVersion()}\n'),
        ),
      ),
    );
  }
}
