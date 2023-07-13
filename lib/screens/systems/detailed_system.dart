import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';
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

  List<SystemsTechSpecs>? _sysTechSpecs;
  List<SystemsDetail>? _sysDetails;

  @override
  void initState(){
    super.initState();
    _getSysTechSpecs();
    _getSysDetails();
  }

  _getSysTechSpecs(){
    systemService.getSysTechSpecs(widget.systems.id).then((SystemsTechSpecs){
      setState(() {
        _sysTechSpecs = SystemsTechSpecs;
      });
      print("Length ${SystemsTechSpecs.length}");
    });
  }

  _getSysDetails(){
    systemService.getSysDetails(widget.systems.id).then((SystemsDetail){
      setState(() {
        _sysDetails = SystemsDetail;
      });
      print("Length ${SystemsDetail.length}");
    });
  }




  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget> [
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

      widget.systems.description == null || widget.systems.description.isEmpty
        ? Container()
        : SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text("System Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.deepOrange),),

              SizedBox(height: 20,),
              Text(widget.systems.description, maxLines: null, textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, letterSpacing: 1),),
            ],
          ),
      ),
        ),

      if (_sysDetails != null && _sysDetails!.isNotEmpty)
        SingleChildScrollView(
        child: Container(
          child: Column(
            children: _sysDetails!.map((SystemsDetail) => Text(SystemsDetail.title)).toList(),
          ),
        ),
      ),

      if (_sysTechSpecs != null && _sysTechSpecs!.isNotEmpty)
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: _sysTechSpecs!.map((SystemsTechSpecs) => ExpansionTile(
                title: Text(
                  SystemsTechSpecs.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage("${API.sysTechImg + SystemsTechSpecs.image}", scale: 1.8), alignment: Alignment.topRight),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.1)],
                          stops: [0.0, 1],
                          begin: Alignment.topCenter,
                        ),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.deepOrange.shade200, Colors.deepOrange.withOpacity(0.1)],
                          ),
                        ),
                        child: Text(
                          "${SystemsTechSpecs.features}",
                          style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
        ),
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Systems', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: _pages,
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
                  count: _pages.length,
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

