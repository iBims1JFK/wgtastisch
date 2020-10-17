// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
// import 'functionality/OCR.dart';

// class FinancesPage extends StatefulWidget {
//   @override
//   _FinancesPageState createState() => _FinancesPageState();
// }

// class _FinancesPageState extends State<FinancesPage> {
//   int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
//   bool _autoFocusOcr = true;
//   bool _torchOcr = false;
//   bool _multipleOcr = false;
//   bool _waitTapOcr = false;
//   bool _showTextOcr = true;
//   Size _previewOcr;
//   List<OcrText> _textsOcr = [];

//   @override
//   void initState() {
//     super.initState();
//     FlutterMobileVision.start().then((previewSizes) => setState(() {
//           _previewOcr = previewSizes[_cameraOcr].first;
//         }));
//   }

//   int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
//   String _text = "TEXT";

//   Future<Null> _read() async {
//     List<OcrText> texts = [];
//     try {
//       texts = await FlutterMobileVision.read(
//         camera: _ocrCamera,
//         waitTap: true,
//       );
//       setState(() {
//         _text = texts[0].value;
//       });
//     } on Exception {
//       texts.add(OcrText('Failed to recognize text'));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     OCR bla = OCR();
//     return Center(
//       child: RaisedButton(
//         onPressed: _read(),
//         child: Text(
//           'Scanning',
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class FinancesPage extends StatefulWidget {
  @override
  _FinancesPageState createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";
  List<OcrText> texts = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: texts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Center(child: Text(texts[index].value)),
                  );
                }),
          ),
          Center(
            child: RaisedButton(
              onPressed: _read,
              child: Text(
                'Scanning',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _read() async {
    try {
      List<OcrText> localtexts = await FlutterMobileVision.read(
        camera: _ocrCamera,
        multiple: true,
        autoFocus: true,
        flash: true,
        waitTap: false,
        showText: false,
        fps: 30.0
      );
      setState(() => texts = localtexts);
    } on Exception {
      print("du bist so dumm");
    }
  }
}
