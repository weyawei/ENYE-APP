

import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class productsPage extends StatefulWidget {
  static const String routeName = '/products';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => productsPage());
  }

  @override
  _productsPageState createState() => _productsPageState();
}

class _productsPageState extends State<productsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: 'assets/logo/enyecontrols.png'),
      drawer: productDrawer(),
      body: Container(),
    );
  }
}