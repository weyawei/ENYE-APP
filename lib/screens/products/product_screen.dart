

import 'package:enye_app/screens/products/product_model.dart';
import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {


  static const String routeName = '/product';

  static Route route({required Product product}){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductScreen(product: product)
    );
  }
final Product product;
  const ProductScreen({required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: product.name, imagePath: '',),
    );
  }
}
