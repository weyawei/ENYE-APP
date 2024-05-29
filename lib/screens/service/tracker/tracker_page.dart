import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Assuming you have a package or a custom widget for CasaVerticalStepper
import 'package:casa_vertical_stepper/casa_vertical_stepper.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> with TickerProviderStateMixin {

  // Custom icon for the stepper steps
  static Widget _checkBoxIcon({bool isOutline = false, Color? iconColor}) {
    return Icon(
      isOutline ? Icons.check_box_outline_blank : Icons.check_box,
      color: iconColor ?? Colors.green,
    );
  }


List<Step> steps() => [
  Step(
    title: Text("On Process",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    content: Align(
      alignment: Alignment.centerLeft,
      child: Text("2024/05/25 4:20 PM\nProducts has been Process !!",
      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
    ),
    isActive: true,
    label: Icon(Icons.shopping_basket),
  ),
  Step(
    title: Text("In Warehouse"),
    content: Align(
      alignment: Alignment.centerLeft,
      child: Text("2024/05/26 4:20 PM Products Arrived at Warehouse !!"),
    ),
    isActive: true,
  ),
  Step(
    title: Text("Preparing for Delivery"),
    content: Align(
      alignment: Alignment.centerLeft,
      child: Text("2024/05/27 4:20 PM Products are being Prepared !!"),
    ),
  ),
  Step(
    title: Text("Out For Delivery"),
    content: Align(
      alignment: Alignment.centerLeft,
      child: Text("2024/05/28 4:20 PM Products Ready To Dispatch !!"),
    ),
  ),
];

  @override
  Widget build(BuildContext context) {

    final stepperList = [
    StepperStep(
      title: Text('Account Details'),
      leading: _checkBoxIcon(),
      view: YourCustomViewHere(),
    ),
    StepperStep(
    title: Text('Application Review'),
    leading: _checkBoxIcon(isOutline: true, iconColor: Colors.blue),
    status: StepStatus.fail,
    view: YourCustomViewHere(),
    failedView: YourCustomFailViewHere(),
    ),
    ];


    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity, // Make the image container take full width
                  child: Image.asset(
                    "assets/icons/tracker.jpg",
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
                SizedBox(height: 11), // Add some space between the image and the text
                Text(
                  "Product Tracer",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Tracking Number:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1.0,          // Border width
                                style: BorderStyle.solid, // Border style: solid, dashed, or none
                              ),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "e.g #0123456789",
                                suffixIcon:  Icon(
                                  Icons.search,
                                  size: 35,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // Adjust space between text field and icon

                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
                    child: Column(
                      children: [
                        Text(
                          "Result:",
                          style: TextStyle(fontSize: 25),
                        ),
                        Stepper(
                          physics: ClampingScrollPhysics(),
                          steps: steps(),
                          controlsBuilder: (BuildContext context, ControlsDetails details) {
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// Replace these with your actual custom views
class YourCustomViewHere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Custom View Content");
  }
}

class YourCustomFailViewHere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Custom Fail View Content");
  }
}