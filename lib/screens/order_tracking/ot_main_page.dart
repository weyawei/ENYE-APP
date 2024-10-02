import 'package:enye_app/screens/order_tracking/order_timeline_page.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final searchController = TextEditingController();
  bool not_on_favorite = false;
  bool _isLoadingPO = false;
  bool _isLoadingSavedPO = true;

  late List<ClientPO> _searchClientPO;
  _getClientPo(String tracking_no){
    ClientPOServices.getClientPO(tracking_no).then((po){
      setState(() {
        _searchClientPO = po;
      });
      if(_searchClientPO.isEmpty){
        custSnackbar(
          context,
          "Sorry, the tracking number ${tracking_no.toUpperCase()} is not in the list.",
          Colors.blueAccent,
          Icons.info,
          Colors.white
        );
      }
      _isLoadingPO = false;
    });
  }

  late List<ClientPO> _savedClientPO;
  late List<ClientPO> _filteredSaveClientPO;
  _getSavedClientPo(String email){
    ClientPOServices.getSavedClientPO(email).then((po){
      setState(() {
        _savedClientPO = po;
        _filteredSaveClientPO = po;
      });
      _isLoadingSavedPO = false;
    });
  }

  bool? userSessionFuture;
  clientInfo? ClientInfo;
  _checkSession() {
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
            // Call _getSavedClientPo after ClientInfo is set
            _getSavedClientPo(ClientInfo!.email);
          });
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });
  }


  void initState() {
    super.initState();
    // _searchPo = [];
    _searchClientPO = [];
    _filteredSaveClientPO = [];
    _savedClientPO = [];
    _checkSession();
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty || query.length == 0) {
      setState(() {
        _filteredSaveClientPO = List.from(_savedClientPO);
      });
    } else {
      setState(() {
        _filteredSaveClientPO = _savedClientPO.where((po) =>
            po.tracking_no.toLowerCase().contains(query.toLowerCase()) ||
            po.po_no.toLowerCase().contains(query.toLowerCase())
        ).toList();

        if(_filteredSaveClientPO.isEmpty){
          _filteredSaveClientPO = List.from(_savedClientPO);
        }
      });
    }
  }

  saveORunsaveTrackingNo(String email, String tracking_no, String po_id, String what_to_do) async {
    setState(() {
      _isLoadingSavedPO = true;
    });

    String result = await ClientPOServices.saveOrUnsaveTrackingNo(
      email, tracking_no, po_id, what_to_do
    );

    if (result == 'success') {
      if(what_to_do == 'Save'){
        custSnackbar(context, "Tracking# ${tracking_no.toUpperCase()} successfully saved !", Colors.green, Icons.check, Colors.white);
      }
      if(what_to_do == 'Unsave'){
        custSnackbar(context, "Tracking# ${tracking_no.toUpperCase()} successfully remove !", Colors.green, Icons.check, Colors.white);
      }

      _searchClientPO.clear();
      searchController.clear();
      _getSavedClientPo(email);
    } else if(result == 'exist'){
      _searchClientPO.clear();
      searchController.clear();
      custSnackbar(context, "Tracking# ${tracking_no.toUpperCase()} already saved in your account!", Colors.blueAccent, Icons.info, Colors.white);
    } else {
      print("Error tracking no : " + result);
      custSnackbar(context, "Error occurred...", Colors.redAccent, Icons.dangerous_rounded, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Tracking',
        imagePath: '',
        appBarHeight: screenHeight * 0.05,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
              Column(
              children: [
                SizedBox(height: screenHeight * 0.025,),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: TextField(
                        onChanged: _filterSearchResults,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: fontNormalSize,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        readOnly: false,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: searchController,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: fontNormalSize,
                            letterSpacing: 0.6,
                          ),
                          labelStyle: TextStyle(
                            fontSize: fontNormalSize,
                            letterSpacing: 0.6,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          fillColor: Colors.deepOrange.shade50,
                          filled: true,
                          hintText: 'Search Tracking #',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: fontNormalSize,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.6,
                          ),
                          // Adding a clear icon
                          suffixIcon: ValueListenableBuilder(
                            valueListenable: searchController,
                            builder: (context, TextEditingValue value, __) {
                              return value.text.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _filterSearchResults('');
                                    searchController.clear();
                                    _searchClientPO.clear();
                                  },
                                )
                                : SizedBox();
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: screenWidth * 0.15,
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _getClientPo(searchController.text);
                          setState(() {
                            _isLoadingPO = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Adjust radius as needed
                          ),
                          padding: EdgeInsets.all(fontNormalSize), // Adjust padding as needed
                        ),
                        child: _isLoadingPO == false
                          ? Icon(
                            Icons.search,
                            color: Colors.white,
                          )
                          : SizedBox(
                            width: fontNormalSize * 1.5,
                            height: fontNormalSize * 1.5, // Set the height
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2, // Optional: Adjust the thickness of the progress indicator
                            ),
                          ),
                      ),
                    )
                  ],
                ),

                if (_searchClientPO.isEmpty && _savedClientPO.isEmpty)
                  Container(
                    height: screenHeight * 0.65,
                    child: Center(
                      child: Text(
                        "No Available Data",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontExtraSize * 2,
                            color: Colors.grey.shade300,
                            letterSpacing: 1.2
                        ),
                      ),
                    ),
                  ),

                _searchClientPO.isNotEmpty
                ? Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: screenHeight * 0.025,),

                      ..._searchClientPO.map((po) {
                        return GestureDetector(
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderTimelinePage(clientPO : po)),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
                            width: screenWidth,
                            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              //  width: SizeConfig.screenWidth * 0.78,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.deepOrange.shade300, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  "PO#\t" + po.po_no,
                                                  style: TextStyle(
                                                      fontFamily: 'Rowdies',
                                                      fontSize: fontExtraSize,
                                                      letterSpacing: 1.2,
                                                      color: Colors.deepOrange[400]
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.005,),
                                              Center(
                                                child: Text(
                                                  po.company.toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Rowdies',
                                                    fontSize: fontNormalSize,
                                                    letterSpacing: 0.8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.005,),
                                              Text(
                                                po.project.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: fontXSmallSize,
                                                  letterSpacing: 0.8,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: (){
                                          FocusScope.of(context).unfocus();
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              icon: Text(
                                                "Would you like to save this tracking number?\n (Tracking# ${po.tracking_no.toUpperCase()})",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: fontNormalSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange.shade400,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                              ),
                                              content: Text(
                                                'Saving it will allow you to easily view it later without searching again.',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: fontSmallSize,
                                                    letterSpacing: 1.2
                                                  ),
                                                ),
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Close",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey.shade700,
                                                      fontSize: fontNormalSize,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: 10,),

                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      saveORunsaveTrackingNo(ClientInfo!.email, po.tracking_no, po.id, 'Save');
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                  child: Text(
                                                    "YES",
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
                                            ),
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.star_border_outlined,
                                            size: fontExtraSize * 1.75,
                                            weight: fontExtraSize,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //details
                                  SizedBox(height: screenHeight * 0.02,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: screenWidth * 0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //estimated delivery
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.local_shipping_outlined,
                                                  color: Colors.deepOrange[400],
                                                  size: fontNormalSize * 1.25,
                                                ),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Text(
                                                    formatDateRangeSplitByTO(po.estimated_delivery).toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //terms
                                            SizedBox(height: screenHeight * 0.01,),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.payments,
                                                  color: Colors.deepOrange[400],
                                                  size: fontNormalSize * 1.25,
                                                ),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Text(
                                                    po.terms.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // order status
                                            SizedBox(height: screenHeight * 0.01,),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.cube_box,
                                                  color: Colors.deepOrange[400],
                                                  size: fontNormalSize * 1.25,
                                                ),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Text(
                                                    po.status,
                                                    style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OrderDetailsPage(po_id: po.id, tracking_no: po.tracking_no,)),
                                              );
                                            },
                                            child: Text(
                                              "Order Summary",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSmallSize,
                                                letterSpacing: 0.8,
                                                color: Colors.grey.shade800, // Text color
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Button background color
                                              side: MaterialStateProperty.all<BorderSide>(
                                                BorderSide(color: Colors.grey, width: 0.65), // Border color and width
                                              ),
                                              padding: MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.symmetric(horizontal: screenWidth * 0.035, vertical: 12.0), // Better padding
                                              ),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4.0), // Rounded corners
                                                ),
                                              ),
                                              elevation: MaterialStateProperty.all<double>(2.0), // Add shadow for button effect
                                              shadowColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)), // Shadow color
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  // SizedBox(height: screenHeight * 0.01,),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Estimated Delivery : ",
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //       WidgetSpan(
                                  //         child: SizedBox(width: 5,),
                                  //       ),
                                  //       TextSpan(
                                  //         text: formatDateRangeSplitByTO(po.estimated_delivery),
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  //
                                  // SizedBox(height: screenHeight * 0.01,),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Terms : ",
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //       WidgetSpan(
                                  //         child: SizedBox(width: 5,),
                                  //       ),
                                  //       TextSpan(
                                  //         text: po.terms.toUpperCase(),
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  //
                                  // SizedBox(height: screenHeight * 0.01,),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Order Status : ",
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //       WidgetSpan(
                                  //         child: SizedBox(width: 5,),
                                  //       ),
                                  //       TextSpan(
                                  //         text: po.status,
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  //tracking number
                                  SizedBox(height: screenHeight * 0.02,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'TRACKING NUMBER',
                                        style: TextStyle(
                                          fontSize: fontNormalSize * 0.85,
                                          color: Colors.grey.shade700,
                                          letterSpacing: 0.8,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          FocusScope.of(context).unfocus();
                                          // Copy the PO# to clipboard
                                          Clipboard.setData(ClipboardData(text: "Tracking # " + po.tracking_no.toUpperCase())).then((_) {
                                            // You can show a Snackbar or any feedback to the user
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Tracking # copied to clipboard')),
                                            );
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              po.tracking_no.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: fontNormalSize * 0.85,
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Icon(Icons.copy, size: fontNormalSize, color: Colors.deepOrange.shade300),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                )
                : SizedBox.shrink(),

                _savedClientPO.isNotEmpty
                ? Expanded(
                  child: ListView(
                    children: [
                      //favorites
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: screenWidth * 0.1,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                indent: 5,           // Spacing before the line
                                endIndent: 5,        // Spacing after the line
                              ),
                            ),
                            Text(
                              'Favorites',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontXSmallSize,
                                  letterSpacing: 1.2,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.35,
                                indent: 5,
                                endIndent: 5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ..._filteredSaveClientPO.map((po) {
                        return GestureDetector(
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderTimelinePage(clientPO : po)),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
                            width: screenWidth,
                            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              //  width: SizeConfig.screenWidth * 0.78,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.deepOrange.shade300, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  "PO#\t" + po.po_no,
                                                  style: TextStyle(
                                                      fontFamily: 'Rowdies',
                                                      fontSize: fontExtraSize,
                                                      letterSpacing: 1.2,
                                                      color: Colors.deepOrange[400]
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.005,),
                                              Center(
                                                child: Text(
                                                  po.company.toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Rowdies',
                                                    fontSize: fontNormalSize,
                                                    letterSpacing: 0.8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: screenHeight * 0.005,),
                                              Text(
                                                po.project.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: fontXSmallSize,
                                                  letterSpacing: 0.8,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: (){
                                          FocusScope.of(context).unfocus();
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              icon: Text(
                                                "Unsave this tracking number?\n(Tracking# ${po.tracking_no.toUpperCase()})",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: fontNormalSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange.shade400,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              ),
                                              content: Text(
                                                'Once unsaved, this tracking number will no longer be available for quick access and you will need to search for it again.',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 1.2
                                                  ),
                                                ),
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Close",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey.shade700,
                                                      fontSize: fontNormalSize,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: 10,),

                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      saveORunsaveTrackingNo(ClientInfo!.email, po.tracking_no, po.id, 'Unsave');
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                  child: Text(
                                                    "REMOVE",
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
                                            ),
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.star,
                                            size: fontExtraSize * 1.75,
                                            weight: fontExtraSize,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //details
                                  SizedBox(height: screenHeight * 0.02,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: screenWidth * 0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //estimated delivery
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.local_shipping_outlined,
                                                  color: Colors.deepOrange[400],
                                                  size: fontNormalSize * 1.25,
                                                ),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Text(
                                                    formatDateRangeSplitByTO(po.estimated_delivery).toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //terms
                                            SizedBox(height: screenHeight * 0.01,),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.payments,
                                                  color: Colors.deepOrange[400],
                                                  size: fontNormalSize * 1.25,
                                                ),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Text(
                                                    po.terms.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // order status
                                            SizedBox(height: screenHeight * 0.01,),
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.cube_box,
                                                  color: Colors.deepOrange[400],
                                                  size: fontNormalSize * 1.25,
                                                ),
                                                SizedBox(width: 5,),
                                                Expanded(
                                                  child: Text(
                                                    po.status,
                                                    style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      letterSpacing: 0.8,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OrderDetailsPage(po_id: po.id, tracking_no: po.tracking_no,)),
                                              );
                                            },
                                            child: Text(
                                              "Order Summary",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSmallSize,
                                                letterSpacing: 0.8,
                                                color: Colors.grey.shade800, // Text color
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Button background color
                                              side: MaterialStateProperty.all<BorderSide>(
                                                BorderSide(color: Colors.grey, width: 0.65), // Border color and width
                                              ),
                                              padding: MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.symmetric(horizontal: screenWidth * 0.035, vertical: 12.0), // Better padding
                                              ),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4.0), // Rounded corners
                                                ),
                                              ),
                                              elevation: MaterialStateProperty.all<double>(2.0), // Add shadow for button effect
                                              shadowColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)), // Shadow color
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  // SizedBox(height: screenHeight * 0.01,),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Estimated Delivery : ",
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //       WidgetSpan(
                                  //         child: SizedBox(width: 5,),
                                  //       ),
                                  //       TextSpan(
                                  //         text: formatDateRangeSplitByTO(po.estimated_delivery),
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  //
                                  // SizedBox(height: screenHeight * 0.01,),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Terms : ",
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //       WidgetSpan(
                                  //         child: SizedBox(width: 5,),
                                  //       ),
                                  //       TextSpan(
                                  //         text: po.terms.toUpperCase(),
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  //
                                  // SizedBox(height: screenHeight * 0.01,),
                                  // RichText(
                                  //   text: TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Order Status : ",
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //       WidgetSpan(
                                  //         child: SizedBox(width: 5,),
                                  //       ),
                                  //       TextSpan(
                                  //         text: po.status,
                                  //         style: TextStyle(
                                  //           fontSize: fontSmallSize,
                                  //           letterSpacing: 0.8,
                                  //           color: Colors.grey.shade700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  //tracking number
                                  SizedBox(height: screenHeight * 0.02,),
                                  GestureDetector(
                                    onTap: (){
                                      FocusScope.of(context).unfocus();
                                      // Copy the PO# to clipboard
                                      Clipboard.setData(ClipboardData(text: "Tracking # " + po.tracking_no.toUpperCase())).then((_) {
                                        // You can show a Snackbar or any feedback to the user
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Tracking # copied to clipboard')),
                                        );
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'TRACKING NUMBER',
                                          style: TextStyle(
                                            fontSize: fontNormalSize * 0.85,
                                            color: Colors.grey.shade700,
                                            letterSpacing: 0.8,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              po.tracking_no.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: fontNormalSize * 0.85,
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Icon(Icons.copy, size: fontNormalSize, color: Colors.deepOrange.shade300),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                )
                : SizedBox.shrink(),
              ],
            ),

            if (_isLoadingSavedPO || _isLoadingPO)
              Container(
                color: Colors.black.withOpacity(0.5), // Optional overlay
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
