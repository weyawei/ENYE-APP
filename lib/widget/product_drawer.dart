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
  List<product> _products = [];

  @override
  void initState(){
    super.initState();
    _getProducts();
    _getProdCategory();
  }

  _getProdCategory(){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory.where((element) => element.status == "Active").toList();
      });
      print("Length ${productCategory.length}");
    });
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product;
      });
      print("Length ${product.length}");
    });
  }

  //this code is for tile if open, other closes

  int _currentExpandedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Drawer(
	width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
	Container(
	height: MediaQuery.of(context).size.width * 0.5,
          child: DrawerHeader(
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
                  
                  title: GestureDetector(
                    onTap: (){
                      setState(() {
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: listProductsPage.routeName),
                          screen: listProductsPage(prodSubCat: _prodCategory[index],),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      });
                    },
                    child: Text(
                      _prodCategory[index].name,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.033,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  children: _products.where(
                          (product) => product.category_id == _prodCategory[index].id).map((product) =>
                      InkWell(
                        onTap: (){
                          setState(() {
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: detailedProductPage.routeName),
                              screen: detailedProductPage(products: product,),
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
                                size: MediaQuery.of(context).size.width * 0.04,
                                color: Colors.deepOrange.shade400,
                              ),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
				    fontSize: MediaQuery.of(context).size.width * 0.025,
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