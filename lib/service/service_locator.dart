import 'package:get_it/get_it.dart';
import '../data/repository/product_repository.dart';

var getIt = GetIt.I;

void setUp() {
  getIt.registerSingleton<ProductRepository>(ProductRepository());
}