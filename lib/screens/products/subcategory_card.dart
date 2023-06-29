import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:enye_app/screens/products/subcategory_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class SubCategoryCard extends StatelessWidget {
  final SubCategory subcategory;
  final double widthFactor;
  const SubCategoryCard({
    super.key,
    required this.subcategory,
    this.widthFactor = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / widthFactor,
          height: 200.0,
          child: Image.asset(subcategory.imageUrl, fit: BoxFit.cover,),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subcategory.subcategory, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                        /*Text( '${SubCategory.categories[1]}',
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),*/
                      ],
                    ),
                  ),
                  Expanded(
                    child: IconButton(icon: Icon(Icons.ads_click_sharp, color: Colors.white,
                    ),
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: CatalogScreen.routeName, arguments: {'subcategory': subcategory.subcategory}),
                          screen: CatalogScreen(),
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
    );
  }
}
