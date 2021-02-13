import 'package:dw3_pizza_delivery_api/entities/menu.dart';

abstract class IMenuSevice {
  Future<List<Menu>> getAllMenus();
}
