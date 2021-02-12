import 'dart:convert';

import 'package:dw3_pizza_delivery_api/entities/menu_item.dart';

class Menu {
  int id;
  String name;
  List<MenuItem> itens;
  Menu({
    this.id,
    this.name,
    this.itens,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'itens': itens?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Menu(
      id: map['id'],
      name: map['name'],
      itens: List<MenuItem>.from(map['itens']?.map((x) => MenuItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source));
}
