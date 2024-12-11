import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/productnote.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductnotesController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        "note_id": "required|max_length:5",
        "prod_id": "required|string|max_length:10",
        "note_text": "required|string",
      });

      final productNote = request.input();

      final note = await Productnote()
          .query()
          .where('note_id', '=', productNote['note_id'])
          .first();

      if (note != null) {
        return Response.json(
            {"message": "Product note dengan ID tersebut sudah ada"}, 409);
      }

      productNote['created_at'] = DateTime.now().toIso8601String();

      await Productnote().query().insert(productNote);

      return Response.json(
          {"message": "Product note berhasil ditambahkan", "data": productNote},
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
      final productNote = await Productnote().query().get();

      return Response.json(
          {"message": "Daftar Product Note", "data": productNote}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data product note",
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
        "note_id": "required|max_length:5",
        "prod_id": "required|string|max_length:10",
        "note_text": "required|string",
      });

      final productNote = request.input();
      productNote['updated_at'] = DateTime.now().toIso8601String();

      final note = await Productnote()
          .query()
          .where('note_id', '=', productNote['note_id'])
          .first();

      if (note == null) {
        return Response.json(
            {"message": "Product note dengan ID tersebut tidak ada"}, 404);
      }

      await Productnote().query().update(productNote);

      return Response.json(
          {"message": "Product note berhasil diubah", "data": productNote},
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

  Future<Response> destroy(int id) async {
    try {
      final productNote =
          await Productnote().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json(
            {"message": "Product note dengan ID tersebut tidak ada"}, 404);
      }

      await Productnote().query().where('note_id', '=', id).delete();

      return Response.json({"message": "Product note berhasil dihapus"}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan di sisi server",
        "error": e.toString()
      }, 500);
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();
