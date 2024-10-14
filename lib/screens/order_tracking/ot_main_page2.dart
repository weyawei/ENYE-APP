import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class OrderTracking2Page extends StatefulWidget {
  const OrderTracking2Page({super.key});

  @override
  State<OrderTracking2Page> createState() => _OrderTracking2PageState();
}

class _OrderTracking2PageState extends State<OrderTracking2Page> {
  final searchController = TextEditingController();
  bool _isLoadingClientPO = true;

  late List<ClientPO> _clientPO;
  late List<ClientPO> _filteredClientPO;
  _getClientPOBasedEmail(String email){
    ClientPOServices.getClientPOEmailBased(email).then((po){
      setState(() {
        _clientPO = po;
        _filteredClientPO = po;
      });
      _isLoadingClientPO = false;
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
            _getClientPOBasedEmail(ClientInfo!.email);
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
    _clientPO = [];
    _filteredClientPO = [];
    _checkSession();
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty || query.length == 0) {
      setState(() {
        _filteredClientPO = List.from(_clientPO);
      });
    } else {
      setState(() {
        _filteredClientPO = _clientPO.where((po) =>
        po.tracking_no.toLowerCase().contains(query.toLowerCase()) ||
            po.po_no.toLowerCase().contains(query.toLowerCase()) ||
            po.company.toLowerCase().contains(query.toLowerCase()) ||
            po.project.toLowerCase().contains(query.toLowerCase())
        ).toList();
      });
    }
  }

  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _scaffoldMessenger?.hideCurrentSnackBar();
    super.dispose();
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _getClientPOBasedEmail(ClientInfo!.email);
          });
        },
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.025,),
              Container(
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
                    hintText: 'Search...',
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
                          },
                        )
                            : SizedBox();
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.025,),

              if (_isLoadingClientPO)
                Container(
                  height: screenHeight * 0.5,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else

              _filteredClientPO.isNotEmpty
              ? Expanded(
                child: ListView(
                  children: [

                    ..._filteredClientPO.map((po) {
                      return GestureDetector(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderTimelinePage(clientPO : po)),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
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
                                Column(
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
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    color: Colors.teal.shade300,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OrderDetailsPage(po_id: po.id, tracking_no: po.tracking_no, email: ClientInfo!.email,)),
                                              );
                                            },
                                            child: Text(
                                              "Order Summary",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSmallSize * 0.9,
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
                                      ),
                                    )
                                  ],
                                ),

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
                                        'REFERENCE NUMBER',
                                        style: TextStyle(
                                          fontSize: fontNormalSize * 0.75,
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
                                              fontSize: fontNormalSize * 0.75,
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
              : Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
