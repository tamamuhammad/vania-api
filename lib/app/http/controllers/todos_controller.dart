import 'package:vania/vania.dart';
import 'package:vania_exam/app/models/user.dart';

class TodosController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    request.validate({
      'title': 'required',
      'description': 'required'
    }, {
      'title.required': 'judul todo wajib diisi',
      'description.required': 'deskripsi todo wajib diisi'
    });

    Map<String, dynamic> data = request.all();
    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      var todo = await User().query().create({
        'user_id': Auth().id(),
        'title': data['title'],
        'description': data['description']
      });

      return Response.json({
        'status': 'success',
        'message': 'todo berhasil dibuat',
        'data': todo
      }, 201);
    } else {
      return Response.json(
          {'status': 'error', 'message': 'Pengguna tidak terautitentikasi'},
          401);
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    return Response.json({});
  }
}

final TodosController todosController = TodosController();
