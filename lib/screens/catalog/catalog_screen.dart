import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/widget/widgets.dart';

import '../products/category_model.dart';

class CatalogScreen extends StatelessWidget {
  static const String routeName = '/catalog';

  static Route route({required Category1 category}){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogScreen(category: category),
    );
  }
  final Category1 category;
  const CatalogScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Catalog', imagePath: '',),
      body: Container(),
    );
  }
}
