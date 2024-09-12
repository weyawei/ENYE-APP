import 'package:enye_app/screens/order_tracking/dr_details_page.dart';
import 'package:enye_app/screens/order_tracking/order_details_page.dart';
import 'package:enye_app/screens/order_tracking/prf_tracking_page.dart';
import 'package:flutter/material.dart';

import '../../widget/bulletFormat.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final searchController = TextEditingController();
  bool po_track_status = false;
  bool _isLoadingPO = false;

  late List<QuotationPO> _searchPo;
  _getQuotationPo(String po_no){
    QuotationPOServices.getQuotationPO(po_no).then((po){
      setState(() {
        _searchPo = po;
      });
      _isLoadingPO = false;
    });
  }

  void initState() {
    super.initState();
    _searchPo = [];
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
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.025,),
          Row(
            children: [
              SizedBox(
                width: screenWidth * 0.8,
                child: NormalTextField(
                  controller: searchController,
                  hintText: 'Search PO #',
                  disabling: false,
                ),
              ),

              SizedBox(
                width: screenWidth * 0.15,
                child: ElevatedButton(
                  onPressed: () {
                    _getQuotationPo(searchController.text);
                    setState(() {
                      _isLoadingPO = true;
                      if(_searchPo.isNotEmpty){ searchController.clear(); };
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

          SizedBox(height: screenHeight * 0.025,),
          Expanded(
            child: ListView(
              children: [
                if (_searchPo.isNotEmpty)
                  ..._searchPo.map((po) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
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
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            po.company_name.toUpperCase(),
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
                                          po.project_name.toUpperCase(),
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
                                    setState(() {
                                      po_track_status = po_track_status ? false : true;
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      po_track_status
                                        ? Icons.star
                                        : Icons.star_border_outlined,
                                      size: fontExtraSize * 2,
                                      weight: fontExtraSize,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.025,),

                            Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.receipt_long_sharp,
                                          size: fontNormalSize * 1.5,
                                          color: Colors.deepOrange.shade300,
                                        ),
                                        SizedBox(width: screenWidth * 0.015,),
                                        Expanded(
                                          child: Text(
                                            "Order Fulfillment",
                                            style: TextStyle(
                                              fontSize: fontNormalSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                              letterSpacing: 0.5,
                                            ), // Adjust text style as needed
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: screenWidth * 0.1, top: 10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.square,
                                                size: fontSmallSize,
                                                color: Colors.green.shade300,
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              Expanded(
                                                child: Text(
                                                  "Order (Received)",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: fontSmallSize,
                                                      color: Colors.green.shade300,
                                                      letterSpacing: 1.2
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight * 0.01,),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OrderDetailsPage(quotation_id: po.id)),
                                              );
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.square,
                                                  size: fontSmallSize,
                                                  color: Colors.grey.shade700,
                                                ),
                                                SizedBox(width: screenWidth * 0.01,),
                                                Expanded(
                                                  child: Text(
                                                    "Order Details (50%)",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blueAccent,
                                                        fontSize: fontSmallSize,
                                                        letterSpacing: 0.8
                                                    ), // Adjust text style as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.01,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.square,
                                                size: fontSmallSize,
                                                color: Colors.grey.shade700,
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              Text(
                                                "Status : ",
                                                style: TextStyle(
                                                  fontSize: fontSmallSize,
                                                  letterSpacing: 0.8,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              Expanded(
                                                child: Text(
                                                  "On Process...",
                                                  style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.deepOrangeAccent,
                                                      letterSpacing: 1.2
                                                  ), // Adjust text style as needed
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.payments,
                                          size: fontNormalSize * 1.5,
                                          color: Colors.deepOrange.shade300,
                                        ),
                                        SizedBox(width: screenWidth * 0.015,),
                                        Expanded(
                                          child: Text(
                                            "Payment",
                                            style: TextStyle(
                                              fontSize: fontNormalSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                              letterSpacing: 0.5,
                                            ), //
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: screenWidth * 0.1, top: 10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.square,
                                                size: fontSmallSize,
                                                color: Colors.grey.shade700,
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              Expanded(
                                                child: Text(
                                                  "Invoice",
                                                  style: TextStyle(
                                                    fontSize: fontSmallSize,
                                                    letterSpacing: 0.8,
                                                    color: Colors.grey.shade700,
                                                  ), // Adjust text style as needed
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight * 0.0075,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.square,
                                                size: fontSmallSize,
                                                color: Colors.grey.shade700,
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              Expanded(
                                                child: Text(
                                                  "Payment Details",
                                                  style: TextStyle(
                                                    fontSize: fontSmallSize,
                                                    letterSpacing: 0.8,
                                                    color: Colors.grey.shade700,
                                                  ), // Adjust text style as needed
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_shipping,
                                          size: fontNormalSize * 1.5,
                                          color: Colors.deepOrange.shade300,
                                        ),
                                        SizedBox(width: screenWidth * 0.015,),
                                        Expanded(
                                          child: Text(
                                            "Delivery",
                                            style: TextStyle(
                                              fontSize: fontNormalSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                              letterSpacing: 0.5,
                                            ), //
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: screenWidth * 0.1, top: 10.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => DRdetailsPage()),
                                              );
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.square,
                                                  size: fontSmallSize,
                                                  color: Colors.grey.shade700,
                                                ),
                                                SizedBox(width: screenWidth * 0.01,),
                                                Expanded(
                                                  child: Text(
                                                    "Delivery Report Details",
                                                    style: TextStyle(
                                                        fontSize: fontSmallSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blueAccent,
                                                        letterSpacing: 0.8
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.0075,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.square,
                                                size: fontSmallSize,
                                                color: Colors.grey.shade700,
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              Expanded(
                                                child: Text(
                                                  "Status",
                                                  style: TextStyle(
                                                      fontSize: fontSmallSize,
                                                      color: Colors.grey.shade700,
                                                      letterSpacing: 0.8
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                height: screenHeight * 0.28,
                                width: 0.75,
                                color: Colors.deepOrange[200]!.withOpacity(0.7),
                              ),
                              RotatedBox(
                                quarterTurns: 3,
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
                            ]),
                          ],
                        ),
                      ),
                    );
                  }).toList(),


              ],
            ),
          )
        ],
      ),
    );
  }
}
