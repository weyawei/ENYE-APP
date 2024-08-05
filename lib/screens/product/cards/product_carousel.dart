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
      ? Center(child: CircularProgressIndicator())
      : GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenLayout ? 2 : 3,
        childAspectRatio: 0.7, // Adjust ratio for desired item aspect
        crossAxisSpacing: fontNormalSize,
        mainAxisSpacing: fontNormalSize,
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
              screen: ProductItemScreen(products: product, category: prodCategory),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
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
                  SizedBox(
                    height: fontExtraSize * 9, // Fixed height for images
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
                        SizedBox(
                          height: 40.0, // Fixed height for text
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
                        SizedBox(height: 8.0),
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

