import 'package:flutter/material.dart';

import '../api/apicall.dart';
import '../model/product.dart';
import '../utils/localcart/addtocart.dart';
import 'cartview.dart';
import 'detailspage.dart';
import 'searchproduct.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;
  late Future<List<Product>> _productByCategory;
  late Future<List> _category;
  late Future<int> _cartCount;
  bool button = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = Apicall().fetchProducts();
    _category = Apicall().getcategoryAll();
    _cartCount = CartService().getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text('Homepage'),
        backgroundColor: Colors.amberAccent,
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cartpage');
                  },
                  icon: const Icon(Icons.card_travel)),
              FutureBuilder<int>(
                future: _cartCount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else if (!snapshot.hasData) {
                    return const Icon(Icons.shopping_cart);
                  }

                  final cartCount = snapshot.data!;
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _productsFuture.then((products) {
                showSearch(
                  delegate: ProductSearchDelegate(products),
                  context: context,
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
              height: 55,
              child: FutureBuilder<List>(
                  future: _category,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }

                    final category = snapshot.data!;

                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    button = true;
                                  });

                                  _productByCategory = Apicall()
                                      .fetchProductsByCategory(
                                          cateogryName: category[index]);
                                },
                                child: Text(category[index])),
                          );
                        });
                  })),
          const SizedBox(
            height: 24,
          ),
          button
              ? Expanded(
                  child: FutureBuilder<List<Product>>(
                    future: _productByCategory,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found.'));
                      }

                      final products = snapshot.data!;

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Detailpage(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.network(
                                      product.image,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '₹${product.price}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  AnimatedRatingStars(
                                    initialRating: product.rating.rate,
                                    minRating: 0.0,
                                    maxRating: 5.0,
                                    filledColor: Colors.amber,
                                    emptyColor: Colors.grey,
                                    filledIcon: Icons.star,
                                    halfFilledIcon: Icons.star_half,
                                    emptyIcon: Icons.star_border,
                                    onChanged: (double rating) {},
                                    displayRatingValue: false,
                                    interactiveTooltips: false,
                                    customFilledIcon: Icons.star,
                                    customHalfFilledIcon: Icons.star_half,
                                    customEmptyIcon: Icons.star_border,
                                    starSize: 10.0,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    animationCurve: Curves.easeInOut,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  child: FutureBuilder<List<Product>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found.'));
                      }

                      final products = snapshot.data!;

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Detailpage(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.network(
                                      product.image,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '₹${product.price}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  AnimatedRatingStars(
                                    initialRating: product.rating.rate,
                                    minRating: 0.0,
                                    maxRating: 5.0,
                                    filledColor: Colors.amber,
                                    emptyColor: Colors.grey,
                                    filledIcon: Icons.star,
                                    halfFilledIcon: Icons.star_half,
                                    emptyIcon: Icons.star_border,
                                    onChanged: (double rating) {},
                                    displayRatingValue: false,
                                    interactiveTooltips: false,
                                    customFilledIcon: Icons.star,
                                    customHalfFilledIcon: Icons.star_half,
                                    customEmptyIcon: Icons.star_border,
                                    starSize: 10.0,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    animationCurve: Curves.easeInOut,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
