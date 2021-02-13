import 'package:dw3_pizza_delivery_api/entities/menu.dart';
import 'package:dw3_pizza_delivery_api/repositories/menu/i_menu_repository.dart';
import 'package:injectable/injectable.dart';

import './i_menu_sevice.dart';

@LazySingleton(as: IMenuSevice)
class MenuSevice implements IMenuSevice {
  final IMenuRepository _repository;
  MenuSevice(this._repository);

  @override
  Future<List<Menu>> getAllMenus() {
    return _repository.findAll();
  }
}
