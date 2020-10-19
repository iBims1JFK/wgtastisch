import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'Widgets/CartList.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String _extractText = 'Nicht gefunden';
  List<String> CartItems = [];
  List<String> product = [];
  List<double> price = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void getRelevantInformation(List<String> fullStrings) {
    List<List<String>> splitedStrings = [];
    List<String> Product = [];
    List<double> Price = [];
    RegExp regExp = new RegExp(
      r"(\d*)(,)(\d*)"
    );

    fullStrings.forEach((e) {
      splitedStrings.add(e.split(" "));
    });
    for (int l = 0; l < splitedStrings.length; l++) {
      bool foundProduct = false;
      bool foundPrice = false;
      List<String> elementsToDelete = [];
      for (int i = 0; i < splitedStrings[l].length; i++) {
        if (!foundProduct) {
          if (isNumeric(splitedStrings[l][i])) {
            elementsToDelete.add(splitedStrings[l][i]);
          } else {
            foundProduct = true;
          }
        }
        if (!foundPrice) {
          if (regExp.hasMatch(splitedStrings[l][i])) {
            foundPrice = true;
            // Price.add(double.parse(splitedStrings[l][i].replaceAll(",", ".")));
            //nicht alles muss ein double sein
            Price.add(double.parse(splitedStrings[l][i].replaceAll("/", "7").replaceAll(",", ".")));
            elementsToDelete.add(splitedStrings[l][i]);
          }
        } else {
          elementsToDelete.add(splitedStrings[l][i]);
        }
      }
      if(foundPrice && foundProduct){
        for (String s in elementsToDelete) {
          splitedStrings[l].remove(s);
        }
      } else {
        splitedStrings[l].removeWhere((element) => true);
      }

    }
    for (int l = 0; l < splitedStrings.length; l++) {
      if(splitedStrings[l].isNotEmpty){
        Product.add(splitedStrings[l].toString().replaceAll(",", "").replaceAll("[", "").replaceAll("]", ""));
      }
    }
    print(Product.length);
    print(Price.length);

    this.product = Product;
    this.price = Price;
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
    // setState to update our non-existent appearance.
    if (!mounted) return;
    CartItems = extractText.split('\n');
    getRelevantInformation(CartItems);
    setState(() {
      _extractText = extractText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // child: Text('Detected Text: $CartItems[0]\n'),
          child: CartList(product, price),
        ),
        Image.asset('lib/bill.jpg'),
      ],
    );
  }
}
