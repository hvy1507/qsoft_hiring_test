import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qsoft_hiring_test/app/cart/cart.state.dart';
import 'package:qsoft_hiring_test/model/cart_items.dart';
import 'package:qsoft_hiring_test/model/product.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  void addToCart(Product product, int quantity) {
    final currentState = state;
    final existingIndex =
        currentState.items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final updatedItems = List<CartItem>.from(currentState.items);
      updatedItems[existingIndex].quantity += quantity;
      emit(CartState(items: updatedItems));
    } else {
      emit(CartState(
        items: [
          ...currentState.items,
          CartItem(product: product, quantity: quantity)
        ],
      ));
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: newQuantity);
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void removeFromCart(String productId) {
    final updatedItems =
        state.items.where((item) => item.product.id != productId).toList();
    emit(CartState(items: updatedItems));
  }

  void clearCart() {
    emit(CartState());
  }
}
