import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class FinancesPage extends StatefulWidget {
  @override
  _FinancesPageState createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = false;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
      _previewOcr = previewSizes[_cameraOcr].first;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
    List<DropdownMenuItem<int>> _getCameras() {
      List<DropdownMenuItem<int>> cameraItems = [];

      cameraItems.add(DropdownMenuItem(
        child: Text('BACK'),
        value: FlutterMobileVision.CAMERA_BACK,
      ));

      cameraItems.add(DropdownMenuItem(
        child: Text('FRONT'),
        value: FlutterMobileVision.CAMERA_FRONT,
      ));

      return cameraItems;
    }
  }
}
