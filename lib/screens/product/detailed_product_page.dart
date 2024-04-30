import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:photo_view/photo_view.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class detailedProductPage extends StatefulWidget {

  static const String routeName = '/product';

  Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: detailedProductPage.routeName),
        builder: (_) => detailedProductPage(products: products)
    );
  }

  final product products;
  const detailedProductPage({required this.products});

  @override
  State<detailedProductPage> createState() => _detailedProductPageState();
}

class _detailedProductPageState extends State<detailedProductPage> with TickerProviderStateMixin {


  //THIS IS FOR PDF VIEWING
  double? _progress;

  Future openFile ({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);

    if (file == null) return;

    print('Path: ${file.path}');
    OpenFile.open(file.path);
  }

  Future <File?> downloadFile (String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          //receiveTimeout: 0
        ),
        onReceiveProgress: (recivedBytes, totalBytes) {
          setState(() {
            _progress = (recivedBytes / totalBytes) * 100;
            if (_progress == 100){
              _progress = null;
            }
          });
          print(_progress);
        }
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;

  }

  bool _isLoadingProd = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();


  //LIST OF PRODUCT DETAIL
  List<detailedProduct> _productDetail = [];
  List<productCategory> _prodCategory = [];
  List<product> _products = [];
  List<product> _productsInfo = [];


  @override
  void initState() {
    _getProductDetails();
    _getProdCategory();
    _getProducts();
    _getProductsInfo();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  _getProductDetails(){
    productService.getProductDetails(widget.products.id).then((detailedProduct){
      setState(() {
        _productDetail = detailedProduct;
      });

      print("Length ${detailedProduct.length}");
    });
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
        _products = product.where((element) => element.id != widget.products.id).toList();
      });

      print("Length ${product.length}");
    });
  }

  _getProductsInfo(){
    productService.getProducts().then((product){
      setState(() {
        _productsInfo = product.where((element) => element.id == widget.products.id).toList();
      });
      _isLoadingProd = false;
      print("Length ${product.length}");
    });
  }

  Future<void> _refresh() async {
    // Simulate fetching data from the database
    await Future.delayed(Duration(seconds: 2));



    // Update UI with new data
    setState(() {
      _getProductDetails();
      _getProdCategory();
      _getProducts();
    });
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'PRODUCTS', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: _isLoadingProd
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _getProductDetails();
            _getProdCategory();
            _getProducts();
            _getProductsInfo();
          });
        },
        child: ListView(
          children:[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Image.network("${API.prodImg + _productsInfo[0].image}", fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.4 * 1.1,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            _productsInfo[0].name,
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    color: Colors.black.withAlpha(30),
                  ),
                  Container(
                    margin: const EdgeInsets.all(13.0),
                    width: MediaQuery.of(context).size.width ,

                    alignment: Alignment.bottomLeft,

                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //   Text(product.name, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)),
                          //  Text('₱${product.price}',style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)),
                          Text('PRODUCT CATALOG', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black)),
                        ],

                      ),
                    ),
                  ),
                ],
              ),
            ),*/
            /*Padding(padding: const EdgeInsets.all(5.0)),
            Text('INFORMATION :',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            for (var info in filteredInfo)
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(info.model, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text(' ${info.size}', style: TextStyle(fontSize: 11),),
                        Text('${info.price}', style: TextStyle(fontSize: 11),),
                        if (info.imageUrl.isNotEmpty)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ImageZoomScreen(imagepath: info.imageUrl,),
                                  ),
                                );
                              },

                              child: Image.asset('${info.imageUrl}', width: 100, height: 100,),

                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),*/
            /*ExpansionTile(
                initiallyExpanded: false,
                title: Text('AEX-SMP-MOD', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)),
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Size:  HMI/Server/Controller Atrius Solution Builder License included', style: Theme.of(context).textTheme.labelMedium,),
                        Text('Size:  ₱47,218.12', style: Theme.of(context).textTheme.labelMedium,),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text('FXL-Dongle', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)),
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Size:  BACnet MS/TP communication add-on for GSM-2000-SMP', style: Theme.of(context).textTheme.labelMedium,),
                        Text('Size:  ₱242,824.24', style: Theme.of(context).textTheme.labelMedium,),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text('GSM-100-DSA', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)),
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Size:  Basic license fee for Atrius Solution builder', style: Theme.of(context).textTheme.labelMedium,),
                        Text('Size:  ₱91,235.02', style: Theme.of(context).textTheme.labelMedium,),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text('GSM-1000-BMX', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)),
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Size:  MODBUS communication add-on for GSM-2000-SMP', style: Theme.of(context).textTheme.labelMedium,),
                        Text('Size:  ₱277,458.23', style: Theme.of(context).textTheme.labelMedium,),
                      ],
                    ),
                  )
                ],
              ),*/

            if(_productDetail != null || _productDetail.isNotEmpty)
              MasonryGridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: _productDetail.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      _productDetail[index].title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.031,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    children: [

                        if (_productDetail[index].description != null && _productDetail[index].description.isNotEmpty)
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(_productDetail[index].description, maxLines: null, textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.025, fontStyle: FontStyle.italic, letterSpacing: 1, color: Colors.grey.shade600),
                              ),
                            ),
                          ),

                      if (_productDetail[index].image != null && _productDetail[index].image.isNotEmpty)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ImageZoomScreen(imagepath: "${API.prodDetailsImg + _productDetail[index].image}",),
                                  ),
                                );
                              },

                              child: Image.network("${API.prodDetailsImg + _productDetail[index].image}",),

                            ),
                          ),
                        SizedBox(height: 30,),
                      ],
                  );
                }),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text widget added above the CarouselSlider
                  Text(
                    "Related Products",
                    style: TextStyle(
                      fontSize: 20, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10), // Adding some space between text and carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      viewportFraction: 0.5,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: _products.where((product) => product.category_id == _productsInfo[0].category_id).map((product) =>
                        InkWell(
                          onTap: (){
                            setState(() {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProductPage.routeName),
                                screen: detailedProductPage( products: product,),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(
                                    //"${API.prodCategIcon + widget.productcategory.icon}",
                                    "${API.prodImg + product.image}",
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.width * 0.3 * 1.3,
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(200, 0, 0, 0),
                                            Color.fromARGB(0, 0, 0, 0),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding:
                                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                      child: Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.025,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,

                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.15,
        child: FloatingActionButton(
          onPressed: () =>
            widget.products.catalogs_pdf.isEmpty || widget.products.catalogs_pdf == null || widget.products.catalogs_pdf == ''
            ? _errorSnackbar(context, "PDF File don't exist.")
            : openFile(
              url: "${API.prodPdf + widget.products.catalogs_pdf}",
              filename: "${widget.products.catalogs_pdf}",
            ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _progress != null
                    ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            child:
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              top: 10,
                              child: Text(
                                "${_progress?.toInt().toString()} %",
                                textAlign:
                                TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                )
                    : Icon(Icons.remove_red_eye),
                Text("PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.025),),
              ]
          )
        ),
      ),

    );
  }
}


class ImageZoomScreen extends StatelessWidget {

  static const String routeName = '/product';

  static Route route({required String imagepath}){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ImageZoomScreen( imagepath: imagepath)
    );
  }
  final String imagepath;
  const ImageZoomScreen({required this.imagepath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height, // Specify a fixed height for the SizedBox
              child: RepaintBoundary(
                child: PhotoView(
                  imageProvider: NetworkImage(imagepath),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*class ImageZoomScreen extends StatelessWidget {
  const ImageZoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
      Navigator.pop(context);
       },
        child: Center(
          child: Container(
            child: PhotoView(
              imageProvider: AssetImage('assets/logo/header.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}*/
