

import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/screens/product/product.dart';
import 'package:enye_app/screens/product/product_category.dart';
import 'package:enye_app/screens/product/product_list_page.dart';
import 'package:enye_app/screens/product/productsvc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../config/api_connection.dart';
import 'detailed_product.dart';
import 'detailed_product_page.dart';

class ProductAllCategory extends StatefulWidget {
  final List<product> products;
  const ProductAllCategory({required this.products});

  @override
  State<ProductAllCategory> createState() => _ProductAllCategoryState();
}

class _ProductAllCategoryState extends State<ProductAllCategory> with TickerProviderStateMixin {

  List<product> _prod = [];
  List<product> _prod1 = [];
  List<product> _prod2 = [];
  List<product> _prod3= [];
  List<product> _prod4 = [];
  List<product> _prod5 = [];
  List<product> _prod6 = [];
  List<product> _prod7 = [];
  List<product> _prod8 = [];
  List<product> _prod9 = [];
  List<product> _prod10 = [];

  List<banner> _banner = [];
  List<productCategory> _prodCategories = [];
  List<productCategory> _prodCategory = [];
  List<productCategory> _prodCategory2 = [];
  List<productCategory> _prodCategory3 = [];
  List<productCategory> _prodCategory4 = [];
  List<productCategory> _prodCategory5 = [];
  List<productCategory> _prodCategory6 = [];
  List<productCategory> _prodCategory7 = [];
  List<productCategory> _prodCategory8 = [];
  List<productCategory> _prodCategory9 = [];
  List<productCategory> _prodCategory10 = [];
  List<productCategory> _prodCategory11 = [];

  @override
  void initState() {
    _getProdCategories();
    _getProdCategory();
    _getProdCategory2();
    _getProdCategory3();
    _getProdCategory4();
    _getProdCategory5();
    _getProdCategory6();
    _getProdCategory7();
    _getProdCategory8();
    _getProdCategory9();
    _getProdCategory10();
    _getProdCategory11();

    _getBanner();
    _getProd();
    _getProd1();
    _getProd2();
    _getProd3();
    _getProd4();
    _getProd5();
    _getProd6();
    _getProd7();
    _getProd8();
    _getProd9();
    _getProd10();


  }

  _getBanner() {
    productService.getProductBanner().then((banner) {
      setState(() {
        List<String> targetIds = ["1"];
        _banner = banner.where((element) => element.status == "Active").toList();
      });

      print("Length ${_banner.length}");
    });
  }


  _getProd() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["38"];
        _prod = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd1() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["39"];
        _prod1 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd2() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["40"];
        _prod2 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd3() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["41"];
        _prod3 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd4() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["42"];
        _prod4 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd5() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["43"];
        _prod5 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd6() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["44"];
        _prod6 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd7() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["45"];
        _prod7 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd8() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["46"];
        _prod8 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd9() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["47"];
        _prod9 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProd10() {
    productService.getProducts().then((product) {
      setState(() {
        List<String> targetIds = ["48"];
        _prod10 = product.where((element) => targetIds.contains(element.category_id)).toList();
      });

      print("Length Products ${_prod.length}");
    });
  }

