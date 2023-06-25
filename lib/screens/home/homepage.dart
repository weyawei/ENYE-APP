import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/custom_drawer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  static Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => HomePage()
    );
  }

  final List<String> imgList = [
    'assets/homepage/pix1.png',
    'assets/homepage/pix2.png',
    'assets/homepage/pix3.png',
    'assets/homepage/pix4.png',
    'assets/homepage/pix5.png',
    'assets/homepage/pix6.png',
    'assets/homepage/pix6.2.png',
    'assets/homepage/pix6.3.png',
    'assets/homepage/pix7.png',
    'assets/homepage/pix8.png',
    'assets/homepage/pix9.png',
    'assets/homepage/pix10.png',
    'assets/homepage/pix11.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png',),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
                items: imgList.map((item) => Container(
                  margin: const EdgeInsets.all(.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      item,
                      fit: BoxFit.fill,
                    ),
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: 470,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
            ),
          ],
        ),
      )
    );
  }
}