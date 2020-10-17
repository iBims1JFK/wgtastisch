import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class OCR extends StatefulWidget {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = false;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  OCR(int cameraOcr, bool autoFocusOcr, bool torchOcr, bool multipleOcr, bool waitTapOcr, bool showTextOcr, Size previewOcr, List<OcrText> textsOcr ) {
  _cameraOcr = cameraOcr;
  _autoFocusOcr = autoFocusOcr;
  _torchOcr = torchOcr;
  _multipleOcr = multipleOcr;
  _waitTapOcr = waitTapOcr;
  _showTextOcr = showTextOcr;
  _previewOcr = previewOcr;
  _textsOcr = textsOcr;
}

  @override
  _OCRState createState() => _OCRState();
}


class _OCRState extends State<OCR> {

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: widget._torchOcr,
        autoFocus: widget._autoFocusOcr,
        multiple: widget._multipleOcr,
        waitTap: widget._waitTapOcr,
        showText: widget._showTextOcr,
        preview: widget._previewOcr,
        camera: widget._cameraOcr,
        fps: 2.0,
      );
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }
    if (!mounted) return;
    //textsOcr
    setState(() => widget._textsOcr = texts);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
