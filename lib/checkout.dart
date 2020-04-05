import 'package:flutter/material.dart';
import './api.dart';
import 'package:url_launcher/url_launcher.dart';

class Checkout extends StatefulWidget {
  final List<Item> items;

  Checkout(this.items);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _summary(),
            Container(height: 40),
            Builder(
              builder: (context) => RaisedButton(
                onPressed: () async {
                  var result = await _pay(context);
                  Navigator.of(context).pop(result);
                },
                color: Colors.pink,
                child: Text(
                  'Betala',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary() {
    var total = widget.items.length > 0
        ? widget.items.map((item) => item.ore).reduce((sum, item) => sum + item)
        : 0;

    return Column(
      children: <Widget>[
        Text('Att betala'),
        Text(
          '${total / 100}',
          style: TextStyle(fontSize: 36),
        ),
      ],
    );
  }

  Future<bool> _pay(context) async {
    try {
      // var phonenumber = '0712345678';
      // var paymentId = await Api.initPayment(widget.items, phonenumber);
      // print('got the paymentid = $paymentId');
      var url =
          'swish://paymentrequest'; // ?token=$_paymentRequestToken&callbackurl=$callbackUrl';
      // var url = Api.getPaymentUrl(paymentId);
      await launch(url, forceWebView: false);
      return true;
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Unable to prepare payment'),
      ));
      return false;
    }
  }
}
