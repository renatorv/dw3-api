// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../database/database_connection.dart';
import 'database_connection_configuration.dart';
import '../database/i_database_connection.dart';
import '../../repositories/menu/i_menu_repository.dart';
import '../../services/menu/i_menu_sevice.dart';
import '../../repositories/order/i_orders_repository.dart';
import '../../services/order/i_orders_service.dart';
import '../../repositories/user/i_user_repository.dart';
import '../../services/user/i_user_service.dart';
import '../../modules/menus/controllers/menu_controller.dart';
import '../../repositories/menu/menu_repository.dart';
import '../../services/menu/menu_sevice.dart';
import '../../repositories/order/orders_repository.dart';
import '../../services/order/orders_service.dart';
import '../../modules/users/controller/user_controller.dart';
import '../../repositories/user/user_repository.dart';
import '../../services/user/user_service.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.factory<IDatabaseConnection>(
      () => DatabaseConnection(get<DatabaseConnectionConfiguration>()));
  gh.lazySingleton<IMenuRepository>(
      () => MenuRepository(get<IDatabaseConnection>()));
  gh.lazySingleton<IMenuSevice>(() => MenuSevice(get<IMenuRepository>()));
  gh.lazySingleton<IOrdersRepository>(
      () => OrdersRepository(get<IDatabaseConnection>()));
  gh.lazySingleton<IOrdersService>(
      () => OrdersService(get<IOrdersRepository>()));
  gh.lazySingleton<IUserRepository>(
      () => UserRepository(get<IDatabaseConnection>()));
  gh.lazySingleton<IUserService>(() => UserService(get<IUserRepository>()));
  gh.factory<MenuController>(() => MenuController(get<IMenuSevice>()));
  gh.factory<UserController>(() => UserController(get<IUserService>()));
  return get;
}
