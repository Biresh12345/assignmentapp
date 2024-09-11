import 'package:assignmentapp/screens/homepage.dart';
import 'package:assignmentapp/screens/loginpage.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';

class CheckOutPage extends StatefulWidget {
  final List<Product> product;
  CheckOutPage({super.key, required this.product});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotalprice();
  }

  void calculateTotalprice() {
    double total = 0.0;
    for (var product in widget.product) {
      total += product.price;
    }
    setState(() {
      totalprice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.product.length,
              itemBuilder: (context, index) {
                var data = widget.product[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Image.network(data.image),
                      title: Text(data.title),
                      trailing: Text(
                        '₹ ${data.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Buy : ₹ ${totalprice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
