import 'dart:async';
import 'dart:convert';
import 'package:dw3_pizza_delivery_api/modules/orders/controller/mapper/save_order_input_model_mapper.dart';
import 'package:dw3_pizza_delivery_api/services/order/i_orders_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'orders_controller.g.dart';

@Injectable()
class OrdersController {
  final IOrdersService _service;
  OrdersController(this._service);

  @Route.post('/')
  Future<Response> saveOrder(Request request) async {
    try {
      final inputModel =
          SaveOrderInputModelMapper(await request.readAsString()).mapper();

      await _service.saveOrder(inputModel);

      return Response.ok('');
    } on Exception catch (e) {
      print(e);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao salvar order.'}));
    }
  }

  Router get router => _$OrdersControllerRouter(this);
}

parei em 36 minutos