import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

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
          'PO# 1018017',
          style: TextStyle(
            fontSize: fontNormalSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(), // Optional: Add borders
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(screenWidth * 0.125),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(screenWidth * 0.2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ITEM NAME', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('1'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('John Doe'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('25'),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('2'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Jane Smith'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('30'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
