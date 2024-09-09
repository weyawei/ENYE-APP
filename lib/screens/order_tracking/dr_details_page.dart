import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class DRdetailsPage extends StatelessWidget {
  const DRdetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PO# 1018017',
          style: TextStyle(
            fontSize: fontNormalSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: screenWidth,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.025),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
              border: Border.all(
                color: Colors.black12, // Slight border to make it look like paper
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "No. 0007",
                    style: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                  child: Text(
                    'Delivery Receipt',
                    style: TextStyle(
                        fontSize: fontExtraSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.grey.shade800
                    )
                  ),
                ),

                Table(
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(screenWidth * 0.45),
                    1: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.payments,
                              size: fontSmallSize * 1.5,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  '30% Dp 30 Says PDC, 70% 45 days PDC',
                                  style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.5,
                                      color: Colors.grey.shade800
                                  )
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.date_range,
                                size: fontSmallSize * 1.5,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '2024-01-24',
                                  style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.5,
                                      color: Colors.grey.shade800
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: fontSmallSize * 1.5,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  'General Mariano Alvarez Cavite',
                                  style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.5,
                                      color: Colors.grey.shade800
                                  )
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.local_shipping,
                                size: fontSmallSize * 1.5,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    'Office',
                                    style: TextStyle(
                                        fontSize: fontSmallSize,
                                        letterSpacing: 0.5,
                                        color: Colors.grey.shade800
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),
                Table(
                  border: TableBorder.all(color: Colors.deepOrange.shade500),
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(screenWidth * 0.125),
                    1: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade300
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'QTY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSmallSize,
                                letterSpacing: 0.8,
                                color: Colors.white
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'ITEM NAME',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSmallSize,
                                letterSpacing: 0.8,
                                color: Colors.white
                              )
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                  "SRVAV-09S",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.8
                                  )
                              ),
                              Text(
                                  "384-2376 CMHinlet dia 226mm ",
                                  style: TextStyle(
                                      fontSize: fontXSmallSize,
                                      letterSpacing: 0.8
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                  "NSVA0222B",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.8
                                  )
                              ),
                              Text(
                                  "Smart VAV Actuator ACDC24V 5060Hz 3VA 15W BACNET ",
                                  style: TextStyle(
                                      fontSize: fontXSmallSize,
                                      letterSpacing: 0.8
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                  "NEVD",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.8
                                  )
                              ),
                              Text(
                                  "HMI Thermostats for VAV Actuator with Temp Sensor and LED Display",
                                  style: TextStyle(
                                      fontSize: fontXSmallSize,
                                      letterSpacing: 0.8
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01,),

        ],
      ),
    );
  }
}
