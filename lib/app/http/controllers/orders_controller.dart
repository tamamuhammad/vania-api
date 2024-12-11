import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/order.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class OrdersController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        "order_num": "required|numeric",
        "cust_id": "required|max_length:5",
      });

      final orderData = request.input();

      final order = await Order()
          .query()
          .where('order_num', '=', orderData['order_num'])
          .first();

      if (order != null) {
        return Response.json(
            {"message": "Order dengan ID tersebut sudah ada"}, 409);
      }

      orderData['created_at'] = DateTime.now().toIso8601String();

      await Order().query().insert(orderData);

      return Response.json(
          {"message": "Order berhasil ditambahkan", "data": orderData}, 200);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({"error": e.message}, 400);
      } else {
        return Response.json(
            {"message": "Terjadi kesalahan di sisi server"}, 500);
      }
    }
  }

  Future<Response> show() async {
    try {
      final orderData = await Order().query().get();

      return Response.json({"message": "Daftar Order", "data": orderData}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data order",
        "error": e.toString()
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        "order_num": "required|numeric",
        "cust_id": "required|max_length:5",
      });

      final orderData = request.input();
      orderData['updated_at'] = DateTime.now().toIso8601String();

      final order = await Order()
          .query()
          .where('order_num', '=', orderData['order_num'])
          .first();

      if (order == null) {
        return Response.json(
            {"message": "Order dengan ID tersebut tidak ada"}, 404);
      }

      await Order().query().update(orderData);

      return Response.json(
          {"message": "Order berhasil diubah", "data": orderData}, 200);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({"error": e.message}, 400);
      } else {
        return Response.json(
            {"message": "Terjadi kesalahan di sisi server"}, 500);
      }
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final orderData =
          await Order().query().where('order_num', '=', id).first();

      if (orderData == null) {
        return Response.json(
            {"message": "Order dengan ID tersebut tidak ada"}, 404);
      }

      await Order().query().where('order_num', '=', id).delete();

      return Response.json({"message": "Order berhasil dihapus"}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan di sisi server",
        "error": e.toString()
      }, 500);
    }
  }
}

final OrdersController ordersController = OrdersController();
