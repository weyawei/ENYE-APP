import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widget/widgets.dart';
import 'components/timeline_tile_page.dart';

class OrderTimelinePage extends StatelessWidget {
  final String po_no;

  const OrderTimelinePage({
    super.key,
    required this.po_no
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ESTIMATED DELIVERY',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '12 Sept - 13 Sept',
                          style: TextStyle(
                            fontSize: fontNormalSize,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'PO NUMBER',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: (){
                            // Copy the PO# to clipboard
                            Clipboard.setData(ClipboardData(text: "PO# " + po_no)).then((_) {
                              // You can show a Snackbar or any feedback to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('PO# copied to clipboard')),
                              );
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: po_no.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: fontNormalSize,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(width: 5,),
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.copy, size: fontSmallSize * 1.25, color: Colors.deepOrange.shade300),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.025,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.business_center, size: fontSmallSize * 1.5, color: Colors.deepOrange.shade300),
                              ),
                              WidgetSpan(
                                child: SizedBox(width: 5,),
                              ),
                              TextSpan(
                                text: "FR SEVILLA INDUSTRIAL CORP.",
                                style: TextStyle(
                                  fontFamily: 'Rowdies',
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.business, size: fontSmallSize * 1.5, color: Colors.deepOrange.shade300),
                              ),
                              WidgetSpan(
                                child: SizedBox(width: 5,),
                              ),
                              TextSpan(
                                text: "GALLEON OFFICE TOWER",
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
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.25,
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.payments_outlined, size: fontSmallSize * 1.5, color: Colors.deepOrange.shade300),
                          ),
                          WidgetSpan(
                            child: SizedBox(width: 5,),
                          ),
                          TextSpan(
                            text: "30% DP and 30 days",
                            style: TextStyle(
                              fontSize: fontSmallSize,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.015,),

            TimelineTilePage(
              isFirst: true,
              isLast: false,
              isPast: true,
              icon: Icons.local_shipping_sharp,
              eventCard: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "In Transit",
                    style: TextStyle(
                        fontSize: fontNormalSize,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),

                  Text(
                    "Your parcel has arrived at the delivery hub : Santa Maria, 16 PN8-HUB_Bulacan",
                    style: TextStyle(
                        fontSize: fontSmallSize,
                        letterSpacing: 0.8,
                        color: Colors.white
                    ),
                  )
                ],
              ),
              timeCard: "Today \n 03:56",
            ),

            TimelineTilePage(
              isFirst: false,
              isLast: false,
              isPast: false,
              icon: Icons.circle,
              eventCard: Text(
                "Parcel has departed from sorting facility : San Fernando City, SDN_PDC",
                style: TextStyle(
                    letterSpacing: 0.8,
                    fontSize: fontSmallSize,
                    color: Colors.deepOrange.shade900.withOpacity(0.65)
                ),
              ),
              timeCard: "11 Sept \n 20:34",
            ),

            TimelineTilePage(
              isFirst: false,
              isLast: false,
              isPast: false,
              icon: Icons.circle,
              eventCard: Text(
                "Parcel has arrived at sorting facility : San Fernando City, SDN_PDC",
                style: TextStyle(
                    letterSpacing: 0.8,
                    fontSize: fontSmallSize,
                    color: Colors.deepOrange.shade900.withOpacity(0.65)
                ),
              ),
              timeCard: "11 Sept \n 20:19",
            ),

            TimelineTilePage(
              isFirst: false,
              isLast: false,
              isPast: false,
              icon: Icons.circle,
              eventCard: Text(
                "Your parcel has been picked up by our logistics partner",
                style: TextStyle(
                    letterSpacing: 0.8,
                    fontSize: fontSmallSize,
                    color: Colors.deepOrange.shade900.withOpacity(0.65)
                ),
              ),
              timeCard: "11 Sept \n 13:08",
            ),

            TimelineTilePage(
              isFirst: false,
              isLast: false,
              isPast: false,
              icon: Icons.inventory_2_sharp,
              eventCard: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Preparing to ship",
                    style: TextStyle(
                        fontSize: fontNormalSize,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade900.withOpacity(0.65)
                    ),
                  ),

                  Text(
                    "Seller is preparing to ship your parcel",
                    style: TextStyle(
                        fontSize: fontSmallSize,
                        letterSpacing: 0.8,
                        color: Colors.deepOrange.shade900.withOpacity(0.65)
                    ),
                  )
                ],
              ),
              timeCard: "10 Sept \n 18:27",
            ),

            TimelineTilePage(
              isFirst: false,
              isLast: true,
              isPast: false,
              icon: Icons.content_paste,
              eventCard: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Placed",
                    style: TextStyle(
                        fontSize: fontNormalSize,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade900.withOpacity(0.65)
                    ),
                  ),

                  Text(
                    "Order is placed",
                    style: TextStyle(
                        fontSize: fontSmallSize,
                        letterSpacing: 0.8,
                        color: Colors.deepOrange.shade900.withOpacity(0.65)
                    ),
                  )
                ],
              ),
              timeCard: "9 Sept \n 15:49",
            ),
          ],
        ),
      ),
    );
  }
}