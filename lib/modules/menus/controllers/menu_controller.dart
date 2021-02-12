
import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'menu_controller.g.dart';

@Injectable()
class MenuController {

   @Route.get('/')
   Future<Response> findAll(Request request) async { 
      return Response.ok(jsonEncode(''));
   }

   Router get router => _$MenuControllerRouter(this);
}