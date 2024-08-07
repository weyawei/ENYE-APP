import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class TaskTile extends StatefulWidget {
  final TechnicalData services;
  final EcTSIS? tsis;
  final List<EcEvent> event;
  const TaskTile({super.key, required this.services, required this.tsis, required this.event});

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
                    TextSpan(text: "\t - ${widget.services.svcDesc}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                  ]
                  ),
                ),

                SizedBox(height: screenHeight * 0.02,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "${widget.services.clientProjName}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),

                    TextSpan(text: " || ${widget.services.clientCompany}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),

                    TextSpan(text: " || ${widget.services.clientLocation}",
                      style: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                    ),
                  ]
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                if (widget.event.isNotEmpty)
                  ...widget.event.map((events) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.grey[200],
                          size: fontNormalSize * 1.5,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.yMMMd().format(DateTime.parse(events.start))} TO ${DateFormat.yMMMd().format(DateTime.parse(events.end))}',
                          style: TextStyle(
                              fontSize: fontNormalSize,
                              letterSpacing: 0.5,
                              color: Colors.grey[100]
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
