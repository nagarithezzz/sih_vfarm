import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vfarm/products.dart';

class ProductDetailsPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;

  const ProductDetailsPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for editing the product details
              },
              child: const Text('Edit Product'),
            ),
          ],
        ),
      ),
    );
  }
}
