import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class DRdetailsPage extends StatelessWidget {
  const DRdetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PO# SYNC-24-06',
          style: TextStyle(
            fontSize: fontNormalSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "DR #",
                                  style: TextStyle(
                                    fontSize: fontExtraSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "0011",
                                  style: TextStyle(
                                    fontSize: fontExtraSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.015,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivered by : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text(
                                  "Juan Dela Cruz",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Received by : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text(
                                  "Pedro Penduko",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Date Received : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Text(
                                    "11 Sept 2024 04:11 PM",
                                    style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.015,),
                            Text(
                              "Remarks : ",
                              style: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                              child: Text(
                                "Complete Delivery",
                                style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: screenHeight * 0.175,
                        width: 0.75,
                        color: Colors.deepOrange[200]!.withOpacity(0.7),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DrPdfPreviewPage(dr_no: '0011',)),
                          );
                        },
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: fontSmallSize * 1.5,
                                color: Colors.deepOrange[400]
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "View PDF",
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.deepOrange[400]
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "DR #",
                                  style: TextStyle(
                                    fontSize: fontExtraSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "0007",
                                  style: TextStyle(
                                    fontSize: fontExtraSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.015,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivered by : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text(
                                  "Juan Dela Cruz",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Received by : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text(
                                  "Pedro Penduko",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Date Received : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Text(
                                    "07 Sept 2024 03:34 PM",
                                    style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.015,),
                            Text(
                              "Remarks : ",
                              style: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                              child: Text(
                                "Partial Delivery",
                                style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: screenHeight * 0.175,
                        width: 0.75,
                        color: Colors.deepOrange[200]!.withOpacity(0.7),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DrPdfPreviewPage(dr_no: '0007',)),
                          );
                        },
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Row(
                            children: [
                              Icon(
                                  Icons.picture_as_pdf,
                                  size: fontSmallSize * 1.5,
                                  color: Colors.deepOrange[400]
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "View PDF",
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.deepOrange[400]
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "DR #",
                                  style: TextStyle(
                                    fontSize: fontExtraSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "0004",
                                  style: TextStyle(
                                    fontSize: fontExtraSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.015,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivered by : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text(
                                  "Juan Dela Cruz",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Received by : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text(
                                  "Pedro Penduko",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Date Received : ",
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Text(
                                    "04 Sept 2024 03:00 PM",
                                    style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.015,),
                            Text(
                              "Remarks : ",
                              style: TextStyle(
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                              child: Text(
                                "Partial Delivery",
                                style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: screenHeight * 0.175,
                        width: 0.75,
                        color: Colors.deepOrange[200]!.withOpacity(0.7),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DrPdfPreviewPage(dr_no: '0004',)),
                          );
                        },
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Row(
                            children: [
                              Icon(
                                  Icons.picture_as_pdf,
                                  size: fontSmallSize * 1.5,
                                  color: Colors.deepOrange[400]
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "View PDF",
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.deepOrange[400]
                                ),
                              )
                            ],
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
