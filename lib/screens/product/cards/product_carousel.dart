import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../config/api_connection.dart';
import '../../screens.dart';

class productCarousel extends StatelessWidget {
  final List<product> products;
  const productCarousel({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: detailedProductPage.routeName),
                screen: detailedProductPage(products: products[index],),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.01,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.4 * 0.5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("${API.prodImg + products[index].image}"),
                            alignment: Alignment(0.0, -0.70),
                            fit: BoxFit.fill,
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
                            products[index].name,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                        Icon(Icons.ads_click_sharp, color: Colors.deepOrange, size: MediaQuery.of(context).size.width * 0.06 ),
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

