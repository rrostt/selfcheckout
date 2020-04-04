import 'dart:convert';
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;

const endpoint =
    'https://5mtmwsjdl4.execute-api.us-east-1.amazonaws.com/dev/item';

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
}

class Api {
  static Future<Item> getItem(String code) async {
    var response = await http.get(path.join(endpoint, code));

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw new ApiException('No such item');
    }
  }
}
