import 'package:dw3_pizza_delivery_api/application/config/database_connection_configuration.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/src/single_connection.dart';

import './i_database_connection.dart';
	
@Injectable(as: IDatabaseConnection)
class DatabaseConnection implements  IDatabaseConnection {
  final DatabaseConnectionConfiguration _configuration;

  DatabaseConnection(this._configuration);

  @override
  Future<MySqlConnection> openConnection() {

    return MySqlConnection.connect(ConnectionSettings(
      host: _configuration.host,
      port: int.parse(_configuration.port),
      user: _configuration.user,
      password: _configuration.password,
      db: _configuration.databaseName,
    ));

  }
}