import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';
import 'InteractiveImagepage.dart';

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

  List<SystemsTechSpecs> _sysTechSpecs = [];
  List<SystemsDetail> _sysDetails = [];
  List<Systems> _systems = [];

  bool _isLoading = true;
  bool _isLoadingClientInfo = true;

  @override
  void initState(){
    super.initState();
    _getSysTechSpecs();
    _getSysDetails();
    _getSystems();

    _checkSession();
  }

  bool? userSessionFuture;
  clientInfo? ClientInfo;

  Future<void> _checkSession() async {
    try {
      bool sessionStatus = await checkSession().getUserSessionStatus();
      setState(() {
        userSessionFuture = sessionStatus;
      });

      if (sessionStatus) {
        var clientDataInfo = await checkSession().getClientsData();

        // Update the UI once after completing the verification process
        setState(() {
          ClientInfo = clientDataInfo;
        });
      }
    } catch (error) {
      print('Error checking session: $error');
    } finally {
      // Ensure loading status is updated in any case
      setState(() {
        _isLoadingClientInfo = false;
      });
    }
  }

  // _checkSession(){
  //   checkSession().getUserSessionStatus().then((bool) {
  //     if (bool == true) {
  //       checkSession().getClientsData().then((value) {
  //         setState(() {
  //           ClientInfo = value;
  //         });
  //       });
  //       userSessionFuture = bool;
  //     } else {
  //       userSessionFuture = bool;
  //     }
  //     _isLoadingClientInfo = false;
  //   });
  // }


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

  _loginRequired(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;


        var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
        var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

        return AlertDialog(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Colors.deepOrange.shade300, size: fontNormalSize * 1.75,),
              SizedBox(width: 5),
              Text(
                "Required !",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontExtraSize,
                  color: Colors.deepOrange,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          content: Text(
            "This feature may require you to login first.",
            style: TextStyle(
              fontSize: fontNormalSize * 0.95,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                navBarController.jumpToTab(4);
              },
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontNormalSize * 0.95,
                  letterSpacing: 1.2,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade400),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            )
          ],
        );
      },
    );
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
      body: _isLoading || _isLoadingClientInfo
          ? Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _checkSession();
                _getSystems();
                _getSysTechSpecs();
                _getSysDetails();
              });
            },
            child: ListView(
                children: [

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

                  /* Container(
                        height: 400,
                          child: InteractiveImage()
                      ),*/
                  SizedBox(height: screenHeight * 0.035,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      _systems[0].description.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: fontNormalSize * 0.95,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                        wordSpacing: 0.3
                      ),
                    ),
                  ),

                  userSessionFuture == true && ClientInfo?.status == "Verified"
                  ? SizedBox.shrink()
                  : Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01,),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoadingClientInfo = true;  // Start loading
                          });

                          _checkSession().then((_) {
                            // Logic after session check and verification is complete
                            if (userSessionFuture == true && ClientInfo?.status == "Verified") {

                            } else if (ClientInfo?.status == "Unverified") {
                              showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
                            } else {
                              _loginRequired(context);
                            }
                          }).catchError((error) {
                            print("Error in session check: $error");
                          }).whenComplete(() {
                            // Stop loading in any case after completion
                            setState(() {
                              _isLoadingClientInfo = false;
                            });
                          });
                        },
                        // onPressed: () {
                        //   if(ClientInfo?.status == "Unverified") {
                        //     showPersistentSnackBar(context, screenWidth, screenHeight, fontSmallSize);
                        //   } else {
                        //     _loginRequired(context);
                        //   }
                        // },
                        child: Text(
                          "See more details...",
                          style: TextStyle(
                            fontSize: fontNormalSize * 0.95,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05,),
                    ],
                  ),

                  if (_sysDetails != null && _sysDetails!.isNotEmpty && userSessionFuture == true && ClientInfo?.status == "Verified")
                    Container(
                      child: Column(
                        children: _sysDetails!.map((SystemsDetail) =>
                            Column(
                              children: [
                                SizedBox(height: screenHeight * 0.045,),
                                if (SystemsDetail.title != null && SystemsDetail.title!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.08,
                                    ),
                                    child: Text(
                                      SystemsDetail.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Rowdies',
                                        fontSize: fontXSize,
                                        color: Colors.deepOrange,
                                        letterSpacing: 1.2
                                      ),
                                    ),
                                  ),

                                if (SystemsDetail.description != null && SystemsDetail.description!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.1,
                                      vertical: screenHeight * 0.03,
                                    ),
                                    child: Text(
                                      SystemsDetail.description,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        height: 1.5,
                                        fontSize: fontNormalSize * 0.95,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 0.5,
                                        wordSpacing: 0.3
                                      ),
                                    ),
                                  ),


                                /*if (SystemsDetail.image != null && SystemsDetail.image!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(imagePath: "${API.sysDetailsImg + SystemsDetail.image}"),
                                        ),
                                      );*/

                                      /*if (SystemsDetail.title == "SCHEMATIC DIAGRAM")
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => InteractiveImagePage(systemId: widget.systems.id),
                                          ),
                                        );*/

                                if (SystemsDetail.image != null && SystemsDetail.image!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      // Split the image string to get the first image
                                      List<String> images = SystemsDetail.image.split(',');

                                      // Assuming you want to use the first image for zoom
                                      String firstImage = images[0].trim();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(imagePath: "${API.sysDetailsImg + firstImage}"),
                                        ),
                                      );


                                      if (SystemsDetail.title == "SCHEMATIC DIAGRAM") {
                                        // Split the image string
                                        List<String> images1 = SystemsDetail.image.split(',');

                                        // Assuming you want to pass the second image
                                        String? secondImage = images1.length > 0 ? images1[0].trim() : null;

                                        if (secondImage != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InteractiveImagePage(
                                                systemId: widget.systems.id,
                                                imageUrl: "${API.sysDetailsImg + secondImage}",  // Pass the second image URL
                                              ),
                                            ),
                                          );
                                        }
                                      }

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.075,
                                        vertical: screenHeight * 0.035,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: SystemsDetail.image.split(',').map((image) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(horizontal: 5),  // Add some space between images
                                              height: screenHeight * 0.3,
                                              width: screenWidth * 0.9,  // Adjust width if you want the images to fit side by side
                                              child: CachedNetworkImage(
                                                imageUrl: "${API.sysDetailsImg  + image.trim()}",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) => Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: Colors.black,
                                                  child: Center(
                                                    child: Text(
                                                      "FAILED TO LOAD THE IMAGE",
                                                      style: TextStyle(
                                                          fontSize: fontSmallSize,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                height: fontExtraSize * 4,
                                                width: fontExtraSize * 4,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),

                                  ),
                              ],
                            )
                        ).toList(),
                      ),
                    ),

                  /*TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InteractiveImagePage(systemId: widget.systems.id),
                            ),
                          );
                        },
                        child: Text('Go to Interactive Image'),
                      ),*/

                  if (_sysTechSpecs != null && _sysTechSpecs!.isNotEmpty && userSessionFuture == true && ClientInfo?.status == "Verified")
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
                                  fontSize: fontNormalSize * 0.95,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              children: [
                                /*SystemsTechSpecs.product_pdf == null || SystemsTechSpecs.product_pdf.isEmpty
                                    ?*/ Container(
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
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 70.0),
                                            child: Text(
                                              "${SystemsTechSpecs.features}",
                                              style: TextStyle(height: 1.5, fontSize: fontNormalSize, color: Colors.white),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
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
                                                          color: Colors.greenAccent,
                                                          size: (screenHeight + screenWidth) / 40,
                                                        ),// Example icon
                                                        SizedBox(width: 8),  // Space between icon and text
                                                        Expanded(
                                                          child: Text(
                                                           "${product['prod_name']} ${product['type']}",
                                                            style: TextStyle(
                                                              height: 1.5,
                                                              fontSize: fontSmallSize,
                                                              fontFamily: 'Rowdies',
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w700,
                                                              letterSpacing: 1.2,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,  // Ensure the text truncates with an ellipsis
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                if (SystemsTechSpecs.product_pdf.length < 3)
                                                  SizedBox(height: screenHeight * 0.015),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                  /*  : Container(
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
                                                    Expanded(
                                                      child: Text(
                                                        product['prod_name'],
                                                        style: TextStyle(
                                                          height: 1.5,
                                                          fontSize: fontSmallSize,
                                                          fontFamily: 'Rowdies',
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 1.2,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,  // Ensure the text truncates with an ellipsis
                                                        maxLines: 1,
                                                        textAlign: TextAlign.left,
                                                      ),
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
                                ),*/
                              ],
                            )).toList(),
                          ),
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
            onPressed: () {
              setState(() {
                _isLoadingClientInfo = true;  // Start loading
              });

              _checkSession().then((_) {
                // Logic after session check and verification is complete
                if (userSessionFuture == true && ClientInfo?.status == "Verified") {
                  openFile(
                    url: "${API.fileCatalogsPdf + widget.systems.catalogs_pdf}",
                    filename: "${widget.systems.catalogs_pdf}",
                  );
                } else if (ClientInfo?.status == "Unverified") {
                  showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
                } else {
                  _loginRequired(context);
                }
              }).catchError((error) {
                print("Error in session check: $error");
              }).whenComplete(() {
                // Stop loading in any case after completion
                setState(() {
                  _isLoadingClientInfo = false;
                });
              });
            },
            // onPressed: () {
            //   if (userSessionFuture == true && ClientInfo?.status == "Verified") {
            //     openFile(
            //       url: "${API.fileCatalogsPdf + widget.systems.catalogs_pdf}",
            //       filename: "${widget.systems.catalogs_pdf}",
            //     );
            //   } else {
            //     if(ClientInfo?.status == "Unverified") {
            //       showPersistentSnackBar(context, screenWidth, screenHeight, fontSmallSize);
            //     } else {
            //       _loginRequired(context);
            //     }
            //   }
            // },
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