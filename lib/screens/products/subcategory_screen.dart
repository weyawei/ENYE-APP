import 'package:enye_app/screens/products/subcategory_card.dart';
import 'package:enye_app/screens/products/subcategory_model.dart';
import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/widget/widgets.dart';

import '../products/category_model.dart';
import '../products/product_model.dart';

class SubCategoryScreen extends StatelessWidget {
  static const String routeName = '/subcategory';

  static Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SubCategoryScreen(),
    );
  }
  const SubCategoryScreen();

  @override
  Widget build(BuildContext context) {
    final filteredCategories = ModalRoute.of(context)?.settings?.arguments as Map<String, String>; //list pansamantala
    final CategName = filteredCategories['name'].toString(); //fetch name from carousel_card through arguments
    final subCat = filteredCategories['subcategory'].toString();

    List<Category1> categories = [];

    //detailedProjects = projectList.where((projectList) => projectList.proj_id == projId).toList();
    final List<SubCategory> categoryProducts = SubCategory.categories.where((product) => product.category == CategName).toList();
    return Scaffold(
        appBar: CustomAppBar(title: '$CategName', imagePath: '',),
        body: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.15),
            itemCount: categoryProducts.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: SubCategoryCard(
                  subcategory: categoryProducts[index],
                  widthFactor: 2.2,
                ),
              );
            }

        )
    );
  }
}