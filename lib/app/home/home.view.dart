import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qsoft_hiring_test/app/cart/cart.cubit.dart';
import 'package:qsoft_hiring_test/app/cart/cart.state.dart';
import 'package:qsoft_hiring_test/app/product/product.cubit.dart';
import 'package:qsoft_hiring_test/app/product/product.state.dart';
import 'package:qsoft_hiring_test/component/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
    _scrollController.addListener(_onScroll);
  }
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductCubit>().loadProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody()
    );
  }
  AppBar _buildAppBar() => AppBar(
    title: const Text('Home'),
    backgroundColor: Colors.orange,
    actions: [
      Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return state.totalQuantity > 0
                    ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${state.totalQuantity}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                )
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    ],
  );
  Widget _buildBody() => RefreshIndicator(
    onRefresh: () async {
      await context.read<ProductCubit>().loadProducts(refresh: true);
    },
    child: BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'HOT Products 🔥',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.hotProducts.length,
                      itemBuilder: (context, index) {
                        return AspectRatio(
                          aspectRatio: 0.75,
                          child: ProductItem(
                            product: state.hotProducts[index],
                            isHot: true,
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All Products',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return ProductItem(product: state.allProducts[index]);
                },
                childCount: state.allProducts.length,
              ),
            ),
            SliverToBoxAdapter(
              child: state.isLoading
                  ? const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ))
                  : state.hasReachedMax
                  ? const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No more products'),
              ))
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    ),
  );
}