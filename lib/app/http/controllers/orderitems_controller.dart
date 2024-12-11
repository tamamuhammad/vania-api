import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/orderitem.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class OrderitemsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        "order_item": "required|numeric",
        "order_num": "required|numeric",
        "prod_id": "required|string|max_length:10",
        "quantity": "required|numeric",
        "size": "required|numeric",
      });

      final orderItem = request.input();

      final item = await Orderitem()
          .query()
          .where('order_item', '=', orderItem['order_item'])
          .first();

      if (item != null) {
        return Response.json(
            {"message": "Item order dengan ID tersebut sudah ada"}, 409);
      }

      orderItem['created_at'] = DateTime.now().toIso8601String();

      await Orderitem().query().insert(orderItem);

      return Response.json(
          {"message": "Item order berhasil ditambahkan", "data": orderItem},
          200);
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
      final orderItem = await Orderitem().query().get();

      return Response.json(
          {"message": "Daftar Item Order", "data": orderItem}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data item order",
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
        "order_item": "required|numeric",
        "order_num": "required|numeric",
        "prod_id": "required|string|max_length:10",
        "quantity": "required|numeric",
        "size": "required|numeric",
      });

      final orderItem = request.input();
      orderItem['updated_at'] = DateTime.now().toIso8601String();

      final item = await Orderitem()
          .query()
          .where('order_item', '=', orderItem['order_item'])
          .first();

      if (item == null) {
        return Response.json(
            {"message": "Item order dengan ID tersebut tidak ada"}, 404);
      }

      await Orderitem().query().update(orderItem);

      return Response.json(
          {"message": "Item order berhasil diubah", "data": orderItem}, 200);
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
      final orderItem =
          await Orderitem().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json(
            {"message": "Item order dengan ID tersebut tidak ada"}, 404);
      }

      await Orderitem().query().where('order_item', '=', id).delete();

      return Response.json({"message": "Item order berhasil dihapus"}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan di sisi server",
        "error": e.toString()
      }, 500);
    }
  }
}

final OrderitemsController orderitemsController = OrderitemsController();
