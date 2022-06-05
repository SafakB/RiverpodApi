import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/model/list_model.dart';
import 'package:providers/services/api_service.dart';


// Static data in provider
// not using in this project
final basicProvider = Provider<int>((ref) {
  return 5;
});

// Dynamic data in provider
final counterProvider = StateProvider<int>((ref) {
  return 0;
});

// use .when func in widgets
final futureProductProvider = FutureProvider<List<ProductsModel>>((ref) async {
  List<ProductsModel> products = [ProductsModel(id: 1, title: "test 1", description: "asdsad",thumbnail: "asda", stock: 1)];
  final response = await ApiService().getData();
  for (var p in response) {
    products.add(ProductsModel(id: p['id'], title: p['title'], description: p['description'], thumbnail: p['thumbnail'], stock: p['stock']));
  }
  //write data at other provider
  ref.read(productProvider.notifier).state = products;
  ref.read(productNotifierProvider.notifier).loadBulk(products);
  ref.read(counterProvider.notifier).state = products.length;
  return products;
});


// local and cache provider.
// standart using provider process
final productProvider = StateProvider<List<ProductsModel>>((ref) {
  return [];
});



// Local and cache provider with notifier

final productNotifierProvider = StateNotifierProvider.autoDispose<ProductNotifier,List<ProductsModel>>((ref) {
  return ProductNotifier([]);
});


class ProductNotifier extends StateNotifier<List<ProductsModel>>{
  ProductNotifier(List<ProductsModel> state) : super(state);

  void loadBulk(List<ProductsModel> bulk){
    state = bulk;
  }

  void addProduct(ProductsModel product){
    state = [product,...state];
  }

  void deleteProduct(ProductsModel product){
    state = state.where((element) => element.id != product.id).toList();
  }

}