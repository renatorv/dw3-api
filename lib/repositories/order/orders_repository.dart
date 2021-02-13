import 'package:dw3_pizza_delivery_api/application/database/i_database_connection.dart';
import 'package:dw3_pizza_delivery_api/application/exceptions/database_error_exception.dart';
import 'package:dw3_pizza_delivery_api/entities/menu_item.dart';
import 'package:dw3_pizza_delivery_api/entities/order.dart';
import 'package:dw3_pizza_delivery_api/entities/order_item.dart';
import 'package:dw3_pizza_delivery_api/modules/orders/view_models/save_order_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_orders_repository.dart';

@LazySingleton(as: IOrdersRepository)
class OrdersRepository implements IOrdersRepository {
  final IDatabaseConnection _connection;
  OrdersRepository(this._connection);

  @override
  Future<void> saveOrder(SaveOrderInputModel saveOrder) async {
    final conn = await _connection.openConnection();

    // transacao: qdo é necessário interagir com duas tabelas o ideal é utilizar uma transação.
    // Transação => é um encapsulamento do processo como um todo e caso ocorra alguma falha em sua execução o banco faz
    // o RollBack de todo o processo.

    try {
      await conn.transaction(
        (_) async {
          final resultOrder = await conn.query(
            '''
          insert into pedido(
            id_usuario, 
            forma_pagamento, 
            endereco_entrega
            ) values (?,?,?)
        ''',
            [
              saveOrder.userId,
              saveOrder.paymentType,
              saveOrder.address,
            ],
          );

          // pegar o id do insert acima
          final orderId = resultOrder.insertId;

          //insert na segunda tabela
          await conn.queryMulti(
            '''
            insert into pedido_item(
              id_pedido,
              id_cardapio_grupo_item
            ) values(?,?)
          ''',
            saveOrder.itemsId.map((item) => [orderId, item]),
          );
        },
      );
    } on MySqlException catch (e) {
      print(e);
      throw DatabaseErrorException(message: 'Erro ao inserir order');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Order>> findMyOrders(int userId) async {
    final conn = await _connection.openConnection();

    final orders = <Order>[];

    try {
      final ordersResult = await conn.query('''
        select * from pedido where id_usuario = ?
      ''', [userId]);

      if (ordersResult.isNotEmpty) {
        for (var orderResult in ordersResult) {
          final orderData = orderResult.fields;

          final orderItemsResult = await conn.query('''
          select
          *
          from pedido_item p
          inner join cardapio_grupo_item item on item.id_cardapio_grupo_item = p.id_cardapio_grupo_item
          where p.id_pedido = ?
          ''', [orderData['id_pedido']]);

          final items = orderItemsResult.map<OrderItem>((item) {
            final itemFields = item.fields;
            return OrderItem(
              id: itemFields['id_pedido_item'],
              item: MenuItem(
                  id: itemFields['id_cardapio_grupo_item'] as int,
                  name: itemFields['nome'],
                  price: itemFields['valor']),
            );
          }).toList();
          final order = Order(
            id: orderData['id_pedido'] as int,
            address: (orderData['endereco_entrega'] as Blob).toString(),
            paymentType: orderData['forma_pagamento'] as String,
            items: items,
          );
          orders.add(order);
        }
      }
      return orders;
    } on MySqlException catch (e) {
      print(e);
      throw DatabaseErrorException(message: 'Erro ao buscar orders');
    }
  }
}
