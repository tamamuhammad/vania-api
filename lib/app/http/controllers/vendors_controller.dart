import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/vendor.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class VendorsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        "vend_id": "required|max_length:5",
        "vend_name": "required|string|max_length:20",
        "vend_address": "required|string",
        "vend_city": "required|string",
        "vend_state": "required|string|max_length:5",
        "vend_zip": "required|string|max_length:7",
        "vend_country": "required|string|max_length:25",
      });

      final vendorData = request.input();

      final vendor = await Vendor()
          .query()
          .where('vend_id', '=', vendorData['vend_id'])
          .first();

      if (vendor != null) {
        return Response.json(
            {"message": "Vendor dengan ID tersebut sudah ada"}, 409);
      }

      vendorData['created_at'] = DateTime.now().toIso8601String();

      await Vendor().query().insert(vendorData);

      return Response.json(
          {"message": "Vendor berhasil ditambahkan", "data": vendorData}, 200);
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
      final vendorData = await Vendor().query().get();

      return Response.json(
          {"message": "Daftar Vendor", "data": vendorData}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data vendor",
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
        "vend_id": "required|max_length:5",
        "vend_name": "required|string|max_length:20",
        "vend_address": "required|string",
        "vend_city": "required|string",
        "vend_state": "required|string|max_length:5",
        "vend_zip": "required|string|max_length:7",
        "vend_country": "required|string|max_length:25",
      });

      final vendorData = request.input();
      vendorData['updated_at'] = DateTime.now().toIso8601String();

      final vendor = await Vendor()
          .query()
          .where('vend_id', '=', vendorData['vend_id'])
          .first();

      if (vendor == null) {
        return Response.json(
            {"message": "Vendor dengan ID tersebut tidak ada"}, 404);
      }

      await Vendor().query().update(vendorData);

      return Response.json(
          {"message": "Vendor berhasil diubah", "data": vendorData}, 200);
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
      final vendorData =
          await Vendor().query().where('vend_id', '=', id).first();

      if (vendorData == null) {
        return Response.json(
            {"message": "Vendor dengan ID tersebut tidak ada"}, 404);
      }

      await Vendor().query().where('vend_id', '=', id).delete();

      return Response.json({"message": "Vendor berhasil dihapus"}, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan di sisi server",
        "error": e.toString()
      }, 500);
    }
  }
}

final VendorsController vendorsController = VendorsController();
