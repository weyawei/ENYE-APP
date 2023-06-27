
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/screens/products/model.dart';
import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:enye_app/widget/product_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/widget/widgets.dart';
import '../../widget/product_card.dart';
import '../../widget/section_title.dart';
import 'category_model.dart';


class ProductPage extends StatelessWidget {
  static const String routeName = '/products';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductPage()
    );
  }
  ProductPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: '',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
               // height: MediaQuery.of(context).size.height * 1,
               child: CarouselSlider(
    options: CarouselOptions(
    aspectRatio: 1.5,
    viewportFraction: 0.9,
    enlargeCenterPage: true,
    enlargeStrategy: CenterPageEnlargeStrategy.height,
    ), items: Category1.categories.map((category) => CarouselCard(category: category)).toList(),

    ),
    ),
            SectionTitle(title: 'RECOMMENDED'),
            //Product Carousel
            /*ProductCard(product: Product.products[0],),*/
            ProductCarousel(products: Product.products.where((product) => product.isRecommended).toList()),
            SectionTitle(title: 'MOST POPULAR'),
            //Product Carousel
            /*ProductCard(product: Product.products[0],),*/
            ProductCarousel(products: Product.products.where((product) => product.isPopular).toList()),
          ],
        ),
      ),
    );
  }
}

