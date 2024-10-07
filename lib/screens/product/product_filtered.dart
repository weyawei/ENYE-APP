import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enye_app/screens/product/product.dart';
import 'package:enye_app/screens/product/product_category.dart';
import 'package:enye_app/screens/product/productsvc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
import '../../widget/responsive_text_utils.dart';
import 'detailed_product_page2.dart';


class MultiLevelFilterDemo extends StatefulWidget {
  static const String routeName = '/subcategoryFilter';




  final productCategory selectedCategory;

  MultiLevelFilterDemo({required this.selectedCategory});

  @override
  _MultiLevelFilterDemoState createState() => _MultiLevelFilterDemoState();
}

class _MultiLevelFilterDemoState extends State<MultiLevelFilterDemo> {
  late Future<List<product>> futureProducts;
  List<String> selectedCategories = [];
  List<String> selectedSubcategories = [];
  List<String> selectedBrands = [];
  List<String> selectedBrands2 = [];

  /*String selectedCategory = '';
  String selectedSubcategory = '';
  String selectedBrand = '';*/

  @override
  void initState() {
    super.initState();
    futureProducts = productService.getProducts();
  }

  @override
  Widget build(BuildContext context) {


    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);



    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory.name),
      ),
      body: FutureBuilder<List<product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

         /* // Extract unique categories, subcategories, and brands
          Set allCategories = snapshot.data!.map((p) => p.category_id).toSet();
          Set filteredSubcategories = snapshot.data!
              .where((p) => selectedCategories.contains(p.category_id))
              .map((p) => p.subCategory_id)
              .where((subcategory) => subcategory.isNotEmpty)
              .toSet();

          // Ensure filtered brands only show for selected categories and subcategories
          Set filteredBrands = snapshot.data!
              .where((p) => selectedSubcategories.contains(p.subCategory_id) && selectedCategories.contains(p.category_id))
              .map((p) => p.id)
              .where((id) => id.isNotEmpty)
              .toSet();*/

          // Extract the selected category
          String selectedCategoryId = widget.selectedCategory.id;

          // Filter subcategories and brands based on the selected category
          Set filteredSubcategories = snapshot.data!
              .where((p) => p.category_id == selectedCategoryId)  // Filter by the passed category
              .map((p) => p.subcategory_name)
              .where((subcategory) => subcategory.isNotEmpty)
              .toSet();

          Set filteredBrands = snapshot.data!
              .where((p) => p.category_id == selectedCategoryId && selectedSubcategories.contains(p.subcategory_name))  // Filter by category and subcategory
              .map((p) => p.subcategory_name1)
              .where((brand) => brand.isNotEmpty)
              .toSet();

          Set filteredBrands2 = snapshot.data!
              .where((p) => p.category_id == selectedCategoryId && selectedBrands.contains(p.subcategory_name1))  // Filter by category and subcategory
              .map((p) => p.subcategory_name2)
              .where((brand) => brand.isNotEmpty)
              .toSet();




          // Filter products based on selected categories, subcategories, and brands
          List<product> filteredProducts = snapshot.data!.where((product) {
            bool matchesCategory = selectedCategoryId.isEmpty || selectedCategoryId.contains(product.category_id);
            bool matchesSubcategory = selectedSubcategories.isEmpty || selectedSubcategories.contains(product.subcategory_name);
            bool matchesBrand = selectedBrands.isEmpty || selectedBrands.contains(product.subcategory_name1);
            bool matchesBrand2 = selectedBrands2.isEmpty || selectedBrands2.contains(product.subcategory_name2);

            return matchesCategory && matchesSubcategory && matchesBrand && matchesBrand2;
          }).toList();

          return Column(
            children: [
              // Categories Filter
             /* SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filteredSubcategories.map((category) {
                    return FilterChip(
                      label: Text(category),
                      selected: selectedCategories.contains(category),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                          selectedSubcategories = []; // Reset subcategories when categories change
                          selectedBrands = []; // Reset brands when categories change
                        });
                      },
                    );
                  }).toList(),
                ),
              ),*/

              // Subcategories Filter (only show if at least one category is selected)
           /*   if (selectedCategories.isNotEmpty && filteredSubcategories.isNotEmpty)*/
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredSubcategories.map((subcategory) {
                      return FilterChip(
                        label: Text(subcategory),
                        selected: selectedSubcategories.contains(subcategory),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedSubcategories.add(subcategory);
                            } else {
                              selectedSubcategories.remove(subcategory);
                            }
                            selectedBrands = []; // Reset brands when subcategories change
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              // Brands Filter (only show if at least one subcategory is selected)
              if (selectedSubcategories.isNotEmpty && filteredBrands.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredBrands.map((brand) {
                      return FilterChip(
                        label: Text(brand),
                        selected: selectedBrands.contains(brand),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedBrands.add(brand);
                            } else {
                              selectedBrands.remove(brand);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              if (selectedBrands.isNotEmpty && filteredBrands2.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredBrands2.map((brand2) {
                      return FilterChip(
                        label: Text(brand2),
                        selected: selectedBrands2.contains(brand2),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedBrands2.add(brand2);
                            } else {
                              selectedBrands2.remove(brand2);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              // Display filtered products
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.035,
                      vertical: screenHeight * 0.02
                  ),
                  itemCount: filteredProducts.length,
                //  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenLayout ? 2 : 3,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: fontNormalSize
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return InkWell(
                      onTap: () {
                        // Handle the tap event, such as navigating to a new screen
                       /* PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: ProductItemScreen.routeName),
                          screen: ProductItemScreen(products: product),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );*/
                      },
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                                spreadRadius: 1,  // How much the shadow spreads
                                blurRadius: 6,    // How blurry the shadow is
                                offset: Offset(0, 3), // Offset of the shadow (x: 0, y: 3)
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: fontExtraSize * 9,
                                padding: EdgeInsets.all(12.0),
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  imageUrl: "${API.prodImg + product.image}",
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(), // Loading spinner
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.error), // Error icon
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: fontNormalSize * 3,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: fontNormalSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: TextStyle(
                                              fontSize: fontSmallSize,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,  // Add this to show ellipsis
                                            maxLines: 1,  // Limit to 1 line
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: Colors.orangeAccent.shade100.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          child: Text(
                                            "Available",
                                            style: TextStyle(
                                              color: Colors.deepOrange.shade600,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontXSmallSize,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

//