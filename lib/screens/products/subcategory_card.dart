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
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      style: BorderStyle.solid,
                    ),

                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subcategory.subcategory,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 20,
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

              ],
            ),

    );
  }
}
