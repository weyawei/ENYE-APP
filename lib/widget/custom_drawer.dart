import 'package:flutter/material.dart';

import '../screens/products/category_model.dart';
import 'carousel_card.dart';

class CustomDrawer extends StatelessWidget {

  const CustomDrawer({super.key});

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
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (context)=> NavBar(),));
 
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("Account"),
 
 
              onTap: () {},
 
            ),
            ListTile(
              leading: const Icon(Icons.contact_emergency),
              title: const Text("Contact Us"),
 
 
              onTap: () {},
 
            ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text("Informations"),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              title: const Text("Systems"),
              onTap: () {
 
                
 
              },
            ),
            ListTile(
              leading: const Icon(Icons.air),
              title: const Text("Projects"),
              onTap: () {
 
 
                
 
              },
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text("About"),
   
              
 
              onTap: () {},
 
            ),
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text("Log Out"),
 
              onTap: () {},
 
            ),
          ],
        ),
      );
  }
}


class CustomDrawer1 extends StatelessWidget {

  const CustomDrawer1({super.key});

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
           ExpansionTile(
              initiallyExpanded: true,
              title: Text(
               'PRODUCT CATEGORIES',
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
      ),
    ],
      ),
    );
  }
}