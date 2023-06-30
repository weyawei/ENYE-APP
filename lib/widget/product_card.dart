import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/products/product_model.dart';
import '../screens/products/product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double widthFactor;
  const ProductCard({
    super.key,
    required this.product,
    this.widthFactor = 2.5,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: ProductScreen.routeName, arguments: product),
          screen: ProductScreen(product: product,),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / widthFactor,
            height: 200.0,
            child: Image.asset(product.imageUrl, fit: BoxFit.cover,),
          ),
          Positioned(
            top: 60,
            child: Container(width: MediaQuery.of(context).size.width /2.5,
              height: 80,
              decoration: BoxDecoration(color: Colors.black.withAlpha(50),),
            ),
          ),
          Positioned(
            top: 65,
            left: 5,
            child: Container(width: MediaQuery.of(context).size.width /2.5- 10,
              height: 70,
              decoration: BoxDecoration(color: Colors.black,
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
                            Text(product.name, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
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
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: ProductScreen.routeName, arguments: {'product': product}),
                            screen: ProductScreen(product: product),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
