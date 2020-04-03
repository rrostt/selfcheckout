class Item {
  String name;
  int ore;
  Item(this.name, this.ore);
}

class Api {
  static Future<Item> getItem(String code) async {
    return new Item('Beer', 1200);
  }
}
