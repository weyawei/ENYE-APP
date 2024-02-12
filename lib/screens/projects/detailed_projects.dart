import 'dart:io';
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

class _detailedProjPageState extends State<detailedProjPage> {

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

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'ENYE CONTROLS', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("${API.projectsImage + widget.projects.images}"), fit: BoxFit.fill),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.2)],
              stops: [0.0, 1],
              begin: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              //PROJECT TITLE
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: screenWidth * 1,
                  margin: EdgeInsets.only(top: screenHeight * 0.2),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Text(
                    "${widget.projects.title}",
                    style: TextStyle(fontSize: fontXXSize, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2,),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),

              //PROJECT DESCRIPTION 1
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: screenWidth * 1,
                  padding: EdgeInsets.all(17.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Text(
                    "${widget.projects.description1}",
                    style: TextStyle(
                      fontSize: fontExtraSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 2.0,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),


              //PROJECT DESCRIPTION 2
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: screenWidth * 1,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "${widget.projects.description2}",
                      style: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2.0,
                        letterSpacing: 1.2,
                        height: 1.5
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: screenWidth * 1,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0.1)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 60),
                    child:
                    widget.projects.projCatalogs == null ||  widget.projects.projCatalogs.isEmpty
                        ? Container()
                        : Row(
                      children: [
                        Lottie.network("https://assets3.lottiefiles.com/packages/lf20_Sz5T65.json", height: screenHeight * 0.05,),
                        _progress != null
                            ? const CircularProgressIndicator()
                            :TextButton(
                          child: Text("View Catalog",
                            style: TextStyle(
                                fontSize: fontExtraSize,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 2.0,
                                letterSpacing: 1.2,
                                decoration: TextDecoration.underline
                            ),),
                          onPressed: () => openFile(
                            url: "${API.fileCatalogsPdf + widget.projects.projCatalogs}",
                            filename: "${widget.projects.projCatalogs}",
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
      ),
    );
  }
}