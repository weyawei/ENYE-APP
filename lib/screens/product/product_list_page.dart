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

  final productCategory prodSubCat;
  const listProductsPage({required this.prodSubCat});

  @override
  State<listProductsPage> createState() => _listProductsPageState();
}

class _listProductsPageState extends State<listProductsPage> with TickerProviderStateMixin {

  bool _isLoadingProd = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();


  List<product> _products = [];
  List<productCategory> _prodCategory = [];

  @override
  void initState() {
    _getProducts();
    _getProdCategory();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
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
            ? Center(child: SpinningContainer(controller: _controller),)
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
                  fontSize: fontXXXSize,
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
              productCarousel(
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

