import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class detailedProductPage extends StatelessWidget {

  static const String routeName = '/product';

  Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => detailedProductPage(products: products)
    );
  }
  final product products;
  const detailedProductPage({required this.products});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: products.name, imagePath: '',),
      body: ListView(
        children:[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Image.network("${API.prodImg + products.image}", fit: BoxFit.fill, width: 200,),
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
                          products.name,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

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
