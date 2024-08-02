import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../config/api_connection.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';
import '../detailed_product_page2.dart';

class productCarousel extends StatefulWidget {
  final List<product> products;
  const productCarousel({
    super.key,
    required this.products,
  });

  @override
  State<productCarousel> createState() => _productCarouselState();
}

class _productCarouselState extends State<productCarousel> {

  List<productCategory> _prodCategory = [];
  @override
  void initState() {
    _getProdCategory();
  }

  bool _isLoadingProdCategory = true;
  _getProdCategory(){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory;
      });
      _isLoadingProdCategory = false;
      print("Length ${productCategory.length}");
    });
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

    return _isLoadingProdCategory
      ? Center(child: CircularProgressIndicator())
      : MasonryGridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: fontNormalSize,
          mainAxisSpacing: fontNormalSize,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenLayout ? 2 : 3,
          ),
          itemCount: widget.products.length,
          itemBuilder: (BuildContext context, int index) {
            productCategory prodCategory = _prodCategory.where((element) => element.id == widget.products[index].category_id).elementAt(0);

            return InkWell(
              onTap: (){
                // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                //   context,
                //   settings: RouteSettings(name: detailedProductPage.routeName),
                //   screen: detailedProductPage(products: widget.products[index],),
                //   withNavBar: true,
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );

                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: detailedProductPage.routeName),
                  // screen: detailedProductPage(products: widget.products[index],),
                  screen: ProductItemScreen(products: widget.products[index], category: prodCategory),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        height: fontExtraSize * 9,
                        width: fontExtraSize * 9,
                        image: NetworkImage(
                          "${API.prodImg + widget.products[index].image}",
                        )
                      ),
                    ),
                    // Expanded(
                    //   child: SizedBox(
                    //     width: MediaQuery.of(context).size.width * 0.4,
                    //     height: MediaQuery.of(context).size.height * 0.6,
                    //     child: DecoratedBox(
                    //       decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //           image: NetworkImage("${API.prodImg + products[index].image}"),
                    //           alignment: Alignment(0.0, -0.70),
                    //           fit: BoxFit.contain,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   children: [
                          //     Expanded(
                          //       child: Text(
                          //         widget.products[index].name,
                          //         style: TextStyle(
                          //           fontSize: fontExtraSize,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.deepOrange,
                          //         ),
                          //         maxLines: 3,
                          //         softWrap: true,
                          //       ),
                          //     ),
                          //     SizedBox(width: 10),
                          //     Container(
                          //       decoration: BoxDecoration(
                          //         color: Colors.deepOrange.shade600,
                          //         shape: BoxShape.circle,
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black26,
                          //             blurRadius: 4.0,
                          //             offset: Offset(0, 2),
                          //           ),
                          //         ],
                          //       ),
                          //       padding: EdgeInsets.all(8.0),
                          //       child: Icon(
                          //         Icons.ads_click_sharp,
                          //         color: Colors.white,
                          //         size: fontExtraSize * 1.5,
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          Text(
                            widget.products[index].name,
                            style: TextStyle(
                              fontSize: fontNormalSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  prodCategory.name,
                                  style: TextStyle(
                                    fontSize: fontSmallSize
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.5,
                                  vertical: 2.0
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent.shade100.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25.0)
                                ),
                                child: Text(
                                  "Available",
                                  style: TextStyle(
                                    color: Colors.deepOrange.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontXSmallSize
                                  ),
                                ),
                              )
                            ],
                          )

                          // RichText(
                          //   softWrap: true,
                          //   text: TextSpan(children:
                          //   [
                          //     TextSpan(
                          //       text: widget.products[index].prod_desc.length > 70
                          //       ? widget.products[index].prod_desc.substring(0, 70) + '...'
                          //       : widget.products[index].prod_desc,
                          //       style: TextStyle(
                          //         letterSpacing: 1.2,
                          //         fontSize: fontSmallSize,
                          //         color: Colors.black87
                          //       ),
                          //     ),
                          //
                          //     TextSpan(
                          //       text: widget.products[index].prod_desc.length > 70
                          //       ? "See More"
                          //       : "",
                          //       style: TextStyle(
                          //         letterSpacing: 1.2,
                          //         fontSize: fontSmallSize,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.blueAccent
                          //       ),
                          //     ),
                          //   ]
                          //   ),
                          // ),


                          // Text(
                          //   widget.products[index].isExpanded
                          //       ? widget.products[index].prod_desc
                          //       : widget.products[index].prod_desc.length > 100
                          //       ? widget.products[index].prod_desc.substring(0, 100) + '...'
                          //       : widget.products[index].prod_desc,
                          //   style: TextStyle(
                          //     letterSpacing: 1.2,
                          //     fontSize: fontSmallSize,
                          //   ),
                          // ),
                          // if (widget.products[index].prod_desc.length > 100) // Example condition for showing "See More"
                          //   GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         // Toggle the expanded state
                          //         widget.products[index].isExpanded = !widget.products[index].isExpanded;
                          //       });
                          //     },
                          //     child: Text(
                          //       "See More",
                          //       style: TextStyle(
                          //         letterSpacing: 1.2,
                          //         fontSize: fontSmallSize,
                          //         color: Colors.blue,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /*Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5.0)),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 200.0,
                    child: Image.network("${API.prodImg + products[index].image}", fit: BoxFit.fill,),
                  ),
                  Positioned(
                    top: 60,
                    child: Container(width: MediaQuery.of(context).size.width /2.5,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.blue.shade900.withAlpha(50),),
                    ),
                  ),
                  Positioned(
                    top: 65,
                    left: 5,
                    child: Container(width: MediaQuery.of(context).size.width /2.5- 10,
                      height: 70,
                      decoration: BoxDecoration(color: Colors.blue.shade900.withAlpha(75),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(products[index].name, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                    // Text( '\₱${Product.products[0].price}',
                                    //   style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(icon: Icon(Icons.ads_click_sharp, color: Colors.white,
                              ),
                                onPressed: () {
                                  *//*PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(name: ProductScreen.routeName, arguments: {'product': product}),
                                    screen: ProductScreen(product: product),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );*//*
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/
            );
          });
  }
}

