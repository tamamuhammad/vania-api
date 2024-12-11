import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/product.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        "prod_id": "required|string|max_length:10",
        "vend_id": "required|max_length:5",
        "prod_name": "required|string|max_length:25",
        "prod_price": "required|numeric",
        "prod_desc": "required|string",
      });

      final productData = request.input();

      final product = await Product()
          .query()
          .where('prod_id', '=', productData['prod_id'])
          .first();

      if (product != null) {
        return Response.json(
            {"message": "Product dengan ID tersebut sudah ada"}, 409);
      }

      productData['created_at'] = DateTime.now().toIso8601String();

      await Product().query().insert(productData);

      return Response.json(
          {"message": "Product berhasil ditambahkan", "data": productData},
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
      final productData = await Product().query().get();

      return Response.json(
          {"message": "Daftar Product", "data": productData}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data product",
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
        "prod_id": "required|string|max_length:10",
        "vend_id": "required|max_length:5",
        "prod_name": "required|string|max_length:25",
        "prod_price": "required|numeric",
        "prod_desc": "required|string",
      });

      final productData = request.input();
      productData['updated_at'] = DateTime.now().toIso8601String();

      final product = await Product()
          .query()
          .where('prod_id', '=', productData['prod_id'])
          .first();

      if (product == null) {
        return Response.json(
            {"message": "Product dengan ID tersebut tidak ada"}, 404);
      }

      await Product().query().update(productData);

      return Response.json(
          {"message": "Product berhasil diubah", "data": productData}, 200);
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
      final productData =
          await Product().query().where('prod_id', '=', id).first();

      if (productData == null) {
        return Response.json(
            {"message": "Product dengan ID tersebut tidak ada"}, 404);
      }

      await Product().query().where('prod_id', '=', id).delete();

      return Response.json({"message": "Product berhasil dihapus"}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan di sisi server",
        "error": e.toString()
      }, 500);
    }
  }
}

final ProductsController productsController = ProductsController();
