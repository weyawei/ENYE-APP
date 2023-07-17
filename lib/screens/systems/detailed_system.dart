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
  ScrollController _scrollController = new ScrollController();

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

  List<SystemsTechSpecs>? _sysTechSpecs;
  List<SystemsDetail>? _sysDetails;

  @override
  void initState(){
    super.initState();
    _scrollController.addListener(_scrollListener);
    _getSysTechSpecs();
    _getSysDetails();
  }

  _getSysTechSpecs(){
    systemService.getSysTechSpecs(widget.systems.sys_tech_id).then((SystemsTechSpecs){
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

  List<Widget> _pages(){
    return [
      if (widget.systems.image != null && widget.systems.image.isNotEmpty)
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

      if (widget.systems.description != null && widget.systems.description.isNotEmpty)
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("System Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.deepOrange),),

                  SizedBox(height: 20,),
                  Text(widget.systems.description, maxLines: null, textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, letterSpacing: 1),),
                ],
              ),
            ),
          ),
        ),

      if (_sysDetails != null && _sysDetails!.isNotEmpty)
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: _sysDetails!.map((SystemsDetail) =>
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        if (SystemsDetail.title != null && SystemsDetail.title!.isNotEmpty)
                          Text(SystemsDetail.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.deepOrange),),

                        SizedBox(height: 20,),
                        if (SystemsDetail.description != null && SystemsDetail.description!.isNotEmpty)
                          Text(SystemsDetail.description, maxLines: null, textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, letterSpacing: 1),),

                        SizedBox(height: 20,),
                        if (SystemsDetail.image != null && SystemsDetail.image!.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage("${API.sysDetailsImg + SystemsDetail.image}"), fit: BoxFit.fill),
                            ),
                          )
                      ],
                    )
                ).toList(),
              ),
            ),
          ),
        ),

      if (_sysTechSpecs != null && _sysTechSpecs!.isNotEmpty)
        SingleChildScrollView(
          controller: _scrollController,
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
                      image: DecorationImage(image: NetworkImage("${API.sysTechImg + SystemsTechSpecs.image}", scale: 2.5), alignment: Alignment.topRight),
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
                            colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(right: 70.0),
                          child: Text(
                            "${SystemsTechSpecs.features}",
                            style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
                            textAlign: TextAlign.left,
                          ),
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
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      // Scrolled to the end of the SingleChildScrollView
      // Move to the next page in the PageView
      int nextPage = _pageController.page!.round() + 1;
      if (nextPage < _pages().length) {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 7000),
          curve: Curves.ease,
        );
      }
    }
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0) {
      // Scrolled to the end of the SingleChildScrollView
      // Move to the next page in the PageView
      int previousPage = _pageController.page!.round() - 1;
      if (previousPage >= 0) {
        _pageController.animateToPage(
          previousPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
      }
    }
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
            children: _pages(),
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
                  count: _pages().length,
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
                    ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
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
                              top: 15,
                              child: Text(
                                "${_progress?.toInt().toString()} %",
                                textAlign:
                                TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
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
                Text("PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),),
              ]
          )
      ),
    );
  }
}

