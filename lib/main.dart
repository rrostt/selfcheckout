import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingView(title: 'Self-checkout'),
    );
  }
}

class ShoppingView extends StatefulWidget {
  ShoppingView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShoppingViewState createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView> {
  String _barcode = '';
  String _error = '';
  List<Item> _items = [];

  Future<String> _scan() async {
    try {
      String code = await BarcodeScanner.scan();
      return code;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        throw new Exception('Camera Access Denied');
      } else {
        throw new Exception('Unknown error with camera');
      }
    } catch (e) {
      throw new Exception('Some error occured');
    }
  }

  void _addItem() async {
    try {
      String code = await _scan();
      Item item = await Api.getItem(code);
      setState(() {
        _items.add(item);
        _barcode = code;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  void _checkout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: _items
                    .asMap()
                    .map((i, item) => MapEntry(i, _listItem(item, i)))
                    .values
                    .toList(),
              ),
            ),
            _summary(),
            if (_error != null) Text('Error: $_error')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _summary() {
    var total = _items.length > 0
        ? _items.map((item) => item.ore).reduce((sum, item) => sum + item)
        : 0;

    return GestureDetector(
      onTap: _checkout,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(color: Colors.pink),
        child: Center(child: Text('Total: ${total / 100}')),
      ),
    );
  }

  Widget _listItem(Item item, int index) => Dismissible(
        key: Key('$index'),
        onDismissed: (direction) {
          setState(() {
            _items.removeAt(index);
          });
        },
        child: ListTile(
          title: Text(item.name),
          trailing: Text('${item.ore / 100}'),
          leading: Icon(Icons.shopping_basket),
        ),
      );
}
