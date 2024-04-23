import 'package:enye_app/screens/product/product_category.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/widgets.dart';
import '../screens.dart';
/*
class subCatProductPage extends StatefulWidget {
  static const String routeName = '/subcategory';

  Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: subCatProductPage.routeName),
      builder: (_) => subCatProductPage(category: category,),
    );
  }
  final productCategory category;
  const subCatProductPage({required this.category});

  @override
  State<subCatProductPage> createState() => _subCatProductPageState();
}

class _subCatProductPageState extends State<subCatProductPage> {
  double screenHeight = 0;
  double screenWidth = 0;

  List<productSubCategory> _prodSubCategory = [];
  List<productSubCategory> _filteredprodSubCategory = [];

  @override
  void initState(){
    super.initState();
    _getProdSubCategory();
  }

  _getProdSubCategory(){
    productService.getProdSubCategory().then((productSubCategory){
      setState(() {
        _prodSubCategory = productSubCategory;
      });
      print("Length ${productSubCategory.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;

    _filteredprodSubCategory = _prodSubCategory.where((productSubCategory) => productSubCategory.category_id == widget.category.id).toList();

    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Type of ${widget.category.name}'.toUpperCase(),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontFamily: 'Rowdies',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(5.0),
              itemCount: _filteredprodSubCategory.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: listProductsPage.routeName),
                      screen: listProductsPage(prodSubCat: _filteredprodSubCategory[index],),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: screenWidth,
                    margin: EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth / 100,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.deepOrange,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            " ${_filteredprodSubCategory[index].name}",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.label_important,
                          color: Colors.deepOrange,
			  size: MediaQuery.of(context).size.width * 0.04
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/
