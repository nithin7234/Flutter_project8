import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Product Search using Firestore",
    home: ProductSearchScreen(),
  ));
}

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});
  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _statusMessage = "";
  Map<String, dynamic>? _productData;
  bool _loading = false;

  Future<void> _searchProduct() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _statusMessage = "Please enter a product name.";
        _productData = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _statusMessage = "";
      _productData = null;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _statusMessage = "Product not found";
          _productData = null;
        });
      } else {
        final product = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _statusMessage = "";
          _productData = product;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error searching product: $e";
        _productData = null;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Search using Firestore"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Enter product name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _searchProduct,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Search"),
              ),
            ),
            const SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Text(
                _statusMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (_productData != null) ...[
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.only(top: 20),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${_productData!['name']}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Quantity: ${_productData!['quantity']}"),
                        Text("Price: ₹${_productData!['price']}"),
                        if (((_productData!['quantity'] as num?) ?? 0) < 5)
                          const Text(
                            "Low Stock!",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
