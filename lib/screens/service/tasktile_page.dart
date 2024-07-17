import 'package:flutter/material.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class TaskTile extends StatefulWidget {
  final TechnicalData services;
  const TaskTile({super.key, required this.services});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getStatusColor(widget.services.status),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${widget.services.svcId}",
                  style: TextStyle(
                    fontSize: fontExtraSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "${widget.services.service} - ",
                      style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    TextSpan(text: "(${widget.services.svcTitle})",
                      style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                  ]
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "Description : ",
                      style: TextStyle(fontSize: fontSmallSize, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                    TextSpan(text: "${widget.services.svcDesc}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                  ]
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "Requestor Name : ",
                      style: TextStyle(fontSize: fontSmallSize, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                    TextSpan(text: "${widget.services.reqName}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                  ]
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "Designation : ",
                      style: TextStyle(fontSize: fontSmallSize, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                    TextSpan(text: "${widget.services.reqPosition}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                  ]
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: screenHeight * 0.15,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              widget.services.status.toUpperCase(),
              style: TextStyle(
                  fontSize: fontSmallSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == "On Process") {
      return Colors.orangeAccent;
    } else if (status == "Unread") {
      return Colors.blue;
    } else if (status == "Set-sched") {
      return Colors.green;
    } else if (status == "Completed" || status == "Complete") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }
}
