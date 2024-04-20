import 'package:equatable/equatable.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/models/product_model/status.dart';
part of 'qr_bloc.dart';


class ProductState extends Equatable {
  final FormStatus status;
  final String statusText;

  final List<ProductModel> products;

  const ProductState({
    required this.status,
    required this.products,
    required this.statusText,
  });

  ProductState copyWith({
    FormStatus? status,
    String? statusText,
    List<ProductModel>? products,
  }) =>
      ProductState(
        status: status ?? this.status,
        products: products ?? this.products,
        statusText: statusText ?? this.statusText,
      );

  @override
  List<Object?> get props => [
    status,
    products,
    statusText,
  ];
}