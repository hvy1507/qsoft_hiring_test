import 'package:qsoft_hiring_test/model/product.dart';

class ProductState {
  final List<Product> allProducts;
  final List<Product> hotProducts;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;

  ProductState({
    this.allProducts = const [],
    this.hotProducts = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  ProductState copyWith({
    List<Product>? allProducts,
    List<Product>? hotProducts,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProductState(
      allProducts: allProducts ?? this.allProducts,
      hotProducts: hotProducts ?? this.hotProducts,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}