  _getProdCategories() {
    productService.getProdCategory().then((productCategories) {
      setState(() {
        List<String> targetIds = ["38"];
        _prodCategories = productCategories.where((element) => element.status == "Active").toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory() {
    productService.getProdCategory().then((productCategory) {
      setState(() {
        List<String> targetIds = ["38"];
        _prodCategory = productCategory.where((element) => element.id == "38").toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory2() {
    productService.getProdCategory().then((productCategory2) {
      setState(() {
        List<String> targetIds2 = ["39"];
        _prodCategory2 = productCategory2.where((element) => element.id == "39").toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory3() {
    productService.getProdCategory().then((productCategory3) {
      setState(() {
        List<String> targetIds3 = ["40"];
        _prodCategory3 = productCategory3.where((element) => element.id == "40").toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory4() {
    productService.getProdCategory().then((productCategory4) {
      setState(() {
        List<String> targetIds4 = ["41"];
        _prodCategory4 = productCategory4.where((element) => targetIds4.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory5() {
    productService.getProdCategory().then((productCategory5) {
      setState(() {
        List<String> targetIds5 = ["42"];
        _prodCategory5 = productCategory5.where((element) => targetIds5.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory6() {
    productService.getProdCategory().then((productCategory6) {
      setState(() {
        List<String> targetIds6 = ["43"];
        _prodCategory6 = productCategory6.where((element) => targetIds6.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory7() {
    productService.getProdCategory().then((productCategory7) {
      setState(() {
        List<String> targetIds7 = ["44"];
        _prodCategory7 = productCategory7.where((element) => targetIds7.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory8() {
    productService.getProdCategory().then((productCategory8) {
      setState(() {
        List<String> targetIds8 = ["45"];
        _prodCategory8 = productCategory8.where((element) => targetIds8.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory9() {
    productService.getProdCategory().then((productCategory9) {
      setState(() {
        List<String> targetIds9 = ["46"];
        _prodCategory9 = productCategory9.where((element) => targetIds9.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory10() {
    productService.getProdCategory().then((productCategory10) {
      setState(() {
        List<String> targetIds10 = ["47"];
        _prodCategory10 = productCategory10.where((element) => targetIds10.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory11() {
    productService.getProdCategory().then((productCategory11) {
      setState(() {
        List<String> targetIds11 = ["48"];
        _prodCategory11 = productCategory11.where((element) => targetIds11.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }



  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final activeBanners = _banner.where((bann) => bann.status == "Active").toList();
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Container(
        // width: screenWidth,
        // height: MediaQuery.of(context).size.height * 0.3,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(8.0),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.5),
        //       spreadRadius: 2,
        //       blurRadius: 7,
        //       offset: Offset(0, 3), // changes position of shadow
        //     ),
        //   ],
        // ),
        // child: Stack(
        //   children: [
        //     CarouselSlider(
        //       options: CarouselOptions(
        //         autoPlay: false,
        //         aspectRatio: 1.6,
        //         viewportFraction: 1.03,
        //         enlargeCenterPage: true,
        //         enlargeStrategy: CenterPageEnlargeStrategy.height,
        //         onPageChanged: (index, reason) {
        //           setState(() {
        //             _currentIndex = index;
        //           });
        //         },
        //       ),
        //       items: activeBanners.map((bann) =>
        //           InkWell(
        //             onTap: () {
        //               /* setState(() {
        //               PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        //                 context,
        //                 settings: RouteSettings(name: listProductsPage.routeName),
        //                 screen: listProductsPage(prodSubCat: productCategory,),
        //                 withNavBar: true,
        //                 pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //               );
        //             });*/
        //             },
        //             child: Container(
        //               color: Colors.white,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //                 child: Stack(
        //                   children: <Widget>[
        //                     Image.network(
        //                       //"${API.prodCategIcon + widget.productcategory.icon}",
        //                       "${API.prodCat + bann.banner_image}",
        //                       fit: BoxFit.fill,
        //                       width: MediaQuery.of(context).size.width,
        //                       height: MediaQuery.of(context).size.height * 0.3,
        //                     ),
        //                     Positioned(
        //                       bottom: 0.0,
        //                       left: 0.0,
        //                       right: 0.0,
        //                       child: Container(
        //                         decoration: BoxDecoration(
        //                           gradient: LinearGradient(
        //                             colors: [
        //                               Color.fromARGB(200, 0, 0, 0),
        //                               Color.fromARGB(0, 0, 0, 0),
        //                             ],
        //                             begin: Alignment.bottomCenter,
        //                             end: Alignment.topCenter,
        //                           ),
        //                         ),
        //                         /* padding:
        //                       EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        //                       child: Text(
        //                         productCategory.name,
        //                         style: TextStyle(
        //                           fontSize: MediaQuery.of(context).size.width * 0.025,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),*/
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           )
        //       ).toList(),
        //     ),
        //     Positioned(
        //       bottom: 10.0,
        //       left: 0.0,
        //       right: 0.0,
        //       child: Center(
        //         child: AnimatedSmoothIndicator(
        //           activeIndex: _currentIndex,
        //           count: activeBanners.length,
        //           effect: ScrollingDotsEffect(
        //             activeDotColor: Colors.blueAccent,
        //             dotColor: Colors.grey,
        //             dotHeight: 10,
        //             dotWidth: 10,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // ),

            Stack(
              children: [
                CarouselSlider(
                  // carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 30),
                    aspectRatio: 1.7,
                    viewportFraction: 1,
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
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                //"${API.prodCategIcon + widget.productcategory.icon}",
                                "${API.prodCat + bann.banner_image}",
                                fit: BoxFit.fill,
                                width: screenWidth,
                                height: screenHeight * 0.3,
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
              ],
            ),

            Container(
              padding: EdgeInsets.all(10), // Adjust padding as needed
              decoration: BoxDecoration(
                //color: Colors.deepOrange.withOpacity(0.03), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                "All Categories",
                style: TextStyle(
                  fontFamily: "Rowdies",
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                maxLines: 2, // Limits the text to 2 lines
              ),
            ),

            Card(
              color: Colors.white,
             child: Column(
               children: [
                 Row(
                   children: [
                     Expanded(
                       child: Card(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                           side: BorderSide(
                             color: Colors.black, // Border color
                             width: 1.0, // Border width
                           ),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 "Air Quality",
                                 style: TextStyle(
                                //   fontFamily: 'Rowdies',
                                   fontWeight: FontWeight.normal,
                                   fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                   color: Colors.black, // Adjust the text color
                                   shadows: [
                                     Shadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       blurRadius: 2,
                                       offset: Offset(1, 1),
                                     ),
                                   ],
                                   // You can add more styles like letterSpacing, fontStyle, etc. here
                                 ),
                                 textAlign: TextAlign.left,
                               ),
                             ),
                             GridView.builder(
                                 padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                 physics: const NeverScrollableScrollPhysics(),
                                 shrinkWrap: true,
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisCount: 2,
                                   crossAxisSpacing: 2.0,
                                   mainAxisSpacing: 2.0,
                                   childAspectRatio: 1.1,
                                 ),
                                 itemCount: min(_prod.length, 4),
                                 // Display only the first 4 items,
                                 itemBuilder: (BuildContext context, int index) {
                                   return InkWell(
                                     onTap: () {
                                       setState(() {
                                         PersistentNavBarNavigator
                                             .pushNewScreenWithRouteSettings(
                                           context,
                                           settings: RouteSettings(
                                               name: listProductsPage.routeName),
                                           screen: listProductsPage(
                                               prodSubCat: _prodCategory[0]),
                                           withNavBar: true,
                                           pageTransitionAnimation: PageTransitionAnimation
                                               .cupertino,
                                         );
                                       });
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(5.0),
                                       ),
                                       child: Column(
                                         children: [
                                           Expanded(
                                             child: SizedBox(
                                               width: MediaQuery.of(context).size.width * 0.2,
                                               height: MediaQuery.of(context).size.height * 0.6,
                                               child: DecoratedBox(
                                                 decoration: BoxDecoration(
                                                   image: DecorationImage(
                                                     image: NetworkImage("${API.prodImg + _prod[index].image}"),
                                                     alignment: Alignment(0.0, -0.70),
                                                     fit: BoxFit.contain,
                                                   ),
                                                  /* border: Border.all(
                                                     color: Colors.black, // Choose your desired border color
                                                     width: 0.4, // Choose your desired border width
                                                   ),*/
                                                   borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                 ),
                                               ),
                                             ),
                                           ),

                                           /* Container(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                         crossAxisAlignment: CrossAxisAlignment.end,
                                         mainAxisSize: MainAxisSize.max,
                                         children: [
                                           Expanded(
                                             child: Text(
                                               products[index].name,
                                               style: TextStyle(
                                                 fontSize: MediaQuery
                                                     .of(context)
                                                     .size
                                                     .width * 0.025,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.deepOrange,
                                               ),
                                               maxLines: 3,
                                               softWrap: true,
                                             ),
                                           ),
                                           Icon(Icons.ads_click_sharp,
                                               color: Colors.deepOrange,
                                               size: MediaQuery
                                                   .of(context)
                                                   .size
                                                   .width * 0.06),
                                         ],
                                       ),
                                     ),*/
                                         ],
                                       ),
                                     ),
                                   );
                                 }),
                           ],
                         ),

                       ),
                     ),

                     Expanded(
                       child: Card(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                           side: BorderSide(
                             color: Colors.black, // Border color
                             width: 1.0, // Border width
                           ),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 "Current",
                                 style: TextStyle(
                               //    fontFamily: 'Rowdies',
                                   fontWeight: FontWeight.normal,
                                   fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                   color: Colors.black, // Adjust the text color
                                   shadows: [
                                     Shadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       blurRadius: 2,
                                       offset: Offset(1, 1),
                                     ),
                                   ],
                                   // You can add more styles like letterSpacing, fontStyle, etc. here
                                 ),
                                 textAlign: TextAlign.left,
                               ),
                             ),
                             GridView.builder(
                                 padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                 physics: const NeverScrollableScrollPhysics(),
                                 shrinkWrap: true,
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisCount: 2,
                                   crossAxisSpacing: 2.0,
                                   mainAxisSpacing: 2.0,
                                   childAspectRatio: 1.1,
                                 ),
                                 itemCount: min(_prod1.length, 4),
                                 // Display only the first 4 items,
                                 itemBuilder: (BuildContext context, int index) {
                                   return InkWell(
                                       onTap: () {
                                     setState(() {
                                       PersistentNavBarNavigator
                                           .pushNewScreenWithRouteSettings(
                                         context,
                                         settings: RouteSettings(
                                             name: listProductsPage.routeName),
                                         screen: listProductsPage(
                                             prodSubCat: _prodCategory2[0]),
                                         withNavBar: true,
                                         pageTransitionAnimation: PageTransitionAnimation
                                             .cupertino,
                                       );
                                     });
                                   },
                                 child: Container(
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(5.0),
                                     ),
                                     child: Column(
                                       children: [
                                         Expanded(
                                           child: SizedBox(
                                             width: MediaQuery.of(context).size.width * 0.2,
                                             height: MediaQuery.of(context).size.height * 0.6,
                                             child: DecoratedBox(
                                               decoration: BoxDecoration(
                                                 image: DecorationImage(
                                                   image: NetworkImage("${API.prodImg + _prod1[index].image}"),
                                                   alignment: Alignment(0.0, -0.70),
                                                   fit: BoxFit.contain,
                                                 ),
                                                 /*border: Border.all(
                                                   color: Colors.black, // Choose your desired border color
                                                   width: 0.4, // Choose your desired border width
                                                 ),*/
                                                 borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                               ),
                                             ),
                                           ),
                                         ),

                                         /* Container(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     mainAxisSize: MainAxisSize.max,
                                     children: [
                                       Expanded(
                                         child: Text(
                                           products[index].name,
                                           style: TextStyle(
                                             fontSize: MediaQuery
                                                 .of(context)
                                                 .size
                                                 .width * 0.025,
                                             fontWeight: FontWeight.bold,
                                             color: Colors.deepOrange,
                                           ),
                                           maxLines: 3,
                                           softWrap: true,
                                         ),
                                       ),
                                       Icon(Icons.ads_click_sharp,
                                           color: Colors.deepOrange,
                                           size: MediaQuery
                                               .of(context)
                                               .size
                                               .width * 0.06),
                                     ],
                                   ),
                                 ),*/
                                       ],
                                     ),
                                         ),
                                   );
                                 }),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               //  Text(_prodCategory[0].name),
               ],
             ),
           ),



            Card(
              color: Colors.white,

              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Flow",
                                  style: TextStyle(
                                 //   fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod2.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: listProductsPage.routeName),
                                            screen: listProductsPage(
                                                prodSubCat: _prodCategory3[0]),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
                                          );
                                        });
                                      },
                                            child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod2[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  /*border: Border.all(
                                                    color: Colors.black, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      products[index].name,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.025,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepOrange,
                                                      ),
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Icon(Icons.ads_click_sharp,
                                                      color: Colors.deepOrange,
                                                      size: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.06),
                                                ],
                                              ),
                                            ),*/
                                        ],
                                      ),
                                         ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Gas",
                                  style: TextStyle(
                                //    fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod3.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: listProductsPage.routeName),
                                            screen: listProductsPage(
                                                prodSubCat: _prodCategory4[0]),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
                                          );
                                        });
                                      },
                                        child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod3[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  /*border: Border.all(
                                                    color: Colors.black, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  products[index].name,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.025,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange,
                                                  ),
                                                  maxLines: 3,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Icon(Icons.ads_click_sharp,
                                                  color: Colors.deepOrange,
                                                  size: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.06),
                                            ],
                                          ),
                                        ),*/
                                        ],
                                      ),
                                          ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                //  Text(_prodCategory[0].name),
                ],
              ),
            ),


            Card(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Humidity",
                                  style: TextStyle(
                               //     fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod4.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                      setState(() {
                                        PersistentNavBarNavigator
                                            .pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: listProductsPage.routeName),
                                          screen: listProductsPage(
                                              prodSubCat: _prodCategory5[0]),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation
                                              .cupertino,
                                        );
                                      });
                                    },
                                            child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod4[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                 /* border: Border.all(
                                                    color: Colors.black, // Choose your desired border color
                                                    width: 0.4// Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      products[index].name,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.025,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepOrange,
                                                      ),
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Icon(Icons.ads_click_sharp,
                                                      color: Colors.deepOrange,
                                                      size: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.06),
                                                ],
                                              ),
                                            ),*/
                                        ],
                                      ),
                                         ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Level",
                                  style: TextStyle(
                                 //   fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod5.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                      setState(() {
                                        PersistentNavBarNavigator
                                            .pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: listProductsPage.routeName),
                                          screen: listProductsPage(
                                              prodSubCat: _prodCategory6[0]),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation
                                              .cupertino,
                                        );
                                      });
                                    },
                                        child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod5[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                 /* border: Border.all(
                                                    color: Colors.black, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  products[index].name,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.025,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange,
                                                  ),
                                                  maxLines: 3,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Icon(Icons.ads_click_sharp,
                                                  color: Colors.deepOrange,
                                                  size: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.06),
                                            ],
                                          ),
                                        ),*/
                                        ],
                                      ),
                                          ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //  Text(_prodCategory[0].name),
                ],
              ),
            ),

            Card(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Power Meter",
                                  style: TextStyle(
                                 //   fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod6.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                      setState(() {
                                        PersistentNavBarNavigator
                                            .pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: listProductsPage.routeName),
                                          screen: listProductsPage(
                                              prodSubCat: _prodCategory7[0]),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation
                                              .cupertino,
                                        );
                                      });
                                    },
                                            child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod6[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                 /* border: Border.all(
                                                      color: Colors.black, // Choose your desired border color
                                                      width: 0.4// Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      products[index].name,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.025,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepOrange,
                                                      ),
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Icon(Icons.ads_click_sharp,
                                                      color: Colors.deepOrange,
                                                      size: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.06),
                                                ],
                                              ),
                                            ),*/
                                        ],
                                      ),
                                         ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Pressure",
                                  style: TextStyle(
                                 //   fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod7.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                      setState(() {
                                        PersistentNavBarNavigator
                                            .pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: listProductsPage.routeName),
                                          screen: listProductsPage(
                                              prodSubCat: _prodCategory8[0]),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation
                                              .cupertino,
                                        );
                                      });
                                    },
                                        child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod7[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                 /* border: Border.all(
                                                    color: Colors.black, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  products[index].name,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.025,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange,
                                                  ),
                                                  maxLines: 3,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Icon(Icons.ads_click_sharp,
                                                  color: Colors.deepOrange,
                                                  size: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.06),
                                            ],
                                          ),
                                        ),*/
                                        ],
                                      ),
                                          ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //  Text(_prodCategory[0].name),
                ],
              ),
            ),


            Card(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(
                                 //   fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod8.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: listProductsPage.routeName),
                                            screen: listProductsPage(
                                                prodSubCat: _prodCategory9[0]),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
                                          );
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                height: MediaQuery.of(context).size.height * 0.6,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage("${API.prodImg + _prod8[index].image}"),
                                                      alignment: Alignment(0.0, -0.70),
                                                      fit: BoxFit.contain,
                                                    ),
                                                   /* border: Border.all(
                                                        color: Colors.black, // Choose your desired border color
                                                        width: 0.4// Choose your desired border width
                                                    ),*/
                                                    borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                  ),
                                                ),
                                              ),
                                            ),

                                            /* Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      products[index].name,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.025,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepOrange,
                                                      ),
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Icon(Icons.ads_click_sharp,
                                                      color: Colors.deepOrange,
                                                      size: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.06),
                                                ],
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Test Equipment",
                                  style: TextStyle(
                                  //  fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod9.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                      setState(() {
                                        PersistentNavBarNavigator
                                            .pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: listProductsPage.routeName),
                                          screen: listProductsPage(
                                              prodSubCat: _prodCategory10[0]),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation
                                              .cupertino,
                                        );
                                      });
                                    },
                                        child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage("${API.prodImg + _prod9[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                /*  border: Border.all(
                                                    color: Colors.black, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),*/
                                                  borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                ),
                                              ),
                                            ),
                                          ),

                                          /* Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  products[index].name,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.025,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange,
                                                  ),
                                                  maxLines: 3,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Icon(Icons.ads_click_sharp,
                                                  color: Colors.deepOrange,
                                                  size: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.06),
                                            ],
                                          ),
                                        ),*/
                                        ],
                                      ),
                                         ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //  Text(_prodCategory[0].name),
                ],
              ),
            ),


            Card(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Valves",
                                  style: TextStyle(
                                //    fontFamily: 'Rowdies',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.black, // Adjust the text color
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    // You can add more styles like letterSpacing, fontStyle, etc. here
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              GridView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prod10.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: listProductsPage.routeName),
                                            screen: listProductsPage(
                                                prodSubCat: _prodCategory11[0]),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
                                          );
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                height: MediaQuery.of(context).size.height * 0.6,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage("${API.prodImg + _prod10[index].image}"),
                                                      alignment: Alignment(0.0, -0.70),
                                                      fit: BoxFit.contain,
                                                    ),
                                                    /*border: Border.all(
                                                        color: Colors.black, // Choose your desired border color
                                                        width: 0.4// Choose your desired border width
                                                    ),*/
                                                    borderRadius: BorderRadius.circular(20.0), // Optional: Add border radius for rounded corners
                                                  ),
                                                ),
                                              ),
                                            ),

                                            /* Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      products[index].name,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.025,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.deepOrange,
                                                      ),
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Icon(Icons.ads_click_sharp,
                                                      color: Colors.deepOrange,
                                                      size: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.06),
                                                ],
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  //  Text(_prodCategory[0].name),
                ],
              ),
            ),


           /* SizedBox(height: 15,),

            Text(
              "New Items",
              style: TextStyle(
            //    fontFamily: 'Rowdies',
                fontWeight: FontWeight.normal,
                fontSize: MediaQuery.of(context).size.width * 0.070, // Adjust the font size as needed
                color: Colors.black, // Adjust the text color
                shadows: [
                  Shadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
                // You can add more styles like letterSpacing, fontStyle, etc. here
              ),
              textAlign: TextAlign.left,
            ),

            Container(
              height: MediaQuery.of(context).size.width * 0.3 * 1.3 + 60, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _prodCategories.where((productCategory) => productCategory.status == "Active").length,
                itemBuilder: (context, index) {
                  var productCategory = _prodCategories.where((productCategory) => productCategory.status == "Active").toList()[index];
                  return InkWell(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: listProductsPage.routeName),
                        screen: listProductsPage(prodSubCat: productCategory,),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              "${API.prodCat + productCategory.image}",
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
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
                               *//* padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                                child: Text(
                                  productCategory.name,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),*//*
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )*/



            //  }),

           /* Card(
              elevation: 15,
              margin: EdgeInsets.all(16),
              child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: min(widget.products.length, 1),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: detailedProductPage.routeName),
                          screen: detailedProductPage(products: widget.products[index],),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("${API.prodImg + widget.products[index].image}"),
                                      alignment: Alignment(0.0, -0.70),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.products[index].name,
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                    ),
                                  ),
                                  Icon(Icons.ads_click_sharp, color: Colors.deepOrange,
                                      size: MediaQuery.of(context).size.width * 0.06 ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),*/
          ],
        ),
      ),
    );
  }
}
