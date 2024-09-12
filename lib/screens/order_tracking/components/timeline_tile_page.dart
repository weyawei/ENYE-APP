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
  final eventCard;
  final timeCard;

  const TimelineTilePage({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.icon,
    required this.eventCard,
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
          color: isPast ? Colors.deepOrange.shade400 : Colors.deepOrange.shade100),
        indicatorStyle: IndicatorStyle(
          width: fontExtraSize * 2,
          color: icon == Icons.circle ? Colors.transparent
              : isPast ? Colors.deepOrange.shade400 : Colors.deepOrange.shade100,
          iconStyle: IconStyle(
            iconData: icon,
            fontSize: icon == Icons.circle ? fontExtraSize : fontExtraSize * 1.15,
            color: icon == Icons.circle ?
              Colors.deepOrange.shade100 :
              isPast ? Colors.white : Colors.deepOrange.shade300,
          )
        ),
        alignment: TimelineAlign.manual,
        lineXY: 0.2,
        startChild: TimeCardPage(
          isPast: isPast,
          child: timeCard,
        ),
        endChild: EventCardPage(
          isPast: isPast,
          child: eventCard,
        ),
      ),
    );
  }
}
