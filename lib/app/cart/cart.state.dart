import 'package:qsoft_hiring_test/model/cart_items.dart';

class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  double get totalPrice => items.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}