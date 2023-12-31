

import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:enye_app/screens/products/product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/products/category_model.dart';
import '../screens/products/product_model.dart';

class ProductCarouselCard extends StatelessWidget {
  final Product product;

  const ProductCarouselCard({
    required this.product,
    super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
            if (this.product == null){
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: CatalogScreen.routeName, arguments: {'name': product.name}),
                screen: ProductScreen(product: product),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            }


        /*Navigator.pushNamed(context,
          CatalogScreen.routeName,
          arguments: widget.category,
        );*/
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Center(
            child: Stack(
              children: <Widget>[
                Image.asset(product.imageUrl, fit: BoxFit.cover, width: 200,),
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
                      product.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
