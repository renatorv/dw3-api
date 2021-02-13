import 'dart:async';
import 'dart:convert';
import 'package:dw3_pizza_delivery_api/services/menu/i_menu_sevice.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'menu_controller.g.dart';

@Injectable()
class MenuController {
  final IMenuSevice _menuSevice;
  MenuController(this._menuSevice);

  @Route.get('/')
  Future<Response> findAll(Request request) async {
    try {
      final menus = await _menuSevice.getAllMenus();

      return Response.ok(
          jsonEncode(menus?.map((m) => m.toMap())?.toList() ?? []));
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Router get router => _$MenuControllerRouter(this);
}
