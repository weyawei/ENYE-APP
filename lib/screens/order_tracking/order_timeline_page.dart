import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widget/widgets.dart';
import '../screens.dart';
import 'components/timeline_tile_page.dart';

class OrderTimelinePage extends StatefulWidget {
  final ClientPO clientPO;

  const OrderTimelinePage({
    super.key,
    required this.clientPO,
  });

  @override
  State<OrderTimelinePage> createState() => _OrderTimelinePageState();
}

class _OrderTimelinePageState extends State<OrderTimelinePage> {
  bool _isLoadingPODetails = true;

  late List<PODetails> _poDetails;
  _getClientDetails(String po_id){
    ClientPOServices.getPODetails(po_id).then((poDetails){
      setState(() {
        _poDetails = poDetails;
      });
      _isLoadingPODetails = false;
    });
    print(_poDetails.length);
  }

  void initState() {
    super.initState();
    // _searchPo = [];
    _poDetails = [];
    _getClientDetails(widget.clientPO.id);
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
        title: 'Order Details',
        imagePath: '',
        appBarHeight: screenHeight * 0.05,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _getClientDetails(widget.clientPO.id);
          });
        },
        child: Container(
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
                            formatDateRangeSplitByTO(widget.clientPO.estimated_delivery),
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
                              Clipboard.setData(ClipboardData(text: "PO# " + widget.clientPO.po_no)).then((_) {
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
                                    text: widget.clientPO.po_no.toUpperCase(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.business_center, size: fontSmallSize * 1.25, color: Colors.deepOrange.shade300),
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(
                                  widget.clientPO.company,
                                  style: TextStyle(
                                    fontFamily: 'Rowdies',
                                    fontSize: fontSmallSize,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              ),
                            ],
                          ),

                          SizedBox(height: 2.5,),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.business, size: fontSmallSize * 1.25, color: Colors.deepOrange.shade300),
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(
                                  widget.clientPO.project,
                                  style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      width: screenWidth * 0.3,
                      child: Row(
                        children: [
                          Icon(Icons.payments_outlined, size: fontSmallSize * 1.5, color: Colors.deepOrange.shade300),
                          SizedBox(width: 5,),
                          Expanded(
                            child: Text(
                              widget.clientPO.terms,
                                style: TextStyle(
                                  fontSize: fontXSmallSize,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                            )
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015,),

              if(_isLoadingPODetails)
                Container(
                  height: screenHeight * 0.65,
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                )
              else
                if (_poDetails.isEmpty)
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
                  )
                else
                  ..._poDetails.map((po) {
                    Map<String, String> dateParts = extractDateParts(po.date_created);

                    return TimelineTilePage(
                      isFirst: _poDetails.first.sort_no == po.sort_no ? true : false,
                      isLast: _poDetails.last.sort_no == po.sort_no ? true : false,
                      isPast: _poDetails.first.sort_no == po.sort_no ? false : true,
                      icon: _poDetails.first.sort_no == po.sort_no && po.status == "Delivered" ? Icons.check : Icons.circle,
                      imageIcon: getStatusImage(po.status),
                      status: po.status,
                      payment_status: po.payment_status,
                      remarks: po.remarks,
                        timeCard: "${dateParts['day']} ${dateParts['month']}\n${dateParts['year']}"
                    );
                  }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  String getStatusImage(String status) {
    switch (status) {
      case "Delivered":
        return 'assets/icons/delivered-bg.png';
      case "Ready for Delivery":
        return 'assets/icons/ready_delivery-bg.png';
      case "Production in Progress":
        return 'assets/icons/production_progress-bg.png';
      case "Order Processing":
        return 'assets/icons/order-processing.png';
      case "Order Confirmed":
        return 'assets/icons/order_confirmed-bg.png';
      case "Order Received":
        return 'assets/icons/order_received-bg.png';
      default:
        return 'assets/icons/tracking.png'; // Optional: A default image if no match is found
    }
  }
}
