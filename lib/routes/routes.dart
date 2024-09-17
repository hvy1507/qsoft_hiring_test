import 'package:go_router/go_router.dart';
import 'package:qsoft_hiring_test/app/cart/cart.view.dart';
import 'package:qsoft_hiring_test/app/home/home.view.dart';


final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);