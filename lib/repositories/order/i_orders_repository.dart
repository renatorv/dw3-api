import 'package:dw3_pizza_delivery_api/modules/orders/view_models/save_order_input_model.dart';

abstract class IOrdersRepository {
  Future<void> saveOrder(SaveOrderInputModel saveOrder);
}
