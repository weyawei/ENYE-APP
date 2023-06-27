import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/widget/widgets.dart';

import '../products/category_model.dart';

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
    final projId = filteredCategories['categoryId'].toString(); //fetch category id from carousel_card through arguments

    List<Category1> categories = [];

    //detailedProjects = projectList.where((projectList) => projectList.proj_id == projId).toList();

    return Scaffold(
      appBar: CustomAppBar(title: 'Catalog $projId', imagePath: '',),
      body: Container(
      ),
    );
  }
}
