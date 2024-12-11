import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/customer.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class CustomersController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        "cust_id": "required|max_length:5",
        "cust_name": "required|string|max_length:50",
        "cust_address": "required|string|max_length:50",
        "cust_city": "required|string|max_length:20",
        "cust_state": "required|string|max_length:5",
        "cust_zip": "required|string|max_length:7",
        "cust_country": "required|string|max_length:25",
        "cust_telp": "required|string|max_length:15"
      });

      final custData = request.input();

      final customer = await Customer()
          .query()
          .where('cust_id', '=', custData['cust_id'])
          .first();

      if (customer != null) {
        return Response.json(
            {"message": "Customer dengan ID tersebut sudah ada"}, 409);
      }

      custData['created_at'] = DateTime.now().toIso8601String();

      await Customer().query().insert(custData);

      return Response.json(
          {"message": "Customer berhasil ditambahkan", "data": custData}, 200);
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
      final custData = await Customer().query().get();

      return Response.json(
          {"message": "Daftar Customer", "data": custData}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data customer",
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
        "cust_id": "required|max_length:5",
        "cust_name": "required|string|max_length:50",
        "cust_address": "required|string|max_length:50",
        "cust_city": "required|string|max_length:20",
        "cust_state": "required|string|max_length:5",
        "cust_zip": "required|string|max_length:7",
        "cust_country": "required|string|max_length:25",
        "cust_telp": "required|string|max_length:15"
      });

      final custData = request.input();
      custData['updated_at'] = DateTime.now().toIso8601String();

      final customer = await Customer()
          .query()
          .where('cust_id', '=', custData['cust_id'])
          .first();

      if (customer == null) {
        return Response.json(
            {"message": "Customer dengan ID tersebut tidak ada"}, 404);
      }

      await Customer().query().update(custData);

      return Response.json(
          {"message": "Customer berhasil diubah", "data": custData}, 200);
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
      final custData =
          await Customer().query().where('cust_id', '=', id).first();

      if (custData == null) {
        return Response.json(
            {"message": "User dengan ID tersebut tidak ada"}, 404);
      }

      await Customer().query().where('cust_id', '=', id).delete();

      return Response.json({"message": "Customer berhasil dihapus"}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan di sisi server",
        "error": e.toString()
      }, 500);
    }
  }
}

final CustomersController customersController = CustomersController();
