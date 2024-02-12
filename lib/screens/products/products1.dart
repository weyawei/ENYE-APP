
import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:enye_app/screens/products/model.dart';
import 'package:enye_app/screens/products/product_screen.dart';
import 'package:enye_app/screens/products/productinfo_model.dart';
import 'package:enye_app/widget/CarouselCardProduct.dart';
import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:enye_app/widget/product_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../widget/product_card.dart';
import '../../widget/section_title.dart';
import 'category_model.dart';


/*
class ProductPage extends StatelessWidget {
  static const String routeName = '/products';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductPage()
    );
  }
  ProductPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: '',),
      drawer: CustomDrawer1(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
               // height: MediaQuery.of(context).size.height * 1,
               child: CarouselSlider(
             options: CarouselOptions(
               autoPlay: true,
              aspectRatio: 1.5,
              viewportFraction: 0.9,
               enlargeCenterPage: true,
               enlargeStrategy: CenterPageEnlargeStrategy.height,
             ), items: Category1.categories.map((category) => CarouselCard(category: category)).toList(),

          ),
         ),
           // SectionTitle(title: 'CATEGORIES'),
           */
/* Container(

              height: MediaQuery.of(context).size.height * 0.3,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4.8,
                ),
                itemCount: Category1.categories.length,
                itemBuilder: (context, index) {
                  final category = Category1.categories[index];
                  return CarouselCard1(category: category);
                },
              ),
            ),*//*

            */
/*ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                'CATEGORIES',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
              ),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Adjust the number of columns as needed
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 9.8, // Adjust the aspect ratio as needed
                  ),
                  itemCount: Category1.categories.length,
                  itemBuilder: (context, index) {
                    final category = Category1.categories[index];
                    return CarouselCard1(category: category);
                  },
                ),
              ],
            ),*//*

            SectionTitle(title: 'RECOMMENDED'),
            //Product Carousel
            */
/*ProductCard(product: Product.products[0],),*//*

            ProductCarousel(products: Product.products.where((product) => product.isRecommended).toList()),
            SectionTitle(title: 'MOST POPULAR'),
            //Product Carousel
            */
/*ProductCard(product: Product.products[0],),*//*

            ProductCarousel(products: Product.products.where((product) => product.isPopular).toList()),
          ],
        ),
      ),
    );
  }
}
*/

class ProductPage extends StatefulWidget {
  static const String routeName = '/products';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductPage());
  }

  ProductPage({Key? key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: handleScreenTap,
        child: Scaffold(
           appBar: CustomAppBar(title: 'PRODUCTS', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
              drawer: CustomDrawer1(),
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
                                PersistentNavBarNavigator
                                    .pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(
                                      name: ProductScreen.routeName,
                                      arguments: {product.name: product}),
                                  screen: ProductScreen(product: product),
                                  withNavBar: true,
                                  pageTransitionAnimation: PageTransitionAnimation
                                      .cupertino,
                                );
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
                items: Category1.categories
                    .map((category) => CarouselCard(category: category))
                    .toList(),
              ),
            ),

            SectionTitle(title: 'CATEGORIES',),

            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  height: MediaQuery.of(context).size.height * 0.3,
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

                InkWell(
                  onTap: () {
                    // Navigate to a new screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomDrawer1(), // Replace with your desired screen
                      ),
                    );
                  },
                  child: Text(
                    'View All Categories',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,

                    ),
                  ),
                ),
              ],

            ),
            /*ProductCarousel(
              products: Product.products.where((product) => product.isRecommended).toList(),
            ),*/
            SectionTitle(title: 'MOST POPULAR'),
            ProductCarousel(
              products: Product.products.where((product) => product.isPopular).toList(),
            ),

          ],
        ),
      ),
        )
    );
  }
}

