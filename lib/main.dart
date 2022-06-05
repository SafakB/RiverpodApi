import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/model/list_model.dart';
import 'package:providers/providers/basic.dart';

void main() {
  runApp( const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}


class HomeScreen extends ConsumerWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(futureProductProvider);
    final products2 = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riverpod Test App"),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () => false,
                icon: Text(ref.watch(counterProvider).toString(),style: const TextStyle(fontSize: 18),)
              );
            },
          )
        ],    
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
           onPressed: (){
              ref.read(counterProvider.notifier).state++;
              final oldData = ref.read(productProvider);
              ref.read(productProvider.notifier).state = [
                ...oldData,
                ProductsModel(id: 1, title: "test 1", description: "asdsad",thumbnail: "asda", stock: 1)
              ];
            },
          child: const Icon(CupertinoIcons.add),
        );
        },
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: products.when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(data[index].title),
                        subtitle: Text(data[index].description),
                      ),
                    );
                  },
                );
              },
              error: (err,stck){
                return Center(child: Text(err.toString()));
              },
              loading: ()=>const Center(child: CupertinoActivityIndicator())
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: products2.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(products2[index].title),
                    subtitle: Text(products2[index].description),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


