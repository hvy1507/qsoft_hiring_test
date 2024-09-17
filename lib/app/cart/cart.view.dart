import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qsoft_hiring_test/app/cart/cart.cubit.dart';
import 'package:qsoft_hiring_test/app/cart/cart.state.dart';
import 'package:qsoft_hiring_test/component/cart_item.view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Success'),
          content: const Text('Your order has been placed successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Back to Home'),
              onPressed: () {
                context.read<CartCubit>().clearCart();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Text('Cart (${state.totalQuantity})');
          },
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
  Widget _buildBody() => BlocBuilder<CartCubit, CartState>(
    builder: (context, state) {
      if (state.items.isEmpty) {
        return const Center(
          child: Text('Your cart is empty'),
        );
      }
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return CartItemWidget(
                  cartItem: item,
                  onRemove: () => context
                      .read<CartCubit>()
                      .removeFromCart(item.product.id),
                  onQuantityChanged: (newQuantity) {
                    if (newQuantity > 0) {
                      context
                          .read<CartCubit>()
                          .updateQuantity(item.product.id, newQuantity);
                    } else {
                      context
                          .read<CartCubit>()
                          .removeFromCart(item.product.id);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total price',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${state.totalPrice.toStringAsFixed(0)} đ',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      _showOrderSuccessDialog(context);
                    },
                    child: const Text('Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
