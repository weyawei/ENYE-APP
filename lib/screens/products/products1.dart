
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
      drawer: CustomDrawer1(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
               // height: MediaQuery.of(context).size.height * 1,
               child: CarouselSlider(
             options: CarouselOptions(
               autoPlay: true,
              aspectRatio: 1.5,
              viewportFraction: 0.9,
               enlargeCenterPage: true,
               enlargeStrategy: CenterPageEnlargeStrategy.height,
             ), items: Category1.categories.map((category) => CarouselCard(category: category)).toList(),

          ),
         ),
           // SectionTitle(title: 'CATEGORIES'),
           /* Container(

              height: MediaQuery.of(context).size.height * 0.3,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4.8,
                ),
                itemCount: Category1.categories.length,
                itemBuilder: (context, index) {
                  final category = Category1.categories[index];
                  return CarouselCard1(category: category);
                },
              ),
            ),*/
            /*ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                'CATEGORIES',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
              ),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Adjust the number of columns as needed
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 9.8, // Adjust the aspect ratio as needed
                  ),
                  itemCount: Category1.categories.length,
                  itemBuilder: (context, index) {
                    final category = Category1.categories[index];
                    return CarouselCard1(category: category);
                  },
                ),
              ],
            ),*/
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

