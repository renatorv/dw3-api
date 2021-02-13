import 'package:dw3_pizza_delivery_api/application/database/i_database_connection.dart';
import 'package:dw3_pizza_delivery_api/application/exceptions/database_error_exception.dart';
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
}
