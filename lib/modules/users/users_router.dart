import 'package:dw3_pizza_delivery_api/application/routers/i_router_configure.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';
import 'controller/user_controller.dart';

class UsersRouter implements IRouterConfigure {
  @override
  void configure(Router router) {
    final userController = GetIt.I.get<UserController>();
    router.mount('/user/', userController.router);
  }
}
