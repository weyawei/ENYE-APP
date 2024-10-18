import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ProductItemScreen extends StatefulWidget {
  static const String routeName = '/ProductItemScreen';
  final product products;
  const ProductItemScreen({required this.products});

  @override
  State<ProductItemScreen> createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  //LIST OF PRODUCT DETAIL
  List<detailedProduct> _productDetail = [];
  List<product> _relatedProducts = [];
  ValueNotifier<double> sheetSizeNotifier = ValueNotifier(0.28);

  @override
  void initState() {
    _getProductDetails();
    _getAllProducts();
    _checkSession();
    _getProdCategory(widget.products.category_id);
  }

  bool? userSessionFuture;
  clientInfo? ClientInfo;
  bool _isLoadingClientInfo = true;

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

  _loginRequired(){
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
              fontSize: fontNormalSize,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
                  fontSize: fontNormalSize,
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

  bool _isLoadingProdDetails = true;
  _getProductDetails(){
    productService.getProductDetails(widget.products.id).then((detailedProduct){
      setState(() {
        _productDetail = detailedProduct;
      });
      _isLoadingProdDetails = false;
      print("Length ${detailedProduct.length}");
    });
  }

  bool _isLoadingRelatedProducts = true;
  _getAllProducts(){
    productService.getProducts().then((product){
      setState(() {
        _relatedProducts = product.where((element) => element.id != widget.products.id).toList();
      });
      _isLoadingRelatedProducts = false;
      print("Length ${product.length}");
    });
  }

  List<productCategory> _prodCategory = [];
  bool _isLoadingCategory = true;
  _getProdCategory(String category_id){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory.where((element) => element.id == category_id).toList();;
      });
      _isLoadingCategory = false;
      print("Length ${productCategory.length}");
    });
  }

  double? _progress;
  bool _isLoadingPdf = false;
  Future openFile ({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);

    if (file == null) {
      setState(() {
        _isLoadingPdf = false;  // Stop loading if file download fails
      });
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
          body: _isLoadingProdDetails || _isLoadingRelatedProducts || _isLoadingCategory
          ? Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              Positioned(
                  top: -40, // Ensure correct positioning
                  left: 0,
                  right: 0,
                  child: Container(
                    height:widget.products.model_3d.isEmpty ? screenHeight * 0.55 : screenHeight * 0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage("${API.prodImg + widget.products.image}"), fit: BoxFit.cover, scale: 2.5),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.black.withOpacity(0.6),),
                    ),
                  ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImage(imagePath: "${API.prodImg + widget.products.image}",),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  width: double.infinity,
                  child: widget.products.model_3d.isNotEmpty
                    ? Container(height: screenHeight)
                    : Image.network(
                      "${API.prodImg + widget.products.image}",
                    height: screenHeight / 3,
                  ),
                ),
              ),
              if (widget.products.model_3d.isNotEmpty)
                Positioned(
                  top: -25, // Ensure correct positioning
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder<double>(
                    valueListenable: sheetSizeNotifier,
                    builder: (context, sheetSize, child) {
                      double modelViewerHeight = (1 - sheetSize) * screenHeight;
                      return Container(
                        height: modelViewerHeight,
                        child: ModelViewer(
                          src: "${API.prodImg + widget.products.model_3d}",
                          // src: "assets/imges/MODEL FOR TUFF.glb",
                          autoRotate: true,
                        ),
                      );
                    },
                  ),
                ),
              buttonArrow(context),
              scroll(
                widget.products.subCat2_name1 != ''
                ? widget.products.subCat2_name1
                : widget.products.subCat1_name1 != ''
                  ? widget.products.subCat1_name1
                  : widget.products.subCat_name1 != ''
                    ? widget.products.subCat_name1
                    : _prodCategory[0].name,
                _prodCategory[0].icon
              ),
            ],
          ),
          // Stack(
          //   children: [
          //     Container(
          //       color: Colors.deepOrange.shade200,
          //       width: double.infinity,
          //       child: widget.products.model_3d.isNotEmpty
          //         ? Container(height: screenHeight,)
          //         : Image.network(
          //             "${API.prodImg + widget.products.image}",
          //             fit: BoxFit.fill,
          //           ),
          //     ),
          //     if(widget.products.model_3d.isNotEmpty)
          //       SizedBox(
          //         height: screenHeight * 0.35,
          //         child: ModelViewer(
          //           src: "${API.prodImg + widget.products.model_3d}",
          //           autoRotate: true,
          //         ),
          //       ),
          //     buttonArrow(context),
          //     scroll(_prodCategory[0]),
          //   ],
          // ),
        ));
  }

  buttonArrow(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005, horizontal: screenWidth * 0.01),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: fontNormalSize * 3,
          width: fontNormalSize * 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              alignment: Alignment.center,
              height: fontNormalSize * 3,
              width: fontNormalSize * 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: fontNormalSize * 1.25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget scroll(String category_name, String category_icon) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        sheetSizeNotifier.value = notification.extent;
        print('Sheet Size: ${sheetSizeNotifier.value}');
        return true;
      },
      child: DraggableScrollableSheet(
          initialChildSize: widget.products.model_3d.isEmpty ? 0.52 : 0.28,
          maxChildSize: 1.0,
          minChildSize: widget.products.model_3d.isEmpty ? 0.52 : 0.28,
          builder: (context, scrollController) {
            double screenHeight = MediaQuery.of(context).size.height;
            double screenWidth = MediaQuery.of(context).size.width;

            var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
            var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
            var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);
            var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
            var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5,
                            width: 35,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.products.name,
                      style: TextStyle(
                        fontSize: fontXXSize,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3E5C)
                      ),
                    ),
                    widget.products.type == ""
                    ? SizedBox.shrink()
                    : Text(
                      widget.products.type,
                      style: TextStyle(
                          fontSize: fontExtraSize,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                       CachedNetworkImage(
                              imageUrl: "${API.prodCategIcon + category_icon}",
                         height: fontXSize * 3, // Adjust as needed
                         width: fontXSize * 3,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                            fit: BoxFit.cover,
                          ),

                        SizedBox(
                          width: fontNormalSize,
                        ),
                        Expanded(
                          child: Text(
                            category_name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: fontExtraSize,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 15,
                        // ),
                        // Text(
                        //   "273 Likes",
                        // ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        // const CircleAvatar(
                        //   radius: 25,
                        //   // backgroundColor: primary,
                        //   child: Icon(
                        //     IconlyLight.heart,
                        //     color: Colors.white,
                        //   ),
                        // ),

                      ],
                    ),

                    if(widget.products.prod_desc.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(
                            height: 4,
                          ),
                        ),

                        widget.products.model == ""
                        ? SizedBox.shrink()
                        : Text(
                          widget.products.model.toUpperCase(),
                          style: TextStyle(
                            fontSize: fontXSize,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2E3E5C)
                          ),
                          // style: Theme.of(context).textTheme.headline1,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.products.prod_desc,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: fontNormalSize,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Text(
                        //   widget.products.prod_desc,
                        //   style: GoogleFonts.poppins(
                        //     textStyle: TextStyle(
                        //       letterSpacing: 1.2,
                        //       fontSize: fontNormalSize,
                        //       color: Colors.black87,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    if(_productDetail != null || _productDetail.isNotEmpty)
                      ..._productDetail.map((detail) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Divider(
                                height: 4,
                              ),
                            ),
                            Text(
                              detail.title.toUpperCase(),
                              style: TextStyle(
                                fontSize: fontXSize,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3E5C)
                              ),
                              // style: Theme.of(context).textTheme.headline1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            detail.description.isNotEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: detail.isExpanded
                                          ? detail.description // Show full description if expanded
                                          : detail.description.length > 500 // Check length before calling substring
                                          ? detail.description.substring(0, 500) + '...' // Truncate if not expanded
                                          : detail.description, // Show full description if less than 100 characters
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: fontNormalSize,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (detail.description.length > 500) // Only show "See More/Less" if text exceeds 100 chars
                                      TextSpan(
                                        text: detail.isExpanded ? " See Less" : " See More",
                                        style: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: fontNormalSize * 0.8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              // Toggle the expanded state
                                              detail.isExpanded = !detail.isExpanded;
                                            });
                                          },
                                      ),
                                  ],
                                ),
                              ),

                              // Text(
                              //   detail.description ?? "",
                              //   textAlign: TextAlign.justify,
                              //   style: TextStyle(
                              //       letterSpacing: 0.8
                              //   ),
                              // ),
                            )
                            : SizedBox.shrink(),

                            detail.image.isNotEmpty
                            ? Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImage(imagePath: "${API.prodDetailsImg + detail.image}",),
                                    ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: "${API.prodDetailsImg + detail.image}",
                                      placeholder: (context, url) =>
                                          Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                          ],
                        );
                      }).toList(),

                    if(widget.products.catalogs_pdf.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(
                              height: 4,
                            ),
                          ),
                          Text(
                            "PRODUCT PDF",
                            style: TextStyle(
                                fontSize: fontXSize,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3E5C)
                            ),
                            // style: Theme.of(context).textTheme.headline1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ...widget.products.catalogs_pdf.split(',').map((pdf) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isLoadingClientInfo = true;  // Start loading
                                  });

                                  _checkSession().then((_) {
                                    // Logic after session check and verification is complete
                                    if (userSessionFuture == true && ClientInfo?.status == "Verified") {
                                      String trimmedFilename = pdf.trim();
                                      if (trimmedFilename.isEmpty) {
                                        custSnackbar(
                                            context,
                                            "PDF File doesn't exist.",
                                            Colors.redAccent,
                                            Icons.close,
                                            Colors.white
                                        );
                                      } else {
                                        setState(() {
                                          _isLoadingPdf = true;  // Start PDF loading
                                        });
                                        openFile(
                                          url: "${API.prodPdf + trimmedFilename}",
                                          filename: trimmedFilename,
                                        ).whenComplete(() {
                                          setState(() {
                                            _isLoadingPdf = false;  // Stop PDF loading after file is opened
                                          });
                                        });
                                      }
                                    } else if (ClientInfo?.status == "Unverified") {
                                      showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
                                    } else {
                                      _loginRequired();
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
                                // onTap: () {
                                //   _checkSession();
                                //   if(userSessionFuture == true && ClientInfo?.status == "Verified"){
                                //     String trimmedFilename = pdf.trim();
                                //     if (trimmedFilename.isEmpty) {
                                //       custSnackbar(
                                //           context,
                                //           "PDF File doesn't exist.",
                                //           Colors.redAccent,
                                //           Icons.close,
                                //           Colors.white
                                //       );
                                //     } else {
                                //       openFile(
                                //         url: "${API.prodPdf + trimmedFilename}",
                                //         filename: trimmedFilename,
                                //       );
                                //     }
                                //   } else {
                                //     if(ClientInfo?.status == "Unverified") {
                                //       showPersistentSnackBar(context, screenWidth, screenHeight, fontSmallSize);
                                //     } else {
                                //       _loginRequired();
                                //     }
                                //   }
                                // },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      // backgroundColor: mainText,
                                      radius: fontExtraSize,
                                      child: Icon(
                                        Icons.picture_as_pdf,
                                        size: fontNormalSize * 1.25,
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: _isLoadingPdf
                                      ? Row(
                                          children: [
                                            Container(
                                              height: fontNormalSize,
                                              width: fontNormalSize,
                                              child: CircularProgressIndicator()
                                            ),  // Show loading indicator
                                            SizedBox(width: 10),
                                            Text(
                                              "Loading PDF...",
                                              style: TextStyle(
                                                fontSize: fontNormalSize,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          pdf,
                                          style: TextStyle(
                                            fontSize: fontNormalSize,
                                            letterSpacing: 1.2,
                                            fontStyle: FontStyle.italic
                                          ),
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),

                    if(_relatedProducts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(
                              height: 4,
                            ),
                          ),
                          Text(
                            "RELATED PRODUCTS",
                            style: TextStyle(
                                fontSize: fontXSize,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3E5C)
                            ),
                            // style: Theme.of(context).textTheme.headline1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              viewportFraction: 0.5,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                            ),
                            items: _relatedProducts.where((product) => product.category_id == widget.products.category_id).map((product) =>
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                      //   context,
                                      //   settings: RouteSettings(name: detailedProductPage.routeName),
                                      //   screen: detailedProductPage( products: product,),
                                      //   withNavBar: true,
                                      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      // );

                                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                        context,
                                        settings: RouteSettings(name: detailedProductPage.routeName),
                                        // screen: detailedProductPage(products: widget.products[index],),
                                        screen: ProductItemScreen(products: product),
                                        withNavBar: true,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: Stack(
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            //"${API.prodCategIcon + widget.productcategory.icon}",
                                           imageUrl: "${API.prodImg + product.image}",
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            height: MediaQuery.of(context).size.width * 0.3 * 1.3,

                                            placeholder: (context, url) =>
                                                Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) =>
                                                Center(child: Icon(Icons.error)),
                                          ),
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
                                              EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                              child: Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,

                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ).toList(),
                          ),
                        ],
                      ),

                    SizedBox(height: screenHeight * 0.05,)
                  ],
                ),
              ),
            );
          }),
    );
  }

  // scroll(productCategory prodCategory) {
  //   return DraggableScrollableSheet(
  //       initialChildSize: 0.6,
  //       maxChildSize: 1.0,
  //       minChildSize: 0.6,
  //       builder: (context, scrollController) {
  //         double screenHeight = MediaQuery.of(context).size.height;
  //         double screenWidth = MediaQuery.of(context).size.width;
  //
  //         var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
  //         var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
  //         var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);
  //         var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
  //
  //         return Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           clipBehavior: Clip.hardEdge,
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //                 topLeft: const Radius.circular(20),
  //                 topRight: const Radius.circular(20)),
  //           ),
  //           child: SingleChildScrollView(
  //             controller: scrollController,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10, bottom: 25),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Container(
  //                         height: 5,
  //                         width: 35,
  //                         color: Colors.black12,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Text(
  //                   widget.products.name,
  //                   style: TextStyle(
  //                     fontSize: fontXXSize,
  //                     letterSpacing: 0.8,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF2E3E5C)
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 const SizedBox(
  //                   height: 15,
  //                 ),
  //                 Row(
  //                   children: [
  //                     Image(
  //                       image: NetworkImage("${API.prodCategIcon + prodCategory.icon}"),
  //                       height: fontXSize * 3, // Adjust as needed
  //                       width: fontXSize * 3,
  //                     ),
  //                     const SizedBox(
  //                       width: 10,
  //                     ),
  //                     Text(
  //                       prodCategory.name,
  //                       style: TextStyle(
  //                         fontSize: fontExtraSize
  //                       ),
  //                     ),
  //                     const Spacer(),
  //
  //                     Text(
  //                       "273 Likes",
  //                     ),
  //                     const SizedBox(
  //                       width: 10,
  //                     ),
  //                     const CircleAvatar(
  //                       radius: 25,
  //                       // backgroundColor: primary,
  //                       child: Icon(
  //                         IconlyLight.heart,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //
  //                   ],
  //                 ),
  //
  //                 if(widget.products.prod_desc.isNotEmpty)
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Padding(
  //                       padding: EdgeInsets.symmetric(vertical: 15),
  //                       child: Divider(
  //                         height: 4,
  //                       ),
  //                     ),
  //                     Text(
  //                       "Specification",
  //                       style: TextStyle(
  //                           fontSize: fontXSize,
  //                           letterSpacing: 0.8,
  //                           fontWeight: FontWeight.bold,
  //                           color: Color(0xFF2E3E5C)
  //                       ),
  //                       // style: Theme.of(context).textTheme.headline1,
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       widget.products.prod_desc,
  //                       textAlign: TextAlign.justify,
  //                       style: TextStyle(
  //                         letterSpacing: 0.8
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 if(_productDetail != null || _productDetail.isNotEmpty)
  //                   ..._productDetail.map((detail) {
  //                     return Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Padding(
  //                           padding: EdgeInsets.symmetric(vertical: 15),
  //                           child: Divider(
  //                             height: 4,
  //                           ),
  //                         ),
  //                         Text(
  //                           detail.title.toUpperCase(),
  //                           style: TextStyle(
  //                             fontSize: fontXSize,
  //                             letterSpacing: 1.2,
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF2E3E5C)
  //                           ),
  //                           // style: Theme.of(context).textTheme.headline1,
  //                         ),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         detail.description.isNotEmpty
  //                         ? Padding(
  //                           padding: const EdgeInsets.only(left: 15),
  //                           child: RichText(
  //                             softWrap: true,
  //                             text: TextSpan(
  //                               children: <TextSpan> [
  //                                 TextSpan(
  //                                   text: detail.isExpanded
  //                                   ? detail.description // Show full description if expanded
  //                                   : detail.description.substring(0, 100) + '...',
  //                                   style: GoogleFonts.poppins(
  //                                     textStyle: TextStyle(
  //                                         letterSpacing: 1.2,
  //                                         fontSize: fontNormalSize,
  //                                         color: Colors.black87
  //                                     ),
  //                                   )
  //                                 ),
  //
  //                                 if (detail.description.length > 100)
  //                                 TextSpan(
  //                                   text: detail.isExpanded ? " See Less" : " See More",
  //                                   style: TextStyle(
  //                                     letterSpacing: 1.2,
  //                                     fontSize: fontExtraSize,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.blueAccent
  //                                   ),
  //                                   recognizer: TapGestureRecognizer()
  //                                     ..onTap = () {
  //                                       setState(() {
  //                                         // Toggle the expanded state
  //                                         detail.isExpanded = !detail.isExpanded;
  //                                       });
  //                                     },
  //                                 ),
  //                               ]
  //                             ),
  //                           ),
  //                           // Text(
  //                           //   detail.description ?? "",
  //                           //   textAlign: TextAlign.justify,
  //                           //   style: TextStyle(
  //                           //       letterSpacing: 0.8
  //                           //   ),
  //                           // ),
  //                         )
  //                         : SizedBox.shrink(),
  //
  //                         detail.image.isNotEmpty
  //                         ? Center(
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (_) => FullScreenImage(imagePath: "${API.prodDetailsImg + detail.image}",),
  //                                 ),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                                 child: Image.network(
  //                                   "${API.prodDetailsImg + detail.image}",
  //                                 ),
  //                               ),
  //                             ),
  //                           )
  //                         : SizedBox.shrink(),
  //                       ],
  //                     );
  //                   }).toList(),
  //
  //                 if(widget.products.catalogs_pdf.isNotEmpty)
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 15),
  //                         child: Divider(
  //                           height: 4,
  //                         ),
  //                       ),
  //                       Text(
  //                         "PRODUCTS PDF FILES",
  //                         style: TextStyle(
  //                             fontSize: fontXSize,
  //                             letterSpacing: 0.8,
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF2E3E5C)
  //                         ),
  //                         // style: Theme.of(context).textTheme.headline1,
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       ...widget.products.catalogs_pdf.split(',').map((pdf) {
  //                         return Padding(
  //                           padding: const EdgeInsets.only(left: 20),
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               String trimmedFilename = pdf.trim();
  //                               if (trimmedFilename.isEmpty) {
  //                                 custSnackbar(
  //                                   context,
  //                                   "PDF File doesn't exist.",
  //                                   Colors.redAccent,
  //                                   Icons.close,
  //                                   Colors.white
  //                                 );
  //                               } else {
  //                                 openFile(
  //                                   url: "${API.prodPdf + trimmedFilename}",
  //                                   filename: trimmedFilename,
  //                                 );
  //                               }
  //                             },
  //                             child: Row(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 CircleAvatar(
  //                                   // backgroundColor: mainText,
  //                                   radius: fontExtraSize,
  //                                   child: Icon(
  //                                     Icons.picture_as_pdf,
  //                                     size: fontNormalSize * 1.25,
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 20,),
  //                                 Text( pdf,
  //                                   style: TextStyle(
  //                                     letterSpacing: 1.2,
  //                                     fontStyle: FontStyle.italic
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       }).toList(),
  //                     ],
  //                   ),
  //
  //                 SizedBox(height: screenHeight * 0.05,)
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  ingredients(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Color(0xFFE3FFF8),
            child: Icon(
              Icons.done,
              size: 15,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "4 Eggs",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }

  steps(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            // backgroundColor: mainText,
            radius: 12,
            child: Text("${index + 1}"),
          ),
          Column(
            children: [
              SizedBox(
                width: 270,
                child: Text(
                  "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your",
                  maxLines: 3,
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .bodyText2!
                  //     .copyWith(color: mainText),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/imges/Rectangle 219.png",
                height: 155,
                width: 270,
              )
            ],
          )
        ],
      ),
    );
  }
}