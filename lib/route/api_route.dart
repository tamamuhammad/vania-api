import 'package:vania/vania.dart';
import 'package:vania_exam/app/http/controllers/customers_controller.dart';
import 'package:vania_exam/app/http/controllers/orderitems_controller.dart';
import 'package:vania_exam/app/http/controllers/orders_controller.dart';
import 'package:vania_exam/app/http/controllers/productnotes_controller.dart';
import 'package:vania_exam/app/http/controllers/products_controller.dart';
import 'package:vania_exam/app/http/controllers/vendors_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix

    Router.post('/customer', customersController.store);
    Router.get('/customer', customersController.show);
    Router.put('/customer/{id}', customersController.update);
    Router.delete('/customer/{id}', customersController.destroy);

    Router.post('/order', ordersController.store);
    Router.get('/order', ordersController.show);
    Router.put('/order/{id}', ordersController.update);
    Router.delete('/order/{id}', ordersController.destroy);

    Router.post('/orderitem', orderitemsController.store);
    Router.get('/orderitem', orderitemsController.show);
    Router.put('/orderitem/{id}', orderitemsController.update);
    Router.delete('/orderitem/{id}', orderitemsController.destroy);

    Router.post('/vendor', vendorsController.store);
    Router.get('/vendor', vendorsController.show);
    Router.put('/vendor/{id}', vendorsController.update);
    Router.delete('/vendor/{id}', vendorsController.destroy);

    Router.post('/product', productsController.store);
    Router.get('/product', productsController.show);
    Router.put('/product/{id}', productsController.update);
    Router.delete('/product/{id}', productsController.destroy);

    Router.post('/productnote', productnotesController.store);
    Router.get('/productnote', productnotesController.show);
    Router.put('/productnote/{id}', productnotesController.update);
    Router.delete('/productnote/{id}', productnotesController.destroy);
  }
}
