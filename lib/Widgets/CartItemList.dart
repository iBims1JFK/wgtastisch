import 'dart:collection';

import 'package:flutter/cupertino.dart';

class CartItemList extends StatefulWidget {
  List<List<String>> items;
  //CartItemList(List<List<String>> items){
  //  this.items = items;
  //}
  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
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
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      child: Center(child: Text(widget.items[index][0])),
                    );
                  }),
            ),
          ]),
    );
  }
}
