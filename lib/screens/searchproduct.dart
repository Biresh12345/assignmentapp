import 'package:assignmentapp/screens/detailspage.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    return ListView(
      children: results
          .map((p) => ListTile(
                tileColor: Colors.amber,
                leading: Image.network(p.image),
                title: Text(p.title),
                subtitle: Text('₹${p.price.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Detailpage(
                      product: p,
                    ),
                  ));
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (suggestions.isEmpty) {
      return const Center(child: Text('No suggestions.'));
    }

    return ListView(
      children: suggestions
          .map((p) => ListTile(
                title: Text(p.title),
                subtitle: Text('₹${p.price.toStringAsFixed(2)}'),
                onTap: () {
                  query = p.title;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }
}
