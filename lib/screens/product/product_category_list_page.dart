

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

import '../../config/api_connection.dart';
import 'detailed_product_page.dart';

class ProductAllCategory extends StatefulWidget {
  final List<product> products;
  const ProductAllCategory({required this.products});

  @override
  State<ProductAllCategory> createState() => _ProductAllCategoryState();
}

class _ProductAllCategoryState extends State<ProductAllCategory> with TickerProviderStateMixin {

  List<product> _prod = [];
  List<productCategory> _prodCategory = [];
  List<productCategory> _prodCategory2 = [];
  List<productCategory> _prodCategory3 = [];
  List<productCategory> _prodCategory4 = [];

  @override
  void initState() {
    _getProdCategory();
    _getProdCategory2();
    _getProdCategory3();
    _getProdCategory4();
    _getProd();


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

  _getProdCategory() {
    productService.getProdCategory().then((productCategory) {
      setState(() {
        List<String> targetIds = ["38", "39", "40", "41", "44", "45", "47", "46"];
        _prodCategory = productCategory.where((element) => targetIds.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory2() {
    productService.getProdCategory().then((productCategory2) {
      setState(() {
        List<String> targetIds2 = ["42", "43", "44", "45", "40", "41", "46", "47"];
        _prodCategory2 = productCategory2.where((element) => targetIds2.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory3() {
    productService.getProdCategory().then((productCategory3) {
      setState(() {
        List<String> targetIds3 = ["46", "47", "48", "40", "38", "42", "41", "44"];
        _prodCategory3 = productCategory3.where((element) => targetIds3.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }

  _getProdCategory4() {
    productService.getProdCategory().then((productCategory4) {
      setState(() {
        List<String> targetIds4 = ["43", "47", "38", "42", "44", "45",];
        _prodCategory4 = productCategory4.where((element) => targetIds4.contains(element.id)).toList();
      });

      print("Length ${_prodCategory.length}");
    });
  }


  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2.0,
                  viewportFraction: 1.1,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
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
                                width: MediaQuery.of(context).size.width * 1.5,
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
                                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
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
            ),


            Container(
              padding: EdgeInsets.all(10), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.03), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                "All Categories",
                style: TextStyle(
                  fontFamily: "DancingScript",
                  fontSize: MediaQuery.of(context).size.width * 0.09,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                maxLines: 2, // Limits the text to 2 lines
              ),
            ),

            Card(
             color: Colors.orange.shade50.withOpacity(0.9),
             child: Column(
               children: [
                 Row(
                   children: [
                     Expanded(
                       child: Card(
                        /* shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                           side: BorderSide(
                             color: Colors.deepOrange, // Border color
                             width: 1.0, // Border width
                           ),
                         ),*/
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 "Equipments",
                                 style: TextStyle(
                              //     fontFamily: 'DancingScript',
                                   fontWeight: FontWeight.bold,
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
                                 padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
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
                                               prodSubCat: _prodCategory[index]),
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
                                                   border: Border.all(
                                                     color: Colors.deepOrange, // Choose your desired border color
                                                     width: 0.4, // Choose your desired border width
                                                   ),
                                                   borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                        /* shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                           side: BorderSide(
                             color: Colors.deepOrange, // Border color
                             width: 1.0, // Border width
                           ),
                         ),*/
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 "Valves",
                                 style: TextStyle(
                              //     fontFamily: 'DancingScript',
                                   fontWeight: FontWeight.bold,
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
                                 padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                 physics: const NeverScrollableScrollPhysics(),
                                 shrinkWrap: true,
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisCount: 2,
                                   crossAxisSpacing: 2.0,
                                   mainAxisSpacing: 2.0,
                                   childAspectRatio: 1.1,
                                 ),
                                 itemCount: min(_prodCategory.length, 4),
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
                                             prodSubCat: _prodCategory[index]),
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
                                                   image: NetworkImage("${API.prodCat + _prodCategory[index].image}"),
                                                   alignment: Alignment(0.0, -0.70),
                                                   fit: BoxFit.contain,
                                                 ),
                                                 border: Border.all(
                                                   color: Colors.deepOrange, // Choose your desired border color
                                                   width: 0.4, // Choose your desired border width
                                                 ),
                                                 borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
              color: Colors.orange.shade50.withOpacity(0.9),

              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          /*shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.deepOrange, // Border color
                              width: 1.0, // Border width
                            ),
                          ),*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Power Meter",
                                  style: TextStyle(
                                //    fontFamily: 'DancingScript',
                                    fontWeight: FontWeight.bold,
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
                                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prodCategory2.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreenWithRouteSettings(
                                                context,
                                                settings: RouteSettings(
                                                    name: detailedProductPage.routeName),
                                                screen: detailedProductPage(
                                                  products: widget.products[index],),
                                                withNavBar: true,
                                                pageTransitionAnimation: PageTransitionAnimation
                                                    .cupertino,
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
                                                    image: NetworkImage("${API.prodCat + _prodCategory2[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.deepOrange, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                          /*shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.deepOrange, // Border color
                              width: 1.0, // Border width
                            ),
                          ),*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(
                                 //   fontFamily: 'DancingScript',
                                    fontWeight: FontWeight.bold,
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
                                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prodCategory2.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: detailedProductPage.routeName),
                                            screen: detailedProductPage(
                                              products: widget.products[index],),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
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
                                                    image: NetworkImage("${API.prodCat + _prodCategory2[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.deepOrange, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
              color: Colors.orange.shade50.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(

                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Power Meter",
                                  style: TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.deepOrangeAccent, // Adjust the text color
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
                                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prodCategory3.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return /*InkWell(
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreenWithRouteSettings(
                                                context,
                                                settings: RouteSettings(
                                                    name: detailedProductPage.routeName),
                                                screen: detailedProductPage(
                                                  products: widget.products[index],),
                                                withNavBar: true,
                                                pageTransitionAnimation: PageTransitionAnimation
                                                    .cupertino,
                                              );
                                            },
                                            child: */Container(
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
                                                    image: NetworkImage("${API.prodCat + _prodCategory3[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.deepOrange, // Choose your desired border color
                                                    width: 0.4// Choose your desired border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                                      //    ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.deepOrangeAccent, // Adjust the text color
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
                                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prodCategory3.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return /*InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: detailedProductPage.routeName),
                                            screen: detailedProductPage(
                                              products: widget.products[index],),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
                                          );
                                        },
                                        child: */Container(
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
                                                    image: NetworkImage("${API.prodCat + _prodCategory3[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.deepOrange, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                                      //    ),
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
              color: Colors.orange.shade50.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(

                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Power Meter",
                                  style: TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.deepOrangeAccent, // Adjust the text color
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
                                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prodCategory4.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return /*InkWell(
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreenWithRouteSettings(
                                                context,
                                                settings: RouteSettings(
                                                    name: detailedProductPage.routeName),
                                                screen: detailedProductPage(
                                                  products: widget.products[index],),
                                                withNavBar: true,
                                                pageTransitionAnimation: PageTransitionAnimation
                                                    .cupertino,
                                              );
                                            },
                                            child: */Container(
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
                                                    image: NetworkImage("${API.prodCat + _prodCategory4[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  border: Border.all(
                                                      color: Colors.deepOrange, // Choose your desired border color
                                                      width: 0.4// Choose your desired border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                                      //    ),
                                    );
                                  }),
                            ],
                          ),

                        ),
                      ),

                      Expanded(
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                                    color: Colors.deepOrangeAccent, // Adjust the text color
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
                                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: min(_prodCategory4.length, 4),
                                  // Display only the first 4 items,
                                  itemBuilder: (BuildContext context, int index) {
                                    return /*InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: RouteSettings(
                                                name: detailedProductPage.routeName),
                                            screen: detailedProductPage(
                                              products: widget.products[index],),
                                            withNavBar: true,
                                            pageTransitionAnimation: PageTransitionAnimation
                                                .cupertino,
                                          );
                                        },
                                        child: */Container(
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
                                                    image: NetworkImage("${API.prodCat + _prodCategory4[index].image}"),
                                                    alignment: Alignment(0.0, -0.70),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.deepOrange, // Choose your desired border color
                                                    width: 0.4, // Choose your desired border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius for rounded corners
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
                                      //    ),
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

            SizedBox(height: 15,),

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
                itemCount: _prodCategory.where((productCategory) => productCategory.status == "Active").length,
                itemBuilder: (context, index) {
                  var productCategory = _prodCategory.where((productCategory) => productCategory.status == "Active").toList()[index];
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
                                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
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
                  );
                },
              ),
            )



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
