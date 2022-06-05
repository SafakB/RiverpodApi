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
    final products3 = ref.watch(productNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () => ref.refresh(futureProductProvider),
                icon: Row(
                  children: [
                    Text(ref.watch(counterProvider).toString(),style: const TextStyle(fontSize: 18),),
                    const Icon(CupertinoIcons.refresh,size: 15,)
                  ],
                )
              );
            },
          ),
        title: Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () => ref.refresh(productProvider),
                icon: Row(
                  children: [
                    Text(ref.watch(productProvider).length.toString(),style: const TextStyle(fontSize: 18),),
                    const Icon(CupertinoIcons.refresh,size: 11,)
                  ],
                )
              );
            },
          ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () => ref.refresh(productNotifierProvider),
                icon: Row(
                  children: [
                    Text(ref.watch(productNotifierProvider).length.toString(),style: const TextStyle(fontSize: 18),),
                    const Icon(CupertinoIcons.refresh,size: 11,)
                  ],
                )
              );
            },
          )
        ],    
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
           onPressed: (){
              ref.read(productNotifierProvider.notifier).addProduct(ProductsModel(id: 1, title: "test 1", description: "asdsad",thumbnail: "asda", stock: 1));
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
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: products3.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(products3[index].title),
                    subtitle: Text(products3[index].description),
                    trailing: GestureDetector(
                      onTap: (){
                        // API DELETE ACTIONS
                        // if true
                        ref.read(productNotifierProvider.notifier).deleteProduct(products3[index]);

                        // for refresh future provider
                        //ref.refresh(futureProductProvider);
                        //ref.refresh(productProvider);
                        //ref.refresh(productNotifierProvider);
                      },
                      child: const Icon(CupertinoIcons.delete,color: Colors.red,),
                    ),
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


