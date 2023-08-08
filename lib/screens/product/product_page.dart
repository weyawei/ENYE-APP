import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
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

  List<product> searchResults = [];
  List<product> displayedProducts = []; // Initialize as an empty list
  TextEditingController searchController = TextEditingController();
  int visibleProductCount = 10; // Number of products initially visible
  int increment = 10; // Number of products to load at a time
  bool searchPerformed = false;

  @override
  void initState() {
    //allProducts = Product.products;
    //displayedProducts = allProducts.sublist(0, visibleProductCount);
    searchFocusNode = FocusNode();
    _getProdCategory();
    _getProducts();
    loadMoreProducts();
  }

  void loadMoreProducts() {
    int endIndex = visibleProductCount + increment;
    if (endIndex > _products.length) {
      endIndex = _products.length;
    }
    setState(() {
      displayedProducts = _products.sublist(0, endIndex);
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
      final filteredProducts = _products
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
    _prodCategory.shuffle();

    return Scaffold(
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: 'assets/logo/enyecontrols.png'),
      drawer: productDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Padding(
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
                              *//*PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(
                                    name: ProductScreen.routeName,
                                    arguments: {product.name: product}),
                                screen: ProductScreen(product: product),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation
                                    .cupertino,
                              );*//*
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
                      if (displayedProducts.length < _products.length) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          loadMoreProducts();
                        });
                      }
                    }
                  },
                ),
              ),*/

            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.5,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
                items: _prodCategory.where((productCategory) => productCategory.published == "Yes").map((productCategory) =>
                  InkWell(
                    onTap: (){
                      setState(() {
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: subCatProductPage.routeName),
                          screen: subCatProductPage(category: productCategory),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              //"${API.prodCategIcon + widget.productcategory.icon}",
                                "${API.prodImg + _products.where((product) => product.category_id == productCategory.id).elementAt(0).image}",
                                fit: BoxFit.fill, width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding:
                                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  productCategory.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,

                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ).toList(),
              ),
            ),

            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
              ),
              /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4  ,
                childAspectRatio: 0.8,
              ),*/
              itemCount: 8,
              itemBuilder: (context, index) {
                if (index < _prodCategory.length) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(
                              name: subCatProductPage.routeName),
                          screen: subCatProductPage(
                              category: _prodCategory[index]),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation
                              .cupertino,
                        );
                      });
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      margin: EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "${API.prodCategIcon + _prodCategory[index].icon}",
                            height: 50,
                            width: 50,
                          ),
                          // SizedBox(height: 15.0, width: 15,),
                          Flexible(
                            child: Text(
                              textAlign: TextAlign.center,
                              _prodCategory[index].name,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),

            Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.orange.shade50.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("most", style: TextStyle(fontFamily: 'DancingScript', fontStyle: FontStyle.italic, letterSpacing: 2.5, fontWeight: FontWeight.w900, fontSize: 36, color: Colors.deepOrange.shade300,),),
                      SizedBox(width: 13,),
                      Text("POPULAR", style: TextStyle(fontFamily: 'Rowdies', fontStyle: FontStyle.italic, fontSize: 32, color: Colors.deepOrange,),),
                    ],
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