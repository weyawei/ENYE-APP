import 'package:enye_app/screens/order_tracking/dr_details_page.dart';
import 'package:enye_app/screens/order_tracking/order_details_page.dart';
import 'package:enye_app/screens/order_tracking/prf_tracking_page.dart';
import 'package:flutter/material.dart';

import '../../widget/bulletFormat.dart';
import '../../widget/widgets.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {


  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                  controller: null,
                  hintText: 'Search PO #',
                  disabling: false,
                ),
              ),

              SizedBox(
                width: screenWidth * 0.15,
                child: ElevatedButton(
                  onPressed: () {
                    // Define the action for the button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Adjust radius as needed
                    ),
                    padding: EdgeInsets.all(fontNormalSize), // Adjust padding as needed
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: screenHeight * 0.025,),
          Expanded(
            child: ListView(
              children: [
                Container(
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
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "PO# 1018017",
                                style: TextStyle(
                                  fontSize: fontExtraSize,
                                  letterSpacing: 0.8,
                                  fontFamily: 'Rowdies',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_sharp,
                                  size: fontNormalSize * 1.5,
                                  color: Colors.deepOrange.shade300,
                                ),
                                SizedBox(width: screenWidth * 0.01,),
                                Expanded(
                                  child: Text(
                                    "Order Fulfillment",
                                    style: TextStyle(fontSize: fontNormalSize), // Adjust text style as needed
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
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
                                        MaterialPageRoute(builder: (context) => OrderDetailsPage()),
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
                                            "Order Details (25%)",
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
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
                                SizedBox(width: screenWidth * 0.01,),
                                Expanded(
                                  child: Text(
                                    "Payment Status",
                                    style: TextStyle(fontSize: fontNormalSize), // Adjust text style as needed
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.square,
                                        size: fontSmallSize,
                                        color: Colors.black87,
                                      ),
                                      SizedBox(width: screenWidth * 0.01,),
                                      Expanded(
                                        child: Text(
                                          "Invoice (Unavailable)",
                                          style: TextStyle(
                                              fontSize: fontSmallSize,
                                              letterSpacing: 0.8
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
                                        color: Colors.black87,
                                      ),
                                      SizedBox(width: screenWidth * 0.01,),
                                      Expanded(
                                        child: Text(
                                          "Payment Details (75.45%)",
                                          style: TextStyle(
                                              fontSize: fontSmallSize,
                                              letterSpacing: 0.8
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
                                SizedBox(width: screenWidth * 0.01,),
                                Expanded(
                                  child: Text(
                                    "Delivery Status",
                                    style: TextStyle(fontSize: fontNormalSize), // Adjust text style as needed
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
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
                                          color: Colors.black87,
                                        ),
                                        SizedBox(width: screenWidth * 0.01,),
                                        Expanded(
                                          child: Text(
                                            "Delivery Report Details (3/3)",
                                            style: TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              decorationThickness: 2.0,
                                              fontSize: fontSmallSize,
                                              color: Colors.black54,
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
                                        color: Colors.black87,
                                      ),
                                      SizedBox(width: screenWidth * 0.01,),
                                      Expanded(
                                        child: Text(
                                          "Status (100%)",
                                          style: TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            decorationThickness: 2.0,
                                            fontSize: fontSmallSize,
                                            color: Colors.black54,
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
                        height: screenHeight * 0.35,
                        width: 0.75,
                        color: Colors.deepOrange[200]!.withOpacity(0.7),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "SYNC Y TOWER",
                          style: TextStyle(
                              fontSize: fontSmallSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: Colors.deepOrange[400]
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
