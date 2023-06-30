import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../products/category_model.dart';
import '../products/product_model.dart';

class CatalogScreen extends StatelessWidget {
  static const String routeName = '/catalog';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogScreen(),
    );
  }
  const CatalogScreen();

  @override
  Widget build(BuildContext context) {
    final filteredCategories = ModalRoute.of(context)?.settings?.arguments as Map<String, String>; //list pansamantala
    final CategName = filteredCategories['name'].toString(); //fetch name from carousel_card through arguments
    final subCat = filteredCategories['subcategory'].toString();

    List<Category1> categories = [];

    //detailedProjects = projectList.where((projectList) => projectList.proj_id == projId).toList();
    final List<Product> categoryProducts = Product.products.where((product) => product.subcategory == subCat).toList();
    return Scaffold(
      appBar: CustomAppBar(title: '$subCat', imagePath: '',),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.15),
          itemCount: categoryProducts.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: InkWell(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: CatalogScreen.routeName, arguments: {'subcategory': categoryProducts}),
                    screen: CatalogScreen(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: ProductCard(
                  product: categoryProducts[index],
                  widthFactor: 2.2,
    ),
              ),
            );
    }

      )
    );
  }
}
