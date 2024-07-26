import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/screens/product/product_category_list_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' as stt;

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../products/category_model.dart';
import '../products/product_model.dart';
import '../screens.dart';

class productsPage extends StatefulWidget {
  static const String routeName = '/products';

  Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: productsPage.routeName),
        builder: (_) => productsPage());
  }

 late final productCategory category;
 // const productsPage({required this.category});
  @override
  _productsPageState createState() => _productsPageState();
}

class _productsPageState extends State<productsPage> with TickerProviderStateMixin {
  List<productCategory> _prodCategory = [];
  List<productCategory> _filteredprodCategory = [];
  List<product> _products = [];
  List<banner> _banner = [];
  List<product> searchResults = [];
  List<product> displayedProducts = []; // Initialize as an empty list
  TextEditingController searchController = TextEditingController();
  int visibleProductCount = 10; // Number of products initially visible
  int increment = 10; // Number of products to load at a time
  bool searchPerformed = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  bool _isLoadingCategory = true;
  bool _isLoadingProducts = true;

  final CarouselController _carouselController = CarouselController();
  _getBanner() {
    productService.getProductBanner().then((banner) {
      setState(() {
        List<String> targetIds = ["1"];
        _banner = banner.where((element) => element.status == "Active").toList();
      });

      print("Length ${_banner.length}");
    });
  }

