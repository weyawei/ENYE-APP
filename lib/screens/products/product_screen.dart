

import 'package:enye_app/screens/products/product_model.dart';
import 'package:enye_app/screens/products/productinfo_model.dart';
import 'package:enye_app/widget/CarouselCardProduct.dart';
import 'package:enye_app/widget/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


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
                      if (info.imageUrl.isNotEmpty)
                      Center(
                        child: GestureDetector(
                          onTap: () {

                          },

                          child: Icon(Icons.picture_as_pdf),),

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
