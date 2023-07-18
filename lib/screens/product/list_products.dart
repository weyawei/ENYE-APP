import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class listProductsPage extends StatefulWidget {
  static const String routeName = '/catalog';

  Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: listProductsPage.routeName),
      builder: (_) => listProductsPage(prodSubCat: prodSubCat,),
    );
  }

  final productSubCategory prodSubCat;
  const listProductsPage({required this.prodSubCat});

  @override
  State<listProductsPage> createState() => _listProductsPageState();
}

class _listProductsPageState extends State<listProductsPage> {
  List<product> _products = [];

  @override
  void initState() {
    _getProducts();
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product;
      });
      print("Length ${product.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png',),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Type of ${widget.prodSubCat.name}'.toUpperCase(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),

            SizedBox(height: 20,),
            productCarousel(
              products: _products.where((product) =>
                product.category_id == widget.prodSubCat.category_id &&
                product.subCategory_id == widget.prodSubCat.id
              ).toList(),
            ),
          ],
        )
    );
  }
}

