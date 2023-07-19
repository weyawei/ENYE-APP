import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../config/api_connection.dart';
import '../screens/screens.dart';

class productDrawer extends StatefulWidget {

  const productDrawer({super.key});

  @override
  State<productDrawer> createState() => _productDrawerState();
}

class _productDrawerState extends State<productDrawer> {
  List<productCategory> _prodCategory = [];
  List<productSubCategory> _prodSubCategory = [];

  @override
  void initState(){
    super.initState();
    _getProdSubCategory();
    _getProdCategory();
  }

  _getProdCategory(){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory;
      });
      print("Length ${productCategory.length}");
    });
  }

  _getProdSubCategory(){
    productService.getProdSubCategory().then((productSubCategory){
      setState(() {
        _prodSubCategory = productSubCategory;
      });
      print("Length ${productSubCategory.length}");
    });
  }

  //this code is for tile if open, other closes

  int _currentExpandedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: Container(
              //color: Colors.deepOrange,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  image: DecorationImage(
                      image: AssetImage("assets/images_1/wallpaper.jpg"), fit: BoxFit.cover)
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _prodCategory.length,
              itemBuilder: (context, index){
                return ExpansionTile(
                  key: Key(_currentExpandedTileIndex.toString()),
                  initiallyExpanded: index == _currentExpandedTileIndex,
                  onExpansionChanged: ((newState) {
                    if (newState)
                      setState(() {
                        _currentExpandedTileIndex = index;
                      });
                    else
                      setState(() {
                        _currentExpandedTileIndex = -1;
                      });
                  }),
                  title: Text(
                    _prodCategory[index].name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: _prodSubCategory.where(
                          (productSubCategory) => productSubCategory.category_id == _prodCategory[index].id).map((productSubCategory) =>
                      InkWell(
                        onTap: (){
                          setState(() {
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: listProductsPage.routeName),
                              screen: listProductsPage(prodSubCat: productSubCategory,),
                              withNavBar: true,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [Colors.deepOrange.shade100, Colors.deepOrange.withOpacity(0.1)],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.label_important_outlined,
                                size: 15,
                                color: Colors.deepOrange.shade400,
                              ),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(
                                  productSubCategory.name,
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ).toList(),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}