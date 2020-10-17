import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class OCR {
  // doOCR(Size preview) async {
  //   List<OcrText> texts = [];
  //   try {
  //     texts = await FlutterMobileVision.read();
  //   } on Exception {
  //     texts.add(new OcrText('Failed to recognize text.'));
  //   }
  // }
  int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";
}
