import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
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

class _detailedSysPageState extends State<detailedSysPage> with TickerProviderStateMixin {

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

  List<SystemsTechSpecs> _sysTechSpecs = [];
  List<SystemsDetail> _sysDetails = [];
  List<Systems> _systems = [];

  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _getSysTechSpecs();
    _getSysDetails();
    _getSystems();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  _getSystems(){
    systemService.getSystems().then((Systems){
      setState(() {
        _systems = Systems.where((system) => widget.systems.id == system.id).toList();
      });
      _isLoading = false;
      print("Length ${Systems.length}");
    });
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

  //if image is still loading
  bool isImageLoading = true;
  ImageProvider _buildNetworkImage(String imageUrl) {
    try {
      ImageProvider _networkImage = NetworkImage(imageUrl);
      _networkImage.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((info, synchronousCall) {
          setState(() {
            isImageLoading = false; // Update the loading status when the image is loaded
          });
        }),
      );

      if (isImageLoading){
        return AssetImage("assets/icons/orange_circles.gif");
      } else {
        return NetworkImage(imageUrl);
      }

    } catch (error) {
      // Handle the error
      print('Error loading image: $error');
      return AssetImage("assets/icons/orange_circles.gif"); // Replace with a fallback image URL
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
      appBar: CustomAppBar(title: 'Systems', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      /*drawer: CustomDrawer(),*/
      body: _isLoading
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _getSystems();
                _getSysTechSpecs();
                _getSysDetails();
              });
            },
            child: ListView(
                children: [
                  MasonryGridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    children: <Widget> [

                      SizedBox(height: screenHeight * 0.05,),
                      //title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                        child: Text(
                          _systems[0].title.toString().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontExtraSize,
                              fontFamily: 'Rowdies',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.grey
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05,),
                      if (_systems[0].youtubeUrl.toString().isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: youtubePlayerView(
                              url: _systems.elementAt(0).youtubeUrl.toString()
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.065,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Text(
                          "System Description",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rowdies',
                              fontSize: fontXXSize,
                              color: Colors.deepOrange,
                              letterSpacing: 1.2
                          ),
                        ),
                      ),


                      SizedBox(height: screenHeight * 0.035,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Text(_systems[0].description.toString(), maxLines: null, textAlign: TextAlign.justify,
                          style: TextStyle(height: 1.5, fontSize: fontNormalSize, fontStyle: FontStyle.italic, letterSpacing: 1.2),),
                      ),

                      if (_sysDetails != null && _sysDetails!.isNotEmpty)
                        Container(
                          child: Column(
                            children: _sysDetails!.map((SystemsDetail) =>
                                Column(
                                  children: [
                                    SizedBox(height: screenHeight * 0.075,),
                                    if (SystemsDetail.title != null && SystemsDetail.title!.isNotEmpty)
                                      Text(SystemsDetail.title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rowdies', fontSize: fontXSize, color: Colors.deepOrange, letterSpacing: 1.2),),

                                    if (SystemsDetail.description != null && SystemsDetail.description!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.035,),
                                      child: Text(SystemsDetail.description, maxLines: null, textAlign: TextAlign.justify,
                                        style: TextStyle(height: 1.5, fontSize: fontNormalSize, fontStyle: FontStyle.italic, letterSpacing: 1.2),),
                                    ),


                                    if (SystemsDetail.image != null && SystemsDetail.image!.isNotEmpty)
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FullScreenImage(imagePath: "${API.sysDetailsImg + SystemsDetail.image}"),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.075, vertical: screenHeight * 0.035,),
                                          child: Container(
                                            height: screenHeight * 0.3,
                                            width: screenWidth * 0.9,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: _buildNetworkImage("${API.sysDetailsImg + SystemsDetail.image}"),
                                                alignment: Alignment.center,
                                                fit: isImageLoading ? BoxFit.scaleDown : BoxFit.fill
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                            ).toList(),
                          ),
                        ),

                      if (_sysTechSpecs != null && _sysTechSpecs!.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(height: screenHeight * 0.035,),
                            Lottie.asset(
                              'assets/lottie/technical_specs.json',
                              height: screenHeight * 0.13,
                              width: screenWidth * 0.9,
                            ),
                            SizedBox(height: screenHeight * 0.035,),
                            Text(
                              "Technical Specifications",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rowdies',
                                fontSize: fontXXSize,
                                color: Colors.deepOrange,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              child: Column(
                                children: _sysTechSpecs!.map((SystemsTechSpecs) => ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Text(
                                    SystemsTechSpecs.title,
                                    style: TextStyle(
                                      fontSize: fontNormalSize,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  children: [
                                    SystemsTechSpecs.product_pdf == null || SystemsTechSpecs.product_pdf.isEmpty
                                     ? Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage("${API.sysTechImg + SystemsTechSpecs.image}", scale: fontNormalSize == 14.0 ? 2.5 : fontNormalSize == 18.0 ? 1.75 : 1.5,), alignment: Alignment.topRight),
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
                                          width: screenWidth * 1,
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
                                              style: TextStyle(height: 1.5, fontSize: fontNormalSize, color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                     : Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage("${API.sysTechImg + SystemsTechSpecs.image}", scale: fontNormalSize == 14.0 ? 2.5 : fontNormalSize == 18.0 ? 1.75 : 1.5,), alignment: Alignment.topRight),
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
                                          width: screenWidth * 1,
                                          padding: EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                                            ),
                                          ),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ...SystemsTechSpecs.product_pdf.map((product) {
                                                  return TextButton(
                                                    onPressed: () => openFile(
                                                      url: "${API.prodPdf + product['catalogs_pdf']}",
                                                      filename: "${product['catalogs_pdf']}",
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,  // Use min to prevent the Row from occupying more space than its children need.
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.download_for_offline_rounded,
                                                          color: Colors.white,
                                                          size: (screenHeight + screenWidth) / 40,
                                                        ),// Example icon
                                                        SizedBox(width: 8),  // Space between icon and text
                                                        Text(
                                                          product['prod_name'],
                                                          style: TextStyle(
                                                            height: 1.5,
                                                            fontSize: fontSmallSize,
                                                            fontFamily: 'Rowdies',
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            letterSpacing: 1.2,
                                                          ),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                if (SystemsTechSpecs.product_pdf.length < 3)
                                                  SizedBox(height: screenHeight * 0.15),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ]
      ),
          ),
      floatingActionButton: Container(
        height: (screenHeight + screenWidth) / 20,
        width: (screenHeight + screenWidth) / 20,
        child: FloatingActionButton(
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
                        height: screenHeight / 15,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth / 10,
                              height: screenHeight / 12,
                              child:
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                top: screenHeight / 40,
                                child: Text(
                                  "${_progress?.toInt().toString()} %",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
                      : Column(
                        children: [
                          Icon(Icons.remove_red_eye, size: (screenHeight + screenWidth) / 70,),
                          Text("PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSmallSize),),
                        ],
                      ),
                ]
            )
        ),
      ),
    );
  }
}