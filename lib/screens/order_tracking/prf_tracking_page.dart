import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class PrfTrackingPage extends StatefulWidget {
  @override
  _PrfTrackingPageState createState() => _PrfTrackingPageState();
}

class _PrfTrackingPageState extends State<PrfTrackingPage> {
  int _currentStep = 0;

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
          'PO# SYNC-24-06',
          style: TextStyle(
            fontSize: fontNormalSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PRF #",
                  style: TextStyle(
                    fontSize: fontExtraSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "2024-4197-e",
                  style: TextStyle(
                    fontSize: fontExtraSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            initiallyExpanded: true,
            children: [
              Stepper(
                currentStep: _currentStep,
                onStepTapped: null,
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  // Custom controls or hide the default controls
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (details.onStepContinue != null)
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text('Continue'),
                        ),
                      SizedBox(width: 8),
                      if (details.onStepCancel != null)
                        ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: Text('Cancel'),
                        ),
                    ],
                  );
                },
                steps: [
                  Step(
                    title: Text('Approved by Logistics'),
                    subtitle: Text("04 Apr 2024 10:58 AM"),
                    content: Text(''),
                    isActive: true,
                  ),
                  Step(
                    title: Text('Checked by Logistics'),
                    subtitle: Text("27 Mar 2024 01:48 PM"),
                    content: Text(''),
                    isActive: false,
                  ),
                  Step(
                    title: Text('Noted by Sales Manager'),
                    subtitle: Text("26 Mar 2024 03:46 PM"),
                    content: Text(''),
                    isActive: false,
                  ),
                  Step(
                    title: Text('Filed by Sales'),
                    subtitle: Text("11 Mar 2024 02:55 PM"),
                    content: Text(''),
                    isActive: false,
                  )
                ],
                stepIconBuilder: (index, state) {
                  // Customize step icon
                  return Center(
                    child: _currentStep == index
                        ? Icon(Icons.check, size: fontNormalSize, color: Colors.white)
                        : SizedBox.shrink(),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}