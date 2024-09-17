import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qsoft_hiring_test/app/cart/cart.cubit.dart';
import 'package:qsoft_hiring_test/model/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final bool isHot;

  const ProductItem({super.key, required this.product, this.isHot = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isHorizontal = constraints.maxHeight < constraints.maxWidth;
        final cardWidth = isHorizontal ? constraints.maxHeight : constraints.maxWidth;
        return SizedBox(
          width: isHorizontal ? cardWidth : null,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${product.price.toStringAsFixed(0)} đ',
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
                          onPressed: () {
                            _showQuantityBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuantityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return QuantitySelector(
          product: product,
          onAdd: (quantity) {
            context.read<CartCubit>().addToCart(product, quantity);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final Product product;
  final Function(int) onAdd;

  const QuantitySelector({super.key, required this.product, required this.onAdd});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.network(widget.product.imageUrl, height: 50, width: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${widget.product.price.toStringAsFixed(0)} đ'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
              ),
              GestureDetector(
                onTap: () {
                  _showQuantityDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('$quantity'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (quantity < 999) setState(() => quantity++);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                widget.onAdd(quantity);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  backgroundColor: Colors.orangeAccent
              ),
              child: const Text('Add to cart'),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputQuantity = quantity.toString();
        return AlertDialog(
          title: const Text('Enter Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter quantity"),
            onChanged: (value) {
              inputQuantity = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                int newQuantity = int.tryParse(inputQuantity) ?? 1;
                if (newQuantity < 1) newQuantity = 1;
                if (newQuantity > 999) newQuantity = 999;
                setState(() {
                  quantity = newQuantity;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}