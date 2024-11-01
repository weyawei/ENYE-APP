import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enye_app/screens/product/product.dart';
import 'package:enye_app/screens/product/product_category.dart';
import 'package:enye_app/screens/product/productsvc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
import '../../widget/custom_appbar.dart';
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

  List<product> allProducts = [];
  List<product> filteredProducts = [];



  @override
  void initState() {
    super.initState();
    futureProducts = productService.getProducts();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    // Fetch your products here and assign to allProducts
    // For example:
    allProducts = await productService.getProducts();
    filteredProducts = allProducts; // Initially, show all products
    setState(() {});
  }

 /* void _applyFilters() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesSubcategory = selectedSubcategories.isEmpty || selectedSubcategories.contains(product.subCat_name1);
        final matchesBrand = selectedBrands.isEmpty || selectedBrands.contains(product.subCat1_name1);
        final matchesBrand2 = selectedBrands2.isEmpty || selectedBrands2.contains(product.subCat2_name1);

        return matchesSubcategory && matchesBrand && matchesBrand2;
      }).toList();
    });
  }*/

  void _applyFilters() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesSubcategory = selectedSubcategories.isEmpty || selectedSubcategories.contains(product.subCat_name1);

        final matchesBrand = selectedBrands.isEmpty ||
            (selectedSubcategories.contains(product.subCat_name1) && selectedBrands.contains(product.subCat1_name1)) ||
            selectedSubcategories.contains(product.subCat_name1) && product.subCat1_name1.isEmpty; // Matches if no brand but subcategory is selected.

        final matchesBrand2 = selectedBrands2.isEmpty ||
            (selectedSubcategories.contains(product.subCat_name1) && selectedBrands2.contains(product.subCat2_name1)) ||
            selectedSubcategories.contains(product.subCat_name1) && product.subCat2_name1.isEmpty; // Matches if no brand2 but subcategory is selected.

        return matchesSubcategory && matchesBrand && matchesBrand2;
      }).toList();
    });
  }



  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {

        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);
        var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
        var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
        var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
        var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7, // Sets initial height of the bottom sheet
          maxChildSize: 0.9,    // Sets max height of the bottom sheet
          minChildSize: 0.4,     // Sets minimum height of the bottom sheet
          builder: (BuildContext context, ScrollController scrollController) {
            return FutureBuilder<List<product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products available'));
                }

                String selectedCategoryId = widget.selectedCategory.id;

                Set filteredSubcategories = snapshot.data!
                    .where((p) => p.category_id == selectedCategoryId)
                    .map((p) => p.subCat_name1)
                    .where((subcategory) => subcategory.isNotEmpty)
                    .toSet();

                Set filteredBrands = {};
                Set filteredBrands2 = {};

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    void updateFilteredBrands2() {
                      filteredBrands2 = snapshot.data!
                          .where((p) => p.category_id == selectedCategoryId && selectedBrands.contains(p.subCat1_name1))
                          .map((p) => p.subCat2_name1)
                          .where((brand2) => brand2.isNotEmpty)
                          .toSet();
                      selectedBrands2.removeWhere((brand2) => !filteredBrands2.contains(brand2));
                    }

                    void updateFilteredBrands() {
                      filteredBrands = snapshot.data!
                          .where((p) => p.category_id == selectedCategoryId && selectedSubcategories.contains(p.subCat_name1))
                          .map((p) => p.subCat1_name1)
                          .where((brand) => brand.isNotEmpty)
                          .toSet();
                      selectedBrands.removeWhere((brand) => !filteredBrands.contains(brand));
                      updateFilteredBrands2();
                    }

                    updateFilteredBrands();

                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          left: 20,
                          right: 20,
                          top: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Modal
                            Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),

                            // Subcategories Filter
                            Text(
                              "Select Subcategories",
                              style: TextStyle(
                                fontSize: fontNormalSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (filteredSubcategories.isEmpty)
                              Text(
                                "No available subcategories",
                                style: TextStyle(color: Colors.grey),
                              )
                            else
                            Wrap(
                              spacing: 12.0,
                              runSpacing: 1.0,
                              children: filteredSubcategories.map((subcategory) {
                                return FilterChip(
                                  label: Text(subcategory),
                                  labelStyle: TextStyle(
                                    color: selectedSubcategories.contains(subcategory) ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: fontSmallSize
                                  ),
                                  selectedColor: Colors.orangeAccent,
                                  backgroundColor: Colors.grey[200],
                                  selected: selectedSubcategories.contains(subcategory),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 2,
                                  shadowColor: Colors.grey[300],
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedSubcategories.add(subcategory);
                                      } else {
                                        selectedSubcategories.remove(subcategory);
                                      }
                                      selectedBrands.clear();
                                      selectedBrands2.clear();
                                      updateFilteredBrands();
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 5),

                            // Brands Filter
                            if (selectedSubcategories.isNotEmpty && filteredBrands.isNotEmpty)
                              Text(
                                "Subcategories 1",
                                style: TextStyle(
                                  fontSize: fontNormalSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            SizedBox(height: 10),
                            if (selectedSubcategories.isNotEmpty && filteredBrands.isNotEmpty)
                              Wrap(
                                spacing: 12.0,
                                runSpacing: 8.0,
                                children: filteredBrands.map((brand) {
                                  return FilterChip(
                                    label: Text(brand),
                                    labelStyle: TextStyle(
                                      color: selectedBrands.contains(brand) ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: fontSmallSize,
                                    ),
                                    selectedColor: Colors.orangeAccent,
                                    backgroundColor: Colors.grey[200],
                                    selected: selectedBrands.contains(brand),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.grey[300],
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedBrands.add(brand);
                                        } else {
                                          selectedBrands.remove(brand);
                                        }
                                        updateFilteredBrands2();
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            SizedBox(height: 5),

                            // Brands2 Filter
                            if (selectedBrands.isNotEmpty && filteredBrands2.isNotEmpty)
                              Text(
                                "Subcategories 2",
                                style: TextStyle(
                                  fontSize: fontNormalSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            SizedBox(height: 10),
                            if (selectedBrands.isNotEmpty && filteredBrands2.isNotEmpty)
                              Wrap(
                                spacing: 12.0,
                                runSpacing: 8.0,
                                children: filteredBrands2.map((brand2) {
                                  return FilterChip(
                                    label: Text(brand2),
                                    labelStyle: TextStyle(
                                      color: selectedBrands2.contains(brand2) ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: fontSmallSize
                                    ),
                                    selectedColor: Colors.orangeAccent,
                                    backgroundColor: Colors.grey[200],
                                    selected: selectedBrands2.contains(brand2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.grey[300],
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
                            SizedBox(height: 5),

                            // Apply Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _applyFilters();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  backgroundColor: Colors.deepOrangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                    fontSize: fontNormalSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
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
    var fontXFontSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return Scaffold(
     /* appBar: AppBar(
        title: Text(widget.selectedCategory.name),

      ),*/
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
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

          // Extract the selected category
          String selectedCategoryId = widget.selectedCategory.id;

          // Filter subcategories and brands based on the selected category
          Set filteredSubcategories = snapshot.data!
              .where((p) => p.category_id == selectedCategoryId)
              .map((p) => p.subCat_name1)
              .where((subcategory) => subcategory.isNotEmpty)
              .toSet();

          Set filteredBrands = snapshot.data!
              .where((p) => p.category_id == selectedCategoryId && selectedSubcategories.contains(p.subCat_name1))
              .map((p) => p.subCat1_name1)
              .where((brand) => brand.isNotEmpty)
              .toSet();

          Set filteredBrands2 = snapshot.data!
              .where((p) => p.category_id == selectedCategoryId && selectedBrands.contains(p.subCat1_name1))
              .map((p) => p.subCat2_name1)
              .where((brand) => brand.isNotEmpty)
              .toSet();

          // Filter products based on selected categories, subcategories, and brands
         /* List<product> filteredProducts = snapshot.data!.where((product) {
            bool matchesCategory = selectedCategoryId.isEmpty || selectedCategoryId.contains(product.category_id);
            bool matchesSubcategory = selectedSubcategories.isEmpty || selectedSubcategories.contains(product.subCat_name1);
            bool matchesBrand = selectedBrands.isEmpty || selectedBrands.contains(product.subCat1_name1);
            bool matchesBrand2 = selectedBrands2.isEmpty || selectedBrands2.contains(product.subCat2_name1);

            return matchesCategory && matchesSubcategory && matchesBrand && matchesBrand2;
          }).toList();*/

          List<product> filteredProducts = snapshot.data!.where((product) {
            final matchesCategory = selectedCategoryId.isEmpty || selectedCategoryId.contains(product.category_id);
            final matchesSubcategory = selectedSubcategories.isEmpty || selectedSubcategories.contains(product.subCat_name1);

            final matchesBrand = selectedBrands.isEmpty ||
                (selectedSubcategories.contains(product.subCat_name1) && selectedBrands.contains(product.subCat1_name1)) ||
                selectedSubcategories.contains(product.subCat_name1) && product.subCat1_name1.isEmpty; // Matches if no brand but subcategory is selected.

            final matchesBrand2 = selectedBrands2.isEmpty ||
                (selectedSubcategories.contains(product.subCat_name1) && selectedBrands2.contains(product.subCat2_name1)) ||
                selectedSubcategories.contains(product.subCat_name1) && product.subCat2_name1.isEmpty; // Matches if no brand2 but subcategory is selected.

            return matchesCategory && matchesSubcategory && matchesBrand && matchesBrand2;
          }).toList();



          // Sort the filtered products based on subCategory_id first and then subsubCategory_id
          filteredProducts.sort((a, b) {
            // First, compare subCategory_id
            int subCategoryComparison = a.subCategory_id.compareTo(b.subCategory_id);

            // If subCategory_id is the same, sort by subsubCategory_id
            if (subCategoryComparison != 0) {
              return subCategoryComparison;
            } else {
              return a.subCat1_id.compareTo(b.subCat1_id); // Add this to sort by subsubCategory_id
            }
          });


          /*String selectedCategoryId = widget.selectedCategory.id;
          final List<product> filteredProducts = snapshot.data!.where((product) {
            return product.category_id == selectedCategoryId; // Filter by selected subcategory
          }).toList();*/

          // Group products by subcategory, sub-subcategory, and sub-sub-subcategory (or brand2)
          final Map<String, Map<String, Map<String, List<product>>>> productsBySubcategoryAndBrandAndBrand2 = {};

        // Group products by subcategory, sub-subcategory (brand), and sub-sub-subcategory (brand2)
          for (var product in filteredProducts) {
            final subcategory = product.subCat_name1;
            final subSubcategory = product.subCat1_name1; // Sub-subcategory or brand
            final subSubSubcategory = product.subCat2_name1; // Sub-sub-subcategory or brand2

            // Check if the subcategory already exists
            if (productsBySubcategoryAndBrandAndBrand2.containsKey(subcategory)) {
              // Check if the sub-subcategory exists within the subcategory
              if (productsBySubcategoryAndBrandAndBrand2[subcategory]!.containsKey(subSubcategory)) {
                // Check if the sub-sub-subcategory exists within the sub-subcategory
                if (productsBySubcategoryAndBrandAndBrand2[subcategory]![subSubcategory]!.containsKey(subSubSubcategory)) {
                  productsBySubcategoryAndBrandAndBrand2[subcategory]![subSubcategory]![subSubSubcategory]!.add(product);
                } else {
                  productsBySubcategoryAndBrandAndBrand2[subcategory]![subSubcategory]![subSubSubcategory] = [product];
                }
              } else {
                productsBySubcategoryAndBrandAndBrand2[subcategory]![subSubcategory] = {
                  subSubSubcategory: [product],
                };
              }
            } else {
              // If the subcategory doesn't exist, create a new subcategory, sub-subcategory, and sub-sub-subcategory
              productsBySubcategoryAndBrandAndBrand2[subcategory] = {
                subSubcategory: {
                  subSubSubcategory: [product],
                },
              };
            }
          }

      // Display grouped products in the UI
          return Column(
            children: [
              // Filter header (same as before)
              SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), // Lighter shadow for a softer look
                      blurRadius: 6.0,
                      offset: Offset(0, 2), // Subtle shadow position
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Conditional icon for filters with subtle design
                    if (filteredSubcategories.isNotEmpty)
                      GestureDetector(
                        onTap: _showFilterModal,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Minimal padding for a subtle feel
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withOpacity(0.1), // Soft background color
                            borderRadius: BorderRadius.circular(8), // Smooth rounded corners
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list, size: 20, color: Colors.deepOrange), // Subtle filter icon
                              SizedBox(width: 4), // Small space between icon and text
                              Text(
                                "Filters",
                                style: TextStyle(
                                  fontSize: fontExtraSize,
                                  fontWeight: FontWeight.w600, // Medium font weight for elegance
                                  color: Colors.deepOrange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Category name
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.selectedCategory.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontExtraSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),

                    // Placeholder to keep alignment consistent
                    SizedBox(width: filteredSubcategories.isNotEmpty ? 8 : 0),
                  ],
                ),
              ),


              // Expanded ListView to show subcategories, sub-subcategories, sub-sub-subcategories, and products
              Expanded(
                child: ListView.builder(
                  itemCount: productsBySubcategoryAndBrandAndBrand2.length,
                  itemBuilder: (context, index) {
                    String subcategory = productsBySubcategoryAndBrandAndBrand2.keys.elementAt(index);
                    Map<String, Map<String, List<product>>> productsByBrand = productsBySubcategoryAndBrandAndBrand2[subcategory]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subcategory header
                        if(subcategory.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Outer padding for layout spacing
                      child: Container(
                        width: double.infinity, // Make the container span the entire row
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Internal padding for the row
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.shade100.withOpacity(0.2), // Subtle background color
                          borderRadius: BorderRadius.circular(16.0), // Rounded corners for a modern feel
                          border: Border.all(
                            color: Colors.orangeAccent.shade200, // Soft border for a professional touch
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05), // Soft shadow for depth
                              blurRadius: 6,
                              offset: const Offset(0, 2), // Shadow effect for slight elevation
                            ),
                          ],
                        ),
                        child: Text(
                          subcategory,
                          textAlign: TextAlign.center, // Center text across the entire row
                          style: TextStyle(
                            fontSize: fontNormalSize, // Slightly larger text size for emphasis
                            fontWeight: FontWeight.w600, // Medium weight for readability
                            color: Colors.deepOrange.shade700, // Darker orange for contrast
                            letterSpacing: 0.5, // Small letter spacing for modern design
                          ),
                          maxLines: 1, // Keep text in a single line
                          overflow: TextOverflow.ellipsis, // Truncate text if too long
                        ),
                      ),
                    ),



                    // Display sub-subcategories (or brands) under this subcategory
                        ...productsByBrand.entries.map((brandEntry) {
                          String subSubcategory = brandEntry.key;
                          Map<String, List<product>> productsByBrand2 = brandEntry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sub-subcategory (or brand) header
                              if (subSubcategory.isNotEmpty) // Add this only if subSubcategory is not empty
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 2.0),
                                  child: Text(
                                    subSubcategory,
                                    style: TextStyle(
                                      fontSize: fontNormalSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),

                              // Display sub-sub-subcategories (or brand2) under this sub-subcategory
                              ...productsByBrand2.entries.map((brand2Entry) {
                                String subSubSubcategory = brand2Entry.key;
                                List<product> products = brand2Entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Sub-sub-subcategory (or brand2) header
                                    if (subSubSubcategory.isNotEmpty) // Add this only if subSubSubcategory is not empty
                                      Padding(
                                        padding: const EdgeInsets.only(left: 32.0, bottom: 2.0),
                                        child: Text(
                                          subSubSubcategory,
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),

                                    // Grid of products under this sub-sub-subcategory
                                    GridView.builder(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02,
                                        vertical: screenHeight * 0.005,
                                      ),
                                      itemCount: products.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(), // Disable scrolling for the grid
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: screenLayout ? 2 : 3,
                                        mainAxisSpacing: fontNormalSize,
                                        crossAxisSpacing: fontNormalSize,
                                        childAspectRatio: screenLayout ? 0.75 : 0.84,
                                      ),
                                      itemBuilder: (context, productIndex) {
                                        final product = products[productIndex];

                                        return InkWell(
                                          onTap: () {
                                            // Handle the tap event
                                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                              context,
                                              settings: RouteSettings(name: ProductItemScreen.routeName),
                                              screen: ProductItemScreen(products: product),
                                              withNavBar: true,
                                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            );
                                          },
                                          child: SingleChildScrollView(
                                            physics: NeverScrollableScrollPhysics(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 6,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: fontExtraSize * 8,
                                                    padding: EdgeInsets.all(12.0),
                                                    child: CachedNetworkImage(
                                                      width: double.infinity,
                                                      imageUrl: "${API.prodImg + product.image}",
                                                      placeholder: (context, url) => Center(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context, url, error) => Center(
                                                        child: Icon(Icons.error),
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

                                                      //  SizedBox(height: 4.0),
                                                      //  if(product.type.isNotEmpty)
                                                       Text(
                                                           product.type,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: fontXSmallSize,
                                                            ),
                                                          ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 2.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orangeAccent.shade100.withOpacity(0.3),
                                                        borderRadius: BorderRadius.circular(25.0),
                                                      ),
                                                      child:
                                                      Text(
                                                          product.subCat2_name1 != ''
                                                              ? product.subCat2_name1
                                                              : product.subCat1_name1 != ''
                                                              ? product.subCat1_name1
                                                              : product.subCat_name1 != ''
                                                              ? product.subCat_name1
                                                              : product.category_name1,
                                                          style: TextStyle(
                                                          //  fontStyle: FontStyle.italic,
                                                            fontSize: fontXSmallSize,
                                                            color: Colors.deepOrange.shade600,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
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
                                  ],
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ],
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