  @override
  void initState() {
    //allProducts = Product.products;
    //displayedProducts = allProducts.sublist(0, visibleProductCount);
    searchFocusNode = FocusNode();
    _getProdCategory();
    _getProducts();
    _getBanner();
    loadMoreProducts();
    _speech = stt.SpeechToText();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

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
    _controller.dispose();
    _speech.cancel();
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
        _prodCategory = productCategory.where((element) => element.status == "Active").toList();
      });
      _isLoadingCategory = false;
      print("Length ${productCategory.length}");
    });
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product;
      });
      _isLoadingProducts = false;
      print("Length ${product.length}");
    });
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (stt.SpeechRecognitionResult result) {
            setState(() {
              _text = result.recognizedWords;
              searchController.text = _text;
              // Trigger search after updating the text
              filterProducts(_text);
              // Note: Don't update searchController.text here
              // Wait for the user to complete speech and press the stop button
            });
          },
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
      // Update searchController.text after speech is complete
      //searchController.text = _text;
      // Trigger search after updating the text
      // filterProducts(_text);
    }
  }
  void _showStartSpeakingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Start Speaking'),
          content: Text('Start Speaking.....', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Done', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.025),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _stopListening(); // Start listening for speech
              },
            ),
          ],
        );
      },
    );
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    final activeBanners = _banner.where((bann) => bann.status == "Active").toList();

   // _prodCategory.shuffle();

	double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

	var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

  //  _filteredprodCategory = _prodCategory.where((productCategory) => productCategory.id == widget.category.id).toList();

    return GestureDetector(
      // onTap callback will be triggered when tapping anywhere on the screen
      onTap: () {
        // Remove keyboard focus when tapping outside the text field
        handleScreenTap();
      },
      child: Scaffold(
     //   appBar: CustomAppBar(title: 'PRODUCTS', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        drawer: productDrawer(),
        body: _isLoadingCategory || _isLoadingProducts
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getProdCategory();
              _getProducts();
            });
          },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    focusNode: searchFocusNode,
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search name of products',
		    labelStyle: TextStyle(
			color: Colors.black,
			fontSize: MediaQuery.of(context).size.width * 0.03,
			fontStyle: FontStyle.italic,
			),
                      prefixIcon: Icon(Icons.search, size: MediaQuery.of(context).size.width * 				0.06,),
                      suffixIcon: IconButton(
                       /* icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                        onPressed: _isListening ? _stopListening : _showStartSpeakingDialog,*/

                        icon: Icon(Icons.mic, size: MediaQuery.of(context).size.width * 0.06,),
                        onPressed:  (){
                          _startListening();
                          _showStartSpeakingDialog();
                        },

                      ),
                    ),
                    onChanged: (value) {
                      filterProducts(value);
                     // filterProducts(_text);

                      setState(() {
                        visibleProductCount = 10;
                      });
                    },
                  ),
                ),
                if (searchPerformed && searchResults.isNotEmpty)
                  Visibility(
                    visible: searchResults.isNotEmpty,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //itemCount: searchResults.length,
                        itemCount: searchResults.length < visibleProductCount
                            ? searchResults.length
                            : visibleProductCount,
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return Center(
                              child: InkWell(
                                onTap: () {
                                  PersistentNavBarNavigator
                                      .pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(
                                        name: detailedProductPage.routeName,
                                        arguments: {product.name: product}),
                                    screen: detailedProductPage(products: product,),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation
                                        .cupertino,
                                  );
                                  // ProductCarouselCard(product: categoryProducts[index]);
                                },

                                child: ListTile(
                                  title: Text(product.name, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),),
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
                          if (displayedProducts.length < visibleProductCount) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              loadMoreProducts();
                            });
                          }
                        }
                      },
                    ),
                  ),

                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.all(0.01),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.8,
                          viewportFraction: 1.03,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: activeBanners.map((bann) =>
                            InkWell(
                              onTap: () {
                                /* setState(() {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: listProductsPage.routeName),
                        screen: listProductsPage(prodSubCat: productCategory,),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    });*/
                              },
                              child: Container(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        //"${API.prodCategIcon + widget.productcategory.icon}",
                                        "${API.prodCat + bann.banner_image}",
                                        fit: BoxFit.fill,
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height * 0.3,
                                      ),
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
                                          /* padding:
                              EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                              child: Text(
                                productCategory.name,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),*/
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ).toList(),
                      ),
                      Positioned(
                        bottom: 10.0,
                        left: 0.0,
                        right: 0.0,
                        child: Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: _currentIndex,
                            count: activeBanners.length,
                            effect: ScrollingDotsEffect(
                              activeDotColor: Colors.blueAccent,
                              dotColor: Colors.grey,
                              dotHeight: 10,
                              dotWidth: 10,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.deepOrange),
                          onPressed: () {
                            _carouselController.previousPage();
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 40, color: Colors.deepOrange),
                          onPressed: () {
                            _carouselController.nextPage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,15,0),
                  child: Row(
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontFamily: 'Rowdies',
                          fontStyle: FontStyle.italic,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Spacer(),
                      Text("See all"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductAllCategory(products: _products.where((product) => product.isPopular == "true").toList())), // Replace YourNewPage with the page you want to navigate to
                          );
                        },
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          size: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  ),




                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenLayout ? 4 : 5,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 6.0,
                  ),
                  /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4  ,
                    childAspectRatio: 0.8,
                  ),*/
                  itemCount: screenLayout ? 11 : 10,
                  itemBuilder: (context, index) {
                    if (index < _prodCategory.length) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            PersistentNavBarNavigator
                                .pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(
                                  name: listProductsPage.routeName),
                              screen: listProductsPage(
                                  prodSubCat: _prodCategory[index]),
                              withNavBar: true,
                              pageTransitionAnimation: PageTransitionAnimation
                                  .cupertino,
                            );
                          });
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          margin: EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),

                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                "${API.prodCategIcon + _prodCategory[index].icon}",
                                height: MediaQuery.of(context).size.width * 0.2, // Adjust as needed
                                width: MediaQuery.of(context).size.width * 0.15, // Adjust as needed
                              ),
                              // SizedBox(height: 15.0, width: 15,),
                              Flexible(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  _prodCategory[index].name,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.028,
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
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" ", style: TextStyle(fontFamily: 'DancingScript', fontStyle: FontStyle.italic, letterSpacing: 2.5, fontWeight: FontWeight.w900, fontSize: MediaQuery.of(context).size.width * 0.09, color: Colors.deepOrange.shade300,),),
                          SizedBox(width: 13,),
                          Center(
                            child: Text(
                              "Enyecontrols \nProducts",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Rowdies',
                                fontStyle: FontStyle.italic,
                                fontSize: MediaQuery.of(context).size.width * 0.08,
                                color: Colors.deepOrange,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.deepOrangeAccent.withOpacity(0.1),
                                    offset: Offset(0, 0),
                                  ),
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.deepOrangeAccent.withOpacity(0.1),
                                    offset: Offset(0, 0),
                                  ),
                                  Shadow(
                                    blurRadius: 30.0,
                                    color: Colors.deepOrangeAccent.withOpacity(0.1),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),],
                      ),

                      SizedBox(height: 15,),
                      productCarousel(
                        products: _products.where((product) => product.isPopular == "true").toList(),
                      ),
                    ],
                  ),
                ),

              /*  Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      viewportFraction: 0.5,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: _prodCategory.where((productCategory) => productCategory.status == "Active").map((productCategory) =>
                        InkWell(
                          onTap: (){
                            setState(() {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: listProductsPage.routeName),
                                screen: listProductsPage(prodSubCat: productCategory,),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            });
                          },
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(
                                    //"${API.prodCategIcon + widget.productcategory.icon}",
                                    "${API.prodCat + productCategory.image}",
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.width * 0.3 * 1.3,
                                  ),
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
                                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                      child: Text(
                                        productCategory.name,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.025,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,

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
                ),*/



              ],
            ),
          ),
      ),
    );
  }
}