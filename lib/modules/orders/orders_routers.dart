import 'package:dw3_pizza_delivery_api/application/routers/i_router_configure.dart';
import 'package:dw3_pizza_delivery_api/modules/orders/controller/orders_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class OrdersRouters implements IRouterConfigure {
  @override
  void configure(Router router) {
    router.mount('/order/', GetIt.I.get<OrdersController>().router);
  }
}
