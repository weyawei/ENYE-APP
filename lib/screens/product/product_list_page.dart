import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class listProductsPage extends StatefulWidget {
  static const String routeName = '/catalog';

  Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: listProductsPage.routeName),
      builder: (_) => listProductsPage(prodSubCat: prodSubCat,),
    );
  }

  final productSubCategory prodSubCat;
  const listProductsPage({required this.prodSubCat});

  @override
  State<listProductsPage> createState() => _listProductsPageState();
}

class _listProductsPageState extends State<listProductsPage> {

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

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
        appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: screenHeight * 0.05,),
        body: _isLoadingProd
            ? Center(child: CircularProgressIndicator())
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
              SizedBox(height: screenHeight * 0.04,),
              Text(
                '${widget.prodSubCat.name}'.toUpperCase(),
                style: TextStyle(
                  fontSize: fontExtraSize,
                  letterSpacing: 0.8,
                  fontFamily: 'Rowdies',
                  fontWeight: FontWeight.bold,
              //    color: Colors.grey.shade600,
                  /*shadows: [
                    Shadow(
                      offset: Offset(-1.5, -1.5),
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black38,
                    ),
                  ],*/
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 15,),
              productCarousel(
                products: _products.where((product) =>
                product.subCategory_id == widget.prodSubCat.id
                ).toList(),
              ),
            ],
          ),
        )
    );
  }
}

