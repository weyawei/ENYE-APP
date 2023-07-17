import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../products/category_model.dart';
import '../products/product_model.dart';
import '../screens.dart';

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
  List<productCategory> _prodCategory = [];
  List<product> _products = [];

  late List<Product> allProducts;
  List<Product> searchResults = [];
  List<Product> displayedProducts = []; // Initialize as an empty list
  TextEditingController searchController = TextEditingController();
  int visibleProductCount = 10; // Number of products initially visible
  int increment = 10; // Number of products to load at a time
  bool searchPerformed = false;

  @override
  void initState() {
    super.initState();
    allProducts = Product.products;
    displayedProducts = allProducts.sublist(0, visibleProductCount);
    searchFocusNode = FocusNode();
    _getProdCategory();
    _getProducts();
  }

  void loadMoreProducts() {
    int endIndex = visibleProductCount + increment;
    if (endIndex > allProducts.length) {
      endIndex = allProducts.length;
    }
    setState(() {
      displayedProducts = allProducts.sublist(0, endIndex);
      visibleProductCount = endIndex;
    });
  }

  void filterProducts(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        searchResults = []; // Clear the search results
        searchPerformed = false;
      });
    } else {
      final filteredProducts = allProducts
          .where((product) =>
          product.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      setState(() {
        searchResults = filteredProducts;
        searchPerformed = true;
      });
    }
    if (!searchPerformed) {
      searchResults = []; // Clear the search results when search is not performed
    }
  }
  late FocusNode searchFocusNode;

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  void handleSearchTap() {
    setState(() {
      searchFocusNode.requestFocus();
    });
  }

  void handleScreenTap() {
    if (searchFocusNode.hasFocus) {
      setState(() {
        searchFocusNode.unfocus();
      });
    }
  }

  _getProdCategory(){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory;
      });
      print("Length ${productCategory.length}");
    });
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product;
      });
      print("Length ${product.length}");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: 'assets/logo/enyecontrols.png'),
      drawer: productDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: searchFocusNode,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search name of products',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  filterProducts(value);
                },
              ),
            ),
            if (searchPerformed && searchResults.isNotEmpty)
              Visibility(
                visible: searchResults.isNotEmpty,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchResults[index];
                      return Center(
                          child: InkWell(
                            onTap: () {
                              /*PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(
                                    name: ProductScreen.routeName,
                                    arguments: {product.name: product}),
                                screen: ProductScreen(product: product),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation
                                    .cupertino,
                              );*/
                              // ProductCarouselCard(product: categoryProducts[index]);
                            },

                            child: ListTile(
                              title: Text(product.name),
                              // Add additional widgets or customize the display of each product
                            ),
                          )
                      );

                    }
                ),
              ),

            if (!searchPerformed && searchResults.isEmpty)
              Visibility(
                visible: displayedProducts.isNotEmpty,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: displayedProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayedProducts[index];
                    if (index == displayedProducts.length - 1) {
                      if (displayedProducts.length < allProducts.length) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          loadMoreProducts();
                        });
                      }
                    }
                  },
                ),
              ),

            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.5,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
                items: _prodCategory.where((productCategory) => productCategory.published == "Yes").map((productCategory) => categoryCarousel(productcategory: productCategory)).toList(),
              ),
            ),

            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4  ,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final randomIndex = Random().nextInt(Category1.categories.length);
                      final category = Category1.categories[randomIndex];
                      return CarouselCard2(category: category);
                    },
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.deepOrange.shade200, borderRadius: BorderRadius.circular(15)),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Center(
                    child: Text("MOST POPULAR", style: TextStyle(fontFamily: 'Rowdies', fontSize: 32, color: Colors.white),),
                  ),

                  SizedBox(height: 20,),
                  productCarousel(
                    products: _products.where((product) => product.isPopular == "true").toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}