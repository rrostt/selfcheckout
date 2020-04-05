import 'dart:convert';
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;

const endpoint = 'https://5mtmwsjdl4.execute-api.us-east-1.amazonaws.com/dev/';
// const endpoint = 'http://192.168.86.28:3000/dev/';

class ApiException implements Exception {
  String message;
  ApiException(this.message);
  String toString() => message;
}

class Item {
  String name;
  int ore;
  Item(this.name, this.ore);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['name'],
      json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': ore};
  }
}

class Api {
  static Future<Item> getItem(String code) async {
    var response = await http.get(path.join(endpoint, 'item', code));

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw new ApiException('No such item');
    }
  }

  static Future<String> initPayment(
      List<Item> items, String phonenumber) async {
    var response = await http.post(
      path.join(endpoint, 'payment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'phonenumber': phonenumber,
        'items': items,
      }),
    );

    if (response.statusCode == 200) {
      print('got response about payment creation' + response.body);
      Map<String, dynamic> map = json.decode(response.body);
      return '${map['paymentId']}';
    } else {
      throw new ApiException('Error preparing payment');
    }
  }

  static String getPaymentUrl(paymentId) =>
      path.join(endpoint, 'payment', paymentId);
}
