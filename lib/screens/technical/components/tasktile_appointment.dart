import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widget/widgets.dart';
import '../../screens.dart';

class TaskTileAppointment extends StatelessWidget {
  final EngTSIS? tsis_events;
  final TechnicalData services;
  TaskTileAppointment({super.key, this.tsis_events, required this.services});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
          color: _getStatusColor(services.status),
        ),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${services.svcId}",
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
                    "${services.service} - (${services.svcTitle})",
                    style: TextStyle(
                        fontSize: fontNormalSize * 0.9,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),

                  Text(
                    "\t - ${services.svcDesc}",
                    style: TextStyle(
                        fontSize: fontNormalSize * 0.9,
                        letterSpacing: 0.5,
                        color: Colors.white
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01,),
                  Text(
                    "Project : ",
                    style: TextStyle(
                        fontSize: fontNormalSize * 0.9,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    "\t ${services.clientProjName} || ${services.clientCompany}  || ${services.clientLocation}",
                    style: TextStyle(
                        fontSize: fontNormalSize * 0.9,
                        color: Colors.grey[100],
                        letterSpacing: 0.8
                    ),
                  ),

                  tsis_events == null
                  ? SizedBox.shrink()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.01,),
                      Text(
                        "Requestor : ",
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.9,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        "\t ${tsis_events?.contact_person} | ${tsis_events?.contact_number}",
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.9,
                            color: Colors.grey[100],
                            letterSpacing: 0.8
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      if (tsis_events!.events.isNotEmpty)
                        ...?tsis_events?.events.map((events) {
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[100]
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 110,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              services.status.toUpperCase(),
              style: TextStyle(
                  fontSize: fontNormalSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8
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