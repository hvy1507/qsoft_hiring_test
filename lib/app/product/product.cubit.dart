import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qsoft_hiring_test/app/product/product.state.dart';
import 'package:qsoft_hiring_test/model/product.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState());

  Future<void> loadProducts({bool refresh = false}) async {
    if (state.isLoading) return;
    if (refresh) {
      emit(ProductState(isLoading: true));
    } else {
      emit(state.copyWith(isLoading: true));
    }
    try {
      await Future.delayed(const Duration(seconds: 2));
      final newProducts = await _fetchProducts(
        refresh ? 1 : state.currentPage,
      );
      final updatedHotProducts = refresh
          ? newProducts.where((p) => p.isHot).toList()
          : [
              ...state.hotProducts,
              ...newProducts.where(
                (p) => p.isHot,
              )
            ];
      if (refresh) {
        emit(ProductState(
          allProducts: newProducts,
          hotProducts: updatedHotProducts,
          isLoading: false,
          currentPage: 1,
          hasReachedMax: newProducts.length < 10,
        ));
      } else {
        emit(state.copyWith(
          allProducts: [...state.allProducts, ...newProducts],
          hotProducts: updatedHotProducts,
          isLoading: false,
          currentPage: state.currentPage + 1,
          hasReachedMax: newProducts.length < 10,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
  Future<List<Product>> _fetchProducts(int page) async {
    final startIndex = (page - 1) * 10;
    return List.generate(
      10,
      (index) => Product(
        id: '${startIndex + index + 1}',
        name: 'Product ${startIndex + index + 1}',
        imageUrl:
            'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/63c77c04dc6448548ccbae880189e107_9366/Galaxy_6_Shoes_Black_GW3848_01_standard.jpg',
        price: (startIndex + index + 1) * 10.0,
        isHot: (startIndex + index + 1) % 3 == 0,
      ),
    );
  }
}
