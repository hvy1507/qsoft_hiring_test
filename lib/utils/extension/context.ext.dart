import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtension on BuildContext {
  T getRepo<T>() {
    return RepositoryProvider.of<T>(this);
  }

  T getCubit<T extends Cubit>() {
    return BlocProvider.of<T>(this);
  }
}