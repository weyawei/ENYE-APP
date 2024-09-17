import 'package:cached_network_image/cached_network_image.dart';
import 'package:enye_app/screens/product/product_category.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';
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
              ' ${widget.category.name}'.toUpperCase(),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
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
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 100),
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
                        // Left side with name and additional text
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " ${_filteredprodSubCategory[index].name}",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4), // Space between name and additional text
                              Text(
                                " ${_filteredprodSubCategory[index].sub_desc}",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side with the image
                        Expanded(
                          flex: 1,
                          child: CachedNetworkImage(
                            imageUrl: "${API.prodCat + _filteredprodSubCategory[index].sub_image}",
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: double.infinity, // Let the image take full width of the right half
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                          ),
                        ),
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
}
