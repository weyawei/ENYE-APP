import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widget/widgets.dart';
import '../../screens.dart';

class TSISTaskTile extends StatelessWidget {
  final EcTSIS tsis;
  final List<EcEvent> event;
  TSISTaskTile({super.key, required this.tsis, required this.event});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getStatusColor(tsis.status),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TSIS# ${tsis.tsis_no}",
                  style: TextStyle(
                    fontSize: fontExtraSize,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01,),
                Text(
                  tsis.project,
                  style: TextStyle(
                    fontSize: fontNormalSize,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),

                Text(
                  "\t - ${tsis.problem}",
                  style: TextStyle(
                    fontSize: fontSmallSize,
                    letterSpacing: 0.5,
                    color: Colors.white
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                Text(
                  "Requestor : ",
                  style: TextStyle(
                    fontSize: fontSmallSize,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                RichText(
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    text:TextSpan(
                        children: <TextSpan> [
                          TextSpan(
                            text: '\t ${tsis.contact_person} | ${tsis.contact_number}',
                            style: TextStyle(
                              fontSize: fontSmallSize,
                              letterSpacing: 0.5,
                              color: Colors.white
                            ),
                          ),
                        ]
                    )
                ),

                SizedBox(height: screenHeight * 0.01,),
                if (event.isNotEmpty)
                  ...event.map((events) {
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
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              tsis.status.toUpperCase(),
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

  Color _getStatusColor(String status) {
    if (status == "Scheduled") {
      return Colors.orangeAccent;
    } else if (status == "Pending") {
      return Colors.blue;
    } else if (status == "Complete") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }
}