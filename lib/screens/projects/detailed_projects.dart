import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../config/api_connection.dart';
import '../screens.dart';
import '../../widget/widgets.dart';

class detailedProjPage extends StatefulWidget {
  static const String routeName = '/detailedproj';

  Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => detailedProjPage(projects: projects,),
    );
  }

  final Projects projects;
  detailedProjPage({required this.projects});

  @override
  State<detailedProjPage> createState() => _detailedProjPageState();
}

class _detailedProjPageState extends State<detailedProjPage> with TickerProviderStateMixin {
  List<Projects> _projects = [];
  bool _isLoadingProj = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  void initState() {
    super.initState();
    // Initially, show all products
    _getProjects();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

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

  _getProjects(){
    projectSVC.getProjects().then((Projects){
      setState(() {
        _projects = Projects.where((project) => widget.projects.proj_id == project.proj_id).toList();;
      });
      _isLoadingProj = false;
      print("Length ${Projects.length}");
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'ENYE CONTROLS', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: _isLoadingProj
          ? Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _getProjects();
              });
            },
            child:SingleChildScrollView(
              child: Stack(
                children: [
                  // Blurred Background Image
                  Positioned.fill(
                    child: Container(
                      color: Colors.transparent, // Ensure container is transparent
                      child: Stack(
                        children: [
                          // Original Background Image
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: "${API.projectsImage + _projects[0].images.toString()}",
                              imageBuilder: (context, imageProvider) => DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill, // Ensure the image covers the container
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black, // Fallback color if image fails to load
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Blur Effect
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                            child: Container(
                              color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main Image and Details Card
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Main Image (centered)
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.035),
                          height: screenHeight * 0.45, // Adjust height as needed
                          width: screenWidth * 0.88, // Adjust width as needed
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10.0,
                              ),
                            ], // Optional: Add shadow
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // Ensure border radius is applied to the image
                            child: CachedNetworkImage(
                              imageUrl: "${API.projectsImage + _projects[0].images.toString()}", // Main image URL
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.black,
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Details Card
                        Container(
                          width: screenWidth * 0.9,
                          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.035),
                          child: Card(
                            elevation: 0.0,
                            color: Colors.white.withOpacity(0.7), // Semi-transparent card background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Project Title
                                  Text(
                                    "${_projects[0].title.toString()}",
                                    style: TextStyle(
                                      fontSize: fontXXSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                     letterSpacing: 1.2,
                                    ),
                                  ),

                                  // Project Description 1
                                  SizedBox(height: 8.0),
                                  Text(
                                    "${_projects[0].description1.toString()}",
                                    style: TextStyle(
                                      fontSize: fontNormalSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      wordSpacing: 2.0,
                                      height: 1.65,
                                      letterSpacing: 1.2,
                                    ),
                                  ),

                                  // Project Description 2
                                  SizedBox(height: 8.0),
                                  Text(
                                    "${_projects[0].description2.toString()}",
                                    style: TextStyle(
                                      fontSize: fontNormalSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 2.0,
                                      letterSpacing: 1.2,
                                      height: 1.5,
                                    ),
                                  ),

                                  // View Catalog Button
                                  _projects[0].projCatalogs == null || _projects[0].projCatalogs.isEmpty
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: [
                                        Lottie.asset("assets/lottie/arrow_detailed_projects.json", height: screenHeight * 0.05),
                                        _progress != null
                                            ? const CircularProgressIndicator()
                                            : TextButton(
                                          child: Text(
                                            "View Catalog",
                                            style: TextStyle(
                                              fontSize: fontExtraSize,
                                              color: Colors.deepOrange,
                                              fontWeight: FontWeight.bold,
                                              wordSpacing: 2.0,
                                              letterSpacing: 1.2,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          onPressed: () => openFile(
                                            url: "${API.fileCatalogsPdf + _projects[0].projCatalogs.toString()}",
                                            filename: "${_projects[0].projCatalogs.toString()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )

      )
    );
  }
}