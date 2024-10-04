import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class listSubProductsPage extends StatefulWidget {
  static const String routeName = '/subProd';

  Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: listSubProductsPage.routeName),
      builder: (_) => listSubProductsPage(prodSubCat: prodSubCat,),
    );
  }

  final productCategory prodSubCat;
  const listSubProductsPage({required this.prodSubCat});

  @override
  State<listSubProductsPage> createState() => _listSubProductsPageState();
}

class _listSubProductsPageState extends State<listSubProductsPage> {

  bool _isLoadingProd = true;


  List<product> _products = [];
  List<productCategory> _prodCategory = [];

  @override
  void initState() {
    _getProducts();
    _getProdCategory();
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product;
      });
      print("Length ${product.length}");
    });
  }

  _getProdCategory(){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory.where((element) => element.status == "Active").toList();
      });
      _isLoadingProd = false;
      print("Length ${productCategory.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
        appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: screenHeight * 0.05,),
        body: _isLoadingProd
            ? Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getProducts();
              _getProdCategory();
            });
          },
          child: ListView(
            children: [
              SizedBox(height: 25,),
              Text(
                '${widget.prodSubCat.name}'.toUpperCase(),
                style: TextStyle(
                  fontSize: fontXXSize,
                  letterSpacing: 1.2,
                  fontFamily: 'Rowdies',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  shadows: [
                    Shadow(
                      offset: Offset(-1.5, -1.5),
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black38,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 15,),
              productSubCarousel(
                products: _products.where((product) =>
                product.category_id == widget.prodSubCat.id
                ).toList(),
              ),
            ],
          ),
        )
    );
  }
}

