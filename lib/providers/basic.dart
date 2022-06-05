import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/model/list_model.dart';
import 'package:providers/services/api_service.dart';


// Bu data sabittir
final basicProvider = Provider<int>((ref) {
  return 5;
});

// Bu data state olarak değiştirilir.
final counterProvider = StateProvider<int>((ref) {
  return 5;
});


// FutureProvider ile widget içinde .when ile sorunsuz çekebiliyoruz
final futureProductProvider = FutureProvider<List<ProductsModel>>((ref) async {
  List<ProductsModel> products = [ProductsModel(id: 1, title: "test 1", description: "asdsad",thumbnail: "asda", stock: 1)];
  final response = await ApiService().getData();
  for (var p in response) {
    products.add(ProductsModel(id: p['id'], title: p['title'], description: p['description'], thumbnail: p['thumbnail'], stock: p['stock']));
  }
  ref.read(productProvider.notifier).state = products;
  return products;
});


// araya local provider koyacağız
final productProvider = StateProvider<List<ProductsModel>>((ref) {
  return [];
});