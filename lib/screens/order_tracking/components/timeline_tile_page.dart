import 'package:enye_app/screens/order_tracking/components/event_card.dart';
import 'package:enye_app/screens/order_tracking/components/time_card.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../widget/widgets.dart';

class TimelineTilePage extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final IconData icon;
  final imageIcon;
  final status;
  final payment_status;
  final remarks;
  final timeCard;

  const TimelineTilePage({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.icon,
    required this.imageIcon,
    required this.status,
    required this.payment_status,
    required this.remarks,
    required this.timeCard,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return SizedBox(
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? Colors.deepOrange.shade100 : Colors.deepOrange.shade300),
        indicatorStyle: IndicatorStyle(
          width: fontExtraSize * 1.5,
          color: icon == Icons.circle ? Colors.transparent
              : isPast ? Colors.deepOrange.shade100 : Colors.deepOrange.shade300,
          iconStyle: IconStyle(
            iconData: icon,
            fontSize: icon == Icons.circle ? fontExtraSize : fontExtraSize * 1.15,
            color: isPast
              ? icon == Icons.circle
                ? Colors.deepOrange.shade100
                : Colors.white
              : icon == Icons.circle
                ? Colors.deepOrange.shade300
                : Colors.white,
          )
        ),
        alignment: TimelineAlign.manual,
        lineXY: screenWidth >= 600 ? 0.15 : 0.2,
        startChild: TimeCardPage(
          isPast: isPast,
          child: timeCard,
        ),
        endChild: EventCardPage(
          isPast: isPast,
          child: Row(
            children: [
              Image(
                image: AssetImage(imageIcon),
                height: fontExtraSize * 2.5,
                width: fontExtraSize * 2.5,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                          letterSpacing: 0.8,
                          fontSize: fontSmallSize * 1.15,
                          fontWeight: FontWeight.bold,
                          color: isPast? Colors.deepOrange.shade700.withOpacity(0.75) : Colors.white
                      ),
                    ),

                    SizedBox(height: 2,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                            Icons.payments,
                            size: fontNormalSize,
                            color: isPast ? Colors.deepOrange.shade400.withOpacity(0.75) : Colors.white.withOpacity(0.75)
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                            payment_status,
                            style: TextStyle(
                                letterSpacing: 0.8,
                                fontSize: fontSmallSize,
                                color: isPast ? Colors.grey.shade700 : Colors.white.withOpacity(0.9)
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                            Icons.notes,
                            size: fontNormalSize,
                            color: isPast ? Colors.deepOrange.shade400.withOpacity(0.75) : Colors.white.withOpacity(0.75)
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                            remarks,
                            style: TextStyle(
                                letterSpacing: 0.8,
                                fontSize: fontSmallSize,
                                color: isPast ? Colors.grey.shade700 : Colors.white.withOpacity(0.9)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
