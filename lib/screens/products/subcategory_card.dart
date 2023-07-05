import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:enye_app/screens/products/subcategory_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class SubCategoryCard extends StatelessWidget {
  final SubCategory subcategory;
  final double widthFactor;

  const SubCategoryCard({
    Key? key,
    required this.subcategory,
    this.widthFactor = 2.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(
            name: CatalogScreen.routeName,
            arguments: {
              'subcategory': subcategory.subcategory
            },
          ),
          screen: CatalogScreen(),
          withNavBar: true,
          pageTransitionAnimation:
          PageTransitionAnimation.cupertino,
        );
      },
        child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / widthFactor,
                  height: 200.0,

                ),
                Positioned(
                  top: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 112,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(50),
                    ),
                  ),
                ),
                Positioned(
                  top: 65,
                  left: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width / widthFactor -10,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subcategory.subcategory,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(
                                      name: CatalogScreen.routeName,
                                      arguments: {
                                        'subcategory': subcategory.subcategory
                                      },
                                    ),
                                    screen: CatalogScreen(),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

    );
  }
}
