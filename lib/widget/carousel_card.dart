
import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/products/category_model.dart';
import '../screens/products/subcategory_screen.dart';

class CarouselCard extends StatefulWidget {
  final Category1 category;
  const CarouselCard({required this.category,});

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          setState(() {
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SubCategoryScreen.routeName, arguments: {'name': widget.category.name}),
              screen: SubCategoryScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          });
        });
        /*Navigator.pushNamed(context,
          CatalogScreen.routeName,
          arguments: widget.category,
        );*/
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.asset(widget.category.imageUrl, fit: BoxFit.cover, width: 1000.0),
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
                    widget.category.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselCard1 extends StatefulWidget {
  final Category1 category;
  const CarouselCard1({required this.category,});

  @override
  State<CarouselCard1> createState() => _CarouselCard1State();
}

class _CarouselCard1State extends State<CarouselCard1> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          setState(() {
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SubCategoryScreen.routeName, arguments: {'name': widget.category.name}),
              screen: SubCategoryScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          });
        });
        /*Navigator.pushNamed(context,
          CatalogScreen.routeName,
          arguments: widget.category,
        );*/
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.label_important_outlined,
              size: 10,
              color: Colors.black,
            ),
            SizedBox(height: 15.0, width: 15,),
            Flexible(
              child: Text(
                widget.category.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselCard2 extends StatefulWidget {
  final Category1 category;
  const CarouselCard2({required this.category,});

  @override
  State<CarouselCard2> createState() => _CarouselCard2State();
}

class _CarouselCard2State extends State<CarouselCard2> {
  String _getIconPath() {
    switch (widget.category.name) {
      case 'Accesories':
        return 'assets/icons/icon_product_categ/plug.png';
      case 'Air Release Valve':
        return 'assets/icons/icon_product_categ/valve1.png';
      case 'Automatic Control Valve':
        return 'assets/icons/icon_product_categ/controller.png';
      case 'Backflow Preventer':
        return 'assets/icons/icon_product_categ/valve1.png';
      case 'Balancing Valves':
        return 'assets/icons/icon_product_categ/valve2.png';
      case 'Ball Valves':
        return 'assets/icons/icon_product_categ/valve3.png';
      case 'Check Valve':
        return 'assets/icons/icon_product_categ/valve4.png';
      case 'Concentric Butterfly Valve':
        return 'assets/icons/icon_product_categ/valve.png';
      case 'Enye Controls Motorized Valves and Actuators':
        return 'assets/icons/icon_product_categ/valve.png';
      case 'Flexible Joint':
        return 'assets/icons/icon_product_categ/valve1.png';
      case 'Gate Valve':
        return 'assets/icons/icon_product_categ/valve2.png';
      case 'Globe Valve':
        return 'assets/icons/icon_product_categ/valve3.png';
      case 'Plunger Valve':
        return 'assets/icons/icon_product_categ/valve4.png';
      case 'Softwares':
        return 'assets/icons/icon_product_categ/controller.png';
      case 'Strainers':
        return 'assets/icons/icon_product_categ/plug.png';
      case 'Test Equipments':
        return 'assets/icons/icon_product_categ/plug.png';
      case 'Variable Frequency Drive':
        return 'assets/icons/icon_product_categ/valve1.png';
      case 'Water Meter':
        return 'assets/icons/icon_product_categ/valve2.png';
    // Add more cases for other category names and their corresponding icon paths
      default:
        return 'assets/icons/icon_product_categ/valve.png';
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          setState(() {
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SubCategoryScreen.routeName, arguments: {'name': widget.category.name}),
              screen: SubCategoryScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          });
        });
        /*Navigator.pushNamed(context,
          CatalogScreen.routeName,
          arguments: widget.category,
        );*/
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _getIconPath(),
              height: 50,
              width: 50,
            ),
           // SizedBox(height: 15.0, width: 15,),
           Flexible(
              child: Text(
                textAlign: TextAlign.center,
                widget.category.name,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}