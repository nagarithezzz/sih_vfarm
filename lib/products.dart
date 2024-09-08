import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Approved and Unapproved
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          backgroundColor: Colors.green,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Approved'), // First Tab
              Tab(text: 'Unapproved'), // Second Tab
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ApprovedProductsTab(), // Content for Approved tab
            UnapprovedProductsTab(), // Content for Unapproved tab
          ],
        ),
        backgroundColor: Colors.grey[100], // Light background color
      ),
    );
  }
}

// Widget for displaying Approved Products
class ApprovedProductsTab extends StatelessWidget {
  const ApprovedProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Add padding around the ListView
      child: ListView(
        children: <Widget>[
          _buildProductCard(
            context,
            title: 'Rice',
            imagePath: 'assets/rice.jpeg',
            description: 'This is the Rice product',
          ),
          _buildProductCard(
            context,
            title: 'Wheat',
            imagePath: 'assets/wheat.jpeg',
            description: 'This is the Wheat product',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context,
      {required String title,
      required String imagePath,
      required String description}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(description),
        onTap: () {
          _showProductPopup(context, title, imagePath, description);
        },
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.green,
        ),
      ),
    );
  }

  void _showProductPopup(BuildContext context, String title, String imagePath,
      String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height: MediaQuery.of(context).size.height *
                0.5, // 50% of screen height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    imagePath,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget for displaying Unapproved Products
class UnapprovedProductsTab extends StatelessWidget {
  const UnapprovedProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Add padding around the ListView
      child: ListView(
        children: <Widget>[
          _buildProductCard(
            context,
            title: 'Corn',
            imagePath: 'assets/corn.jpeg',
            description: 'This is the Corn product',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context,
      {required String title,
      required String imagePath,
      required String description}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(description),
        onTap: () {
          _showProductPopup(context, title, imagePath, description);
        },
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.green,
        ),
      ),
    );
  }

  void _showProductPopup(BuildContext context, String title, String imagePath,
      String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width:
                MediaQuery.of(context).size.width * 0.6, // 80% of screen width
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    imagePath,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
