

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:enye_app/screens/products/product_model.dart';
import 'package:enye_app/screens/products/productinfo_model.dart';
import 'package:enye_app/widget/CarouselCardProduct.dart';
import 'package:enye_app/widget/carousel_card.dart';
import 'package:enye_app/widget/custom_appbar.dart';
import 'package:enye_app/widget/custom_navbar.dart';
import 'package:enye_app/widget/product_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class ProductScreen extends StatelessWidget {


  static const String routeName = '/product';

  static Route route({required Product product}){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductScreen(product: product)
    );
  }
final Product product;
  const ProductScreen({required this.product});
  @override
  Widget build(BuildContext context) {
    final filteredInfo = ProductInfo.info.where((info) => info.subcategory == product.subcategory && info.name == product.name);
    return Scaffold(
      appBar: CustomAppBar(title: product.name, imagePath: '',),
      body: ListView(
          children:[
            ProductCarouselCard(product: product),
            Padding(
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
            ),
            Padding(padding: const EdgeInsets.all(5.0)),
            Text('INFORMATION :',style: Theme.of(context).textTheme.labelLarge,),
            for (var info in filteredInfo)
            ExpansionTile(
              initiallyExpanded: false,
              title: Text(info.model, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
              children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text(' ${info.size}', style: Theme.of(context).textTheme.labelMedium,),
                      Text('${info.price}', style: Theme.of(context).textTheme.labelMedium,),
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
                      if (info.imageUrl.isNotEmpty)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PDFScreen(pdfUrl: info.pdfUrl),
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
            ),
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


          ],
      ),
    );
  }
}


class PDFScreen extends StatefulWidget {
  final String pdfUrl;

  const PDFScreen({required this.pdfUrl});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool _isLoading = true;
  int _pages = 0;
  int _currentPage = 0;
  late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    final pdfUrl = widget.pdfUrl;

    setState(() {
      _isLoading = true;
    });

    try {
      final PDFDocument pdfDocument = await PDFDocument.fromURL(pdfUrl);
      final int pageCount = pdfDocument.count;
      setState(() {
        _pages = pageCount;
        _currentPage = 1;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error loading the PDF
      print('Error loading PDF: $e');
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _pdfViewController.setPage(_currentPage);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages) {
      setState(() {
        _currentPage++;
      });
      _pdfViewController.setPage(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: widget.pdfUrl,
              onViewCreated: (PDFViewController pdfViewController) {
                _pdfViewController = pdfViewController;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page ?? 0;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: _previousPage,
              ),
              Text('Page $_currentPage of $_pages'),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: _nextPage,
              ),
            ],
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your logic to handle the download action
          // For example, show a dialog with options to save or share the PDF file
        },
        child: Icon(Icons.download),
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
                      imageProvider: AssetImage(imagepath),
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
