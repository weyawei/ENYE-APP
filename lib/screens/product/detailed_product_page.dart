import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:photo_view/photo_view.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class detailedProductPage extends StatefulWidget {

  static const String routeName = '/product';

  Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: detailedProductPage.routeName),
        builder: (_) => detailedProductPage(products: products)
    );
  }

  final product products;
  const detailedProductPage({required this.products});

  @override
  State<detailedProductPage> createState() => _detailedProductPageState();
}

class _detailedProductPageState extends State<detailedProductPage> with TickerProviderStateMixin {

  int _selectedIndex = -1; // Index of the selected item
  int _selectedIndex2 = -1; // Index of the selected item
  //THIS IS FOR PDF VIEWING
  double? _progress;
  late String _mainName = '';

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

  bool _isLoadingProd = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();


  //LIST OF PRODUCT DETAIL
  List<detailedProduct> _productDetail = [];
  List<productCategory> _prodCategory = [];
  List<product> _products = [];
  List<product> _productsInfo = [];


  @override
  void initState() {
    _getProductDetails();
    _getProdCategory();
    _getProducts();
    _getProductsInfo();
    _getProductsInfos();
    _getProductsSizes();

    getMainName();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  _getProductDetails(){
    productService.getProductDetails(widget.products.id).then((detailedProduct){
      setState(() {
        _productDetail = detailedProduct;
      });

      print("Length ${detailedProduct.length}");
    });
  }

  _getProdCategory(){
    productService.getProdCategory().then((productCategory){
      setState(() {
        _prodCategory = productCategory.where((element) => element.status == "Active").toList();
      });

      print("Length ${productCategory.length}");
    });
  }

  _getProducts(){
    productService.getProducts().then((product){
      setState(() {
        _products = product.where((element) => element.id != widget.products.id).toList();
      });

      print("Length ${product.length}");
    });
  }

  _getProductsInfo(){
    productService.getProducts().then((product){
      setState(() {
        _productsInfo = product.where((element) => element.id == widget.products.id).toList();
      });
      _isLoadingProd = false;
      print("Length ${product.length}");
    });
  }

  List<thumb> _productsInfos = [];
  _getProductsInfos(){
    productService.getProductThumb().then((productdetails){
      setState(() {
        _productsInfos = productdetails.where((element) => element.product_id == widget.products.id).toList();
      });

      print("Length ${_productsInfos.length}");
    });
  }

  List<size> _productsSizes = [];
  _getProductsSizes(){
    productService.getProductSize().then((productsize){
      setState(() {
        _productsSizes = productsize.where((element) => element.product_id == widget.products.id).toList();
      });

      print("Length ${_productsInfos.length}");
    });
  }

  Future<void> _refresh() async {
    // Simulate fetching data from the database
    await Future.delayed(Duration(seconds: 2));



    // Update UI with new data
    setState(() {
      _getProductDetails();
      _getProdCategory();
      _getProducts();
    });
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  bool _isThumbnailClicked = false;

  String getMainImageUrl() {
    // Determine whether to show main image or thumbnail
    return _productsInfo[0].image == "main.jpg"
        ? "${API.prodImg + _productsInfo[0].image}"
        : "${API.prodThumb + _productsInfo[0].image}";
  }

  String getImageUrl() {
    // Determine whether to show main image or thumbnail
    return !_isThumbnailClicked
        ? "${API.prodImg + _productsInfo[0].image}"
        : "${API.prodThumb + _productsInfo[0].image}";
  }
  void onThumbnailClick() {
    setState(() {
      _isThumbnailClicked = true;
    });
  }

  String getMainName(){
    return _mainName = widget.products.name;
  }


 /* void updateMainImage(int index) {
    setState(() {
      _productsInfo[0].image = _productsInfos[index].thumbnails;
    });
  }*/



  Offset _tapPosition = Offset.zero;
  bool _isPressed = false;
  GlobalKey _imageKey = GlobalKey();
  Size _imageSize = Size.zero;

  void _onPanStart(DragStartDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _updatePosition(Offset globalPosition) {
    final RenderBox renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(globalPosition);
    setState(() {
      _tapPosition = localPosition;
      _isPressed = true;
      _imageSize = renderBox.size;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    //  appBar: CustomAppBar(title: 'PRODUCTS', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: _isLoadingProd
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _getProductDetails();
            _getProdCategory();
            _getProducts();
            _getProductsInfo();
            _getProductsInfos();
          });
        },
        child: ListView(
          children:[
            Container(
              padding: EdgeInsets.all(10), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.01), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                _productsInfo[0].name,
                style: TextStyle(
                  fontFamily: "Rowdies",
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                maxLines: 2, // Limits the text to 2 lines
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageZoomScreen(imagepath: getImageUrl()),
                        ),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                       /* Image.network(
                          getImageUrl(),
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 1.5,
                          height: MediaQuery.of(context).size.width * 1.0 * 1.1,
                        ),*/
                        GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child:Image.network(
                            key: _imageKey,
                            getImageUrl(),
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ), // Your large image
                        ),
                        if (_isPressed)
                          Positioned(
                            left: _tapPosition.dx - 20,
                            top: _tapPosition.dy - 20,
                            child: ClipOval(
                              child: Container(
                                width: 200,
                                height: 200,
                                child: OverflowBox(
                                  maxWidth: double.infinity,
                                  maxHeight: double.infinity,
                                  child: Transform.scale(
                                    scale: 2.0, // Magnification factor
                                    child: Container(
                                      width: _imageSize.width,
                                      height: _imageSize.height,
                                      child: Image.network(
                                        getImageUrl(),
                                       // fit: BoxFit.fill,
                                        width: MediaQuery.of(context).size.width * 1.5,
                                        height: MediaQuery.of(context).size.width * 1.0 * 1.1,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(
                                          -1 + 2 * _tapPosition.dx / MediaQuery.of(context).size.width,
                                          -1 + 2 * _tapPosition.dy / MediaQuery.of(context).size.height,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.01), // Background color
                            borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
                          ),
                          child: Text(
                            _mainName,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                            maxLines: 2, // Limits the text to 2 lines
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8), // Adjust the vertical spacing between text and stars
                /*Row(
                  children: List.generate(
                    5, // Number of stars to display (you can replace this with a variable based on rating)
                        (index) => Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20, // Adjust size of the star icon as needed
                    ),
                  ),
                ),*/
              ],
            ),
            SizedBox(height: 5), // Adjust the vertical spacing as needed

            Container(
              margin:  EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding as needed
              decoration: BoxDecoration(
              //  color: Colors.black.withOpacity(0.05), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                'Types',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                maxLines: 2, // Limits the text to 2 lines
              ),
            ),

            SizedBox(height: 5), // Adjust the vertical spacing as needed

            Container(
              height: MediaQuery.of(context).size.width * 0.35, // Adjust height as needed to accommodate thumbnails and names
              margin:  EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _productsInfos.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedIndex == index; // Check if this item is selected
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _productsInfo[0].image = _productsInfos[index]
                            .thumbnails; // Update main image
                        _mainName = _productsInfos[index].name;
                        onThumbnailClick();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent, // Change background color if selected
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.black, // Change border color if selected
                                width: 1.0, // Adjust border width as needed
                              ),
                            ),
                            child: Image.network(
                              "${API.prodThumb + _productsInfos[index].thumbnails}",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.2, // Adjust image width as needed
                              height: MediaQuery.of(context).size.width * 0.2, // Adjust image height as needed
                            ),
                          ),
                          SizedBox(height: 4), // Adjust vertical spacing between thumbnail and name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              _productsInfos[index].name,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.030, // Adjust font size as needed
                                color: Colors.black, // Adjust text color as needed
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2, // Limit name to 2 lines
                              overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              margin:  EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding as needed
              decoration: BoxDecoration(
               // color: Colors.black.withOpacity(0.05), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                'Sizes',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                maxLines: 2, // Limits the text to 2 lines
              ),
            ),

            SizedBox(height: 5), // Adjust the vertical spacing as needed

          Container(
            height: MediaQuery.of(context).size.width * 0.15, // Adjust height as needed to accommodate thumbnails and names
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _productsSizes.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex2 == index; // Check if this item is selected
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex2 = index; // Update the selected index
                      _productsInfo[0].image = _productsInfo[0].image;
                     // _productsInfo[0].image = _productsInfos[index].thumbnails; // Update main image
                    //  _productsInfo[0].name = _productsInfos[index].name;
                      onThumbnailClick();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent, // Change background color if selected
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.black, // Change border color if selected
                              width: 1.0, // Adjust border width as needed
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                            child: Text(
                              _productsSizes[index].sizes, // Display size text
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.039, // Adjust font size as needed
                                color: Colors.black, // Adjust text color as needed
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 4), // Adjust vertical spacing between icon and name
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: Text(
                           //productsSizes[index].sizes,
                            "",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.030, // Adjust font size as needed
                              color: Colors.black, // Adjust text color as needed
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2, // Limit name to 2 lines
                            overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),



          Container(
              margin:  EdgeInsets.symmetric(horizontal: 15.0), // Adjust padding as needed
              decoration: BoxDecoration(
              //  color: Colors.black.withOpacity(0.05), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                'SPECIFICATIONS',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
                maxLines: 2, // Limits the text to 2 lines
              ),
            ),
        SizedBox(height: 10,),
            Container(
              margin:  EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding as needed
              decoration: BoxDecoration(
               // color: Colors.black.withOpacity(0.05), // Background color
                borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
              ),
              child: Text(
                _productsInfo[0].prod_desc,
               style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              //  overflow: TextOverflow.ellipsis, // Handles overflow by showing ellipsis
              //  maxLines: 2, // Limits the text to 2 lines
              ),
            ),

            SizedBox(height: 10,),

            if(_productDetail != null || _productDetail.isNotEmpty)
              MasonryGridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: _productDetail.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 15,
                    margin: EdgeInsets.all(4),
                    child: Column(
                      children: <Widget>[
                    ListTile(
                    title: Container(
                      padding: EdgeInsets.all(10), // Adjust padding as needed
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2), // Background color
                        borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
                      ),
                      child: Text(
                        _productDetail[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.040, // Adjust the font size as needed
                          color: Colors.black, // Adjust the text color
                          shadows: [
                            Shadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                          // You can add more styles like letterSpacing, fontStyle, etc. here
                        ),
                      ),
                    )

                    ),

                      if (_productDetail[index].description != null && _productDetail[index].description.isNotEmpty)
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  _productDetail[index].isExpanded
                                      ? _productDetail[index].description // Show full description if expanded
                                      : _productDetail[index].description.substring(0, 100) + '...', // Show truncated description
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.029,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // Adjust spacing between description and "See More" button
                              if (_productDetail[index].description.length > 100) // Example condition for showing "See More"
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Toggle the expanded state
                                      _productDetail[index].isExpanded = !_productDetail[index].isExpanded;
                                    });
                                  },
                                  child: Text(
                                    _productDetail[index].isExpanded ? "See Less" : "See More",
                                    style: TextStyle(
                                      color: Colors.blue, // Example color for the text button
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),


                      if (_productDetail[index].image != null && _productDetail[index].image.isNotEmpty)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ImageZoomScreen(imagepath: "${API.prodDetailsImg + _productDetail[index].image}",),
                                  ),
                                );
                              },

                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Image.network("${API.prodDetailsImg + _productDetail[index].image}",),
                              ),

                            ),
                          ),
                        SizedBox(height: 30,),
                      ],
                  ),
                  );
                }),

            if (_productsInfo[0].id == _productDetail[0].product_id && _productsInfo[0].catalogs_pdf.isNotEmpty)
              Center(
                child: Card(
                  elevation: 15,
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                    ListTile(
                     title: Container(
                        padding: EdgeInsets.all(10), // Adjust padding as needed
                        decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.2), // Background color
                           borderRadius: BorderRadius.circular(5), // Optional: Adds rounded corners
                        ),

                        child: Text(
                          "PRODUCT PDF",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.040, // Adjust the font size as needed
                            color: Colors.black, // Adjust the text color
                            shadows: [
                              Shadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                            // You can add more styles like letterSpacing, fontStyle, etc. here
                          ),
                        ),
                      ),
                    ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Column(
                          children: _productsInfo[0].catalogs_pdf.split(',').map((filename) {
                            String trimmedFilename = filename.trim();
                            return TextButton(
                              onPressed: () {
                                if (trimmedFilename.isEmpty) {
                                  _errorSnackbar(context, "PDF File doesn't exist.");
                                } else {
                                  openFile(
                                    url: "${API.prodPdf + trimmedFilename}",
                                    filename: trimmedFilename,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf), // Add icon
                                  SizedBox(width: 8), // Add some space between icon and filename
                                  Text(
                                    trimmedFilename,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.031,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 50), // Add some space between icon and filename
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text widget added above the CarouselSlider
                  Text(
                    "RELATED PRODUCTS",
                    style: TextStyle(
                      fontFamily: 'Rowdies',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.050, // Adjust the font size as needed
                      color: Colors.black, // Adjust the text color
                      shadows: [
                        Shadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                      // You can add more styles like letterSpacing, fontStyle, etc. here
                    ),
                  ),
                  SizedBox(height: 10), // Adding some space between text and carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      viewportFraction: 0.5,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: _products.where((product) => product.category_id == _productsInfo[0].category_id).map((product) =>
                        InkWell(
                          onTap: (){
                            setState(() {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProductPage.routeName),
                                screen: detailedProductPage( products: product,),
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
                                  Image.network(
                                    //"${API.prodCategIcon + widget.productcategory.icon}",
                                    "${API.prodImg + product.image}",
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.width * 0.3 * 1.3,
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
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.15,
        child: FloatingActionButton(
          onPressed: () =>
            widget.products.catalogs_pdf.isEmpty || widget.products.catalogs_pdf == null || widget.products.catalogs_pdf == ''
            ? _errorSnackbar(context, "PDF File don't exist.")
            : openFile(
              url: "${API.prodPdf + widget.products.catalogs_pdf}",
              filename: "${widget.products.catalogs_pdf}",
            ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _progress != null
                    ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 35,
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
                              top: 10,
                              child: Text(
                                "${_progress?.toInt().toString()} %",
                                textAlign:
                                TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.03,
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
                Text("PDF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.025),),
              ]
          )
        ),
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
                  imageProvider: NetworkImage(imagepath),
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
