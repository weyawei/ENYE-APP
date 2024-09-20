import 'package:cached_network_image/cached_network_image.dart';
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
      ? Container(height: screenHeight * 0.8, child: Center(child: CircularProgressIndicator()))
      : widget.products.length == 0
        ? Container(
          height: screenHeight * 0.8,
          child: Center(
            child: Text(
              "No Available Data",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontExtraSize * 2,
                color: Colors.grey.shade300,
                letterSpacing: 1.2
              ),
            ),
          ),
        )
      : GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.035,
        vertical: screenHeight * 0.02
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenLayout ? 2 : 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: fontNormalSize
      ),
      itemCount: widget.products.length,
      itemBuilder: (BuildContext context, int index) {
        var product = widget.products[index];
        var prodCategory = _prodCategory
            .firstWhere((category) => category.id == product.category_id);

        return InkWell(
          onTap: () {
            // Handle the tap event, such as navigating to a new screen
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: detailedProductPage.routeName),
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
                                prodCategory.name,
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
    );
  }
}

