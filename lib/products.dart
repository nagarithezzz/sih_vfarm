import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vfarm/product_detail.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: _myListView(context), // Use the ListView here
    );
  }

  // Function to build the ListView
  Widget _myListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/rice.jpeg'),
          ),
          title: const Text('Rice'),
          subtitle: const Text('This is the Rice product'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductDetailsPage(
                  title: 'Rice',
                  imagePath: 'assets/rice.jpeg',
                  description: 'This is the Rice product',
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/wheat.jpeg'),
          ),
          title: const Text('Wheat'),
          subtitle: const Text('This is the Wheat product'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductDetailsPage(
                  title: 'Wheat',
                  imagePath: 'assets/wheat.jpeg',
                  description: 'This is the Wheat product',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
