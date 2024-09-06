import 'dart:math';

import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class OrderDetailsPage extends StatefulWidget {
  final String quotation_id;
  const OrderDetailsPage({
    super.key,
    required this.quotation_id
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool _isLoadingItems = true;
  List<String> sample_status = ["Ready to Ship", "Pending", "In Transit", "Delivered", "Ordered"];
  Random random = Random();
  
  Color getStatusColor(String status) {
    switch (status) {
      case "Ready to Ship":
        return Colors.green;
      case "Pending":
        return Colors.deepOrange.shade600;
      case "Ordered":
        return Colors.blue;
      case "In Transit":
        return Colors.deepOrange.shade600;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.black; // Default color for unknown statuses
    }
  }

  late List<QuotationPOItems> _items;
  _getQuotationPoItems(String quotation_id){
    QuotationPOServices.getQuotationPOItems(quotation_id).then((items){
      setState(() {
        _items = items;
      });
      _isLoadingItems = false;
    });
  }

  void initState() {
    super.initState();
    _items = [];
    _getQuotationPoItems(widget.quotation_id);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: _isLoadingItems
        ? Center(child: CircularProgressIndicator(),)
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(color: Colors.deepOrange.shade500),
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(screenWidth * 0.125),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(screenWidth * 0.2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              //header
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'STATUS',
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

              ..._items.map((items) {
                int randomIndex = random.nextInt(sample_status.length); // Generate a random index based on the sample_status length
                String status = sample_status[randomIndex]; // Get the random status

                return TableRow(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          items.qty,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              items.item_name.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8
                              )
                          ),
                          Text(
                              items.item_desc,
                              style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: getStatusColor(status),
                          fontWeight: FontWeight.bold,
                          fontSize: fontSmallSize,
                          letterSpacing: 0.8
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
    );
  }
}
