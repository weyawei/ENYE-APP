import 'dart:math';

import 'package:flutter/material.dart';

import '../../../config/api_connection.dart';
import '../../screens.dart';

class categoryCarousel extends StatefulWidget {
  final productCategory productcategory;
  const categoryCarousel({required this.productcategory,});

  @override
  State<categoryCarousel> createState() => _categoryCarouselState();
}

class _categoryCarouselState extends State<categoryCarousel> {
  List<product> _products = [];

  void initState() {
    _getProducts();
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product;
      });
      print("Length ${product.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    _products = _products.where((product) => product.category_id == widget.productcategory.id).toList();

    var randomIndex = Random().nextInt(_products.length);

    return InkWell(
      onTap: (){
        setState(() {
          /*setState(() {
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SubCategoryScreen.routeName, arguments: {'name': widget.category.name}),
              screen: SubCategoryScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          });*/
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
              Image.network(
                //"${API.prodCategIcon + widget.productcategory.icon}",
                "${API.prodImg + _products[randomIndex].image}",
                fit: BoxFit.fill, width: 1000.0),
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
                    widget.productcategory.name,
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