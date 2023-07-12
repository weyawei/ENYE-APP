import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/api_connection.dart';
import '../../widget/custom_appbar.dart';
import '../screens.dart';

class detailedSysPage extends StatefulWidget {
  static const String routeName = '/detailedsystem';

  Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: detailedSysPage.routeName),
        builder: (_) => detailedSysPage(systems: systems)
    );
  }

  final Systems systems;
  detailedSysPage({required this.systems});

  @override
  State<detailedSysPage> createState() => _detailedSysPageState();
}

class _detailedSysPageState extends State<detailedSysPage> {


  PageController _pageController = new PageController();

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
            _progress = recivedBytes / totalBytes;
            if (_progress == 1.0){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Systems', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage("${API.systemsImg + widget.systems.image}"), fit: BoxFit.fill),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.withOpacity(0.4), Colors.deepOrange.shade100.withOpacity(0.3)],
                      stops: [0.0, 1],
                      begin: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              Container(),
              Container(),
            ],
          ),

          //dot controller of pageview
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.centerRight,
                child: SmoothPageIndicator(
                  axisDirection: Axis.vertical,
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(dotColor: Colors.orange, activeDotColor: Colors.deepOrange),
                  onDotClicked: (index) => _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut,),
                ),
              ),
            ],
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => openFile(
            url: "${API.fileCatalogsPdf + widget.systems.catalogs_pdf}",
            filename: "${widget.systems.catalogs_pdf}",
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _progress != null
            ? const CircularProgressIndicator(color: Colors.white,)
            : Icon(Icons.remove_red_eye),
              Text("PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),),
          ]
        )
      ),
    );
  }
}

