import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'dart:developer';

//import 'Widgets/CartList.dart';
import 'package:xml/xml.dart';

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

  void tokenization(List<String> fullStrings) {
    List<List<String>> splitedStrings = [];
    List<double> Price = [];
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    final test = builder.buildDocument();

    fullStrings.forEach((e) {
      splitedStrings.add(e.split(" "));
    });
    for (int l = 0; l < splitedStrings.length; l++) {
      String last = null;
      String type = "flawed";
      builder.element(l.toString(), nest: () {
        for (int i = 0; i < splitedStrings[l].length; i++) {
          String word = splitedStrings[l][i].toString();
          if (new RegExp(r"(\d*)(,)(\d*)").hasMatch(word)) {
            last = "price";
          } else if (isNumeric(word)) {
            last = "product id";
          } else if (word == "EUR") {
            type = "eur";
            last = "eur";
          } else if (new RegExp("^A\$|^B\$|^\(1\)\$|^(2)\$|^1\$|^2\$|^5\$|^7\$|^16\$|^19\$").hasMatch(word)) {
            type = "normal";
            last = "tax";
          } else if (new RegExp("^kg\$").hasMatch(word) && last == "price"){
            type = "weight";
            last = "eur/kg";
          } else {
            last = "product name";
          }
          builder.element(last, nest: word);
        }
        builder.attribute("type", type);
      });
    }
    final products = builder.buildDocument();
    log(products.toXmlString(pretty: true));
    print(Price);

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
    //print(extractText.length);
    CartItems = extractText.split('\n');
    tokenization(CartItems);
    setState(() {
      _extractText = extractText;
    });
  }

  String total() {
    double totalAmount = 0;
    for (double e in price) {
      totalAmount += e;
    }
    return totalAmount.toString().replaceAll(".", ",");
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        BackButton(),
        OutlineButton(onPressed: null, child: Text("speichern")),
        Text(total()),
       // CartList(product, price),
        Image.asset('lib/bill.jpg'),
      ],
    );
  }
}
