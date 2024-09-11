import 'package:assignmentapp/screens/cartview.dart';
import 'package:assignmentapp/screens/homepage.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../utils/localcart/addtocart.dart';

class Detailpage extends StatefulWidget {
  final Product product;
  const Detailpage({super.key, required this.product});

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  final CartService _cart = CartService();
  late Future<bool> _isInCart;

  @override
  void initState() {
    _isInCart = _cart.isProductInCart(widget.product);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.product.image,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.product.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.category,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${widget.product.rating.rate}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "(${widget.product.rating.count} Reviews)",
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.product.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    "${widget.product.price.toString()} ₹",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<bool>(
                    future: _isInCart,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('Unknown error.'));
                      }

                      final isInCart = snapshot.data!;

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            backgroundColor: Colors.orange),
                        onPressed: () async {
                          if (isInCart) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Product is already in the cart.')),
                            );
                          } else {
                            await _cart.addToCart(widget.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Product added to cart.')),
                            );
                            setState(() {
                              _isInCart = _cart.isProductInCart(widget.product);
                            });
                          }
                        },
                        child:
                            Text(isInCart ? 'Remove from Cart' : 'Add to Cart'),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
