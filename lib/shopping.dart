import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'Widgets/CartItemList.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String _extractText = 'Nicht gefunden';
  List<String> CartItems = [];
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String extractText;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Directory directory = await getTemporaryDirectory();
      final String imagePath = join(
        directory.path,
        "tmp_1.jpg",
      );
      final ByteData data = await rootBundle.load('lib/bill.jpg');
      final Uint8List bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(imagePath).writeAsBytes(bytes);
      extractText = await TesseractOcr.extractText(imagePath, language: "deu");


    } on PlatformException {
      extractText = 'Failed to extract text';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    CartItems = extractText.split('\n');
    List<List<String>> CartItemsMapped = [];
    //CartItems.forEach((element) {
    //  CartItemsMapped.add()
    //});
    setState(() {
      _extractText = extractText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
                child: Text('Detected Text: $CartItems[0]\n'),
     // child: CartItemList(),
    );
  }
}
