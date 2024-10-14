
import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class OrderDetailsPage extends StatefulWidget {
  final String po_id;
  final String tracking_no;
  final String email;
  const OrderDetailsPage({
    super.key,
    required this.po_id,
    required this.tracking_no,
    required this.email,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool _isLoadingItems = true;
  bool _isLoadingPO = true;
  bool _isLoadingPODetails = true;

  // List<String> sample_status = ["Ready to Ship", "Pending", "In Transit", "Delivered", "Ordered"];
  // Random random = Random();
  //
  // Color getStatusColor(String status) {
  //   switch (status) {
  //     case "Ready to Ship":
  //       return Colors.green;
  //     case "Pending":
  //       return Colors.deepOrange.shade600;
  //     case "Ordered":
  //       return Colors.blue;
  //     case "In Transit":
  //       return Colors.deepOrange.shade600;
  //     case "Delivered":
  //       return Colors.green;
  //     default:
  //       return Colors.black; // Default color for unknown statuses
  //   }
  // }
  //
  // late List<QuotationPOItems> _items;
  // _getQuotationPoItems(String quotation_id){
  //   QuotationPOServices.getQuotationPOItems(quotation_id).then((items){
  //     setState(() {
  //       _items = items;
  //     });
  //     _isLoadingItems = false;
  //   });
  // }

  late List<ClientPOItems> _items;
  _getClientPOItems(String po_id){
    ClientPOServices.getClientPOItems(po_id).then((items){
      setState(() {
        _items = items;
      });
      _isLoadingItems = false;
    });
  }

  late List<ClientPO> _po;
  _getClientPO(String tracking_no){
    ClientPOServices.getClientPO(tracking_no, widget.email).then((po){
      setState(() {
        _po = po;
      });
      _isLoadingPO = false;
    });
  }

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
    _items = [];
    _po = [];
    _poDetails = [];
    _getClientPOItems(widget.po_id);
    _getClientPO(widget.tracking_no);
    _getClientDetails(widget.po_id);
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
        title: 'Order Summary',
        imagePath: '',
        appBarHeight: screenHeight * 0.05,
      ),
      body: _isLoadingItems || _isLoadingPO || _isLoadingPODetails
      ? Center(child: CircularProgressIndicator())
      : ListView(
        children: [
          SizedBox(height: screenHeight * 0.025,),
          Container(
            width: screenWidth,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              color: Colors.teal,
              border: Border.all(
                color: Colors.black12, // Slight border to make it look like paper
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),  // Top-left corner
                topRight: Radius.circular(12.0), // Top-right corner
              ),
            ),
            child: Text(
              "Estimated Delivery : ${formatDateRangeSplitByTO(_po[0].estimated_delivery)}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontNormalSize * 0.9,
                letterSpacing: 0.6
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderTimelinePage(clientPO : _po[0])),
              );
            },
            child: Container(
              width: screenWidth,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black12, // Slight border to make it look like paper
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12.0),  // Top-left corner
                  bottomLeft: Radius.circular(12.0), // Top-right corner
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tracking Number",
                              style: TextStyle(
                                letterSpacing: 0.6,
                                fontSize: fontSmallSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _po[0].tracking_no.toUpperCase(),
                              style: TextStyle(
                                letterSpacing: 0.6,
                                color: Colors.grey.shade700,
                                fontSize: fontSmallSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        ">",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: fontNormalSize,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01,),
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: fontNormalSize * 1.5,
                        color: Colors.grey.shade700,
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _poDetails.first.status,
                              style: TextStyle(
                                letterSpacing: 0.6,
                                fontSize: fontSmallSize,
                                color: Colors.teal.shade300,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _poDetails.first.date_created,
                              style: TextStyle(
                                letterSpacing: 0.6,
                                color: Colors.grey.shade700,
                                fontSize: fontXSmallSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: screenWidth,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.025),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12, // Slight border to make it look like paper
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                      image: AssetImage('assets/logo/enyecontrols.png'),
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.35,
                    ),
                    Text(
                      "PO# ${_po[0].po_no.toUpperCase()}",
                      style: TextStyle(
                        fontSize: fontNormalSize * 0.9,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.5,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.business_center,
                                size: fontSmallSize * 1.25,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  _po[0].company,
                                  style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.5,
                                      color: Colors.grey.shade800
                                  )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.business,
                                size: fontSmallSize * 1.5,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    _po[0].project,
                                    style: TextStyle(
                                      fontSize: fontSmallSize,
                                      letterSpacing: 0.5,
                                      color: Colors.grey.shade800
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04,),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.payments,
                            size: fontSmallSize * 1.25,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              _po[0].terms.toUpperCase(),
                              style: TextStyle(
                                fontSize: fontXSmallSize,
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

                    ..._items.map((item) {

                      return TableRow(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                item.qty,
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
                                    item.item_name.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSmallSize,
                                        letterSpacing: 0.8
                                    )
                                ),
                                Text(
                                    item.item_desc,
                                    style: TextStyle(
                                        fontSize: fontXSmallSize,
                                        letterSpacing: 0.8
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     title: Text(
    //       'PO# 1018017',
    //       style: TextStyle(
    //         fontSize: fontNormalSize,
    //         fontWeight: FontWeight.bold,
    //         letterSpacing: 1.2,
    //       ),
    //     ),
    //   ),
    //   body: _isLoadingItems
    //     ? Center(child: CircularProgressIndicator(),)
    //     : Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Table(
    //         border: TableBorder.all(color: Colors.deepOrange.shade500),
    //         columnWidths: <int, TableColumnWidth>{
    //           0: FixedColumnWidth(screenWidth * 0.125),
    //           1: FlexColumnWidth(),
    //           2: FixedColumnWidth(screenWidth * 0.2),
    //         },
    //         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //         children: <TableRow>[
    //           //header
    //           TableRow(
    //             decoration: BoxDecoration(
    //                 color: Colors.deepOrange.shade300
    //             ),
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   'QTY',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: fontSmallSize,
    //                       letterSpacing: 0.8,
    //                       color: Colors.white
    //                   )
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   'ITEM NAME',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: fontSmallSize,
    //                       letterSpacing: 0.8,
    //                       color: Colors.white
    //                   )
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   'STATUS',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: fontSmallSize,
    //                       letterSpacing: 0.8,
    //                       color: Colors.white
    //                   )
    //                 ),
    //               ),
    //             ],
    //           ),
    //
    //           ..._items.map((items) {
    //             int randomIndex = random.nextInt(sample_status.length); // Generate a random index based on the sample_status length
    //             String status = sample_status[randomIndex]; // Get the random status
    //
    //             return TableRow(
    //               children: <Widget>[
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Text(
    //                       items.qty,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: fontSmallSize,
    //                           letterSpacing: 0.8
    //                       )
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                           items.item_name.toUpperCase(),
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: fontSmallSize,
    //                               letterSpacing: 0.8
    //                           )
    //                       ),
    //                       Text(
    //                           items.item_desc,
    //                           style: TextStyle(
    //                               fontSize: fontSmallSize,
    //                               letterSpacing: 0.8
    //                           )
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Text(
    //                     status,
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       color: getStatusColor(status),
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: fontSmallSize,
    //                       letterSpacing: 0.8
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             );
    //           }).toList(),
    //         ],
    //       ),
    //     ),
    // );
  }
}
