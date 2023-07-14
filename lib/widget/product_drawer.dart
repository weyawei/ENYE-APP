import 'package:flutter/material.dart';

class productDrawer extends StatelessWidget {

  const productDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: Container(
              //color: Colors.deepOrange,
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  image: DecorationImage(
                      image: AssetImage("assets/images_1/wallpaper.jpg"), fit: BoxFit.cover)),
              child: const Text(
                "Hi",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
          ),

          Text(
            'ALL PRODUCT CATEGORIES',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.black),
          ),

          /*ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'ALL PRODUCT CATEGORIES',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.black),
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
        ],
      ),
    );
  }
}