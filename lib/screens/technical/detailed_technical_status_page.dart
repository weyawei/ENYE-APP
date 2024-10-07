import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../screens.dart';

class DetailedTechnicalStatusPage extends StatefulWidget {
  final EngTSIS tsis_events;
  final String appointment_no;

  const DetailedTechnicalStatusPage({super.key, required this.tsis_events, required this.appointment_no});

  @override
  State<DetailedTechnicalStatusPage> createState() => _DetailedTechnicalStatusPageState();
}

class _DetailedTechnicalStatusPageState extends State<DetailedTechnicalStatusPage> {

  bool _isLoadingAcc = true;
  bool _isLoadingSO = true;

  bool? userSessionFuture;
  double? _progress;

  @override
  void initState() {
    super.initState();
    _engUsers = [];
    _serviceOrder = [];

    _getEngAccounts();
    _getServiceOrder();
  }

  late List<EcUsers> _engUsers;
  _getEngAccounts(){
    EngineeringServices.getEngineeringUsers().then((EcUsers){
      setState(() {
        _engUsers = EcUsers;
      });
      _isLoadingAcc = false;
    });
  }

  late List<EcSO> _serviceOrder;
  _getServiceOrder(){
    EngineeringServices.getSOtsisid(widget.tsis_events.tsis_id).then((EcSO){
      setState(() {
        _serviceOrder = EcSO.where((so) => so.stat == "Save" || so.stat == "Completed" || so.stat == "Complete").toList();
      });
      _isLoadingSO = false;
    });
  }

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return Scaffold(
      appBar: CustomAppBar(title: 'Booking System', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery
          .of(context)
          .size
          .height * 0.05,),
      resizeToAvoidBottomInset: true,
      body: _isLoadingAcc || _isLoadingSO
      ? Center(child: CircularProgressIndicator(),)
      : ListView(
        children: [
          SizedBox(height: screenHeight * 0.03),
          Center(
            child: Text(
              widget.appointment_no == '' ? "TSIS# ${widget.tsis_events.tsis_no}" : "#${widget.appointment_no.toUpperCase()}",
              style: GoogleFonts.rowdies(
                textStyle: TextStyle(
                    fontSize: fontXSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                )
              )
            ),
          ),

          SizedBox(height: screenHeight * 0.025,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Project :  ",
                      style: TextStyle(
                          fontSize: fontSmallSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.grey
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.tsis_events.project,
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.85,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location :  ",
                      style: TextStyle(
                          fontSize: fontSmallSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.grey
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.tsis_events.location,
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.85,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subject :  ",
                      style: TextStyle(
                          fontSize: fontSmallSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.grey
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.tsis_events.subject,
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.85,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Problem :  ",
                      style: TextStyle(
                          fontSize: fontSmallSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.grey
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${widget.tsis_events.problem}",
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.85,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ],
                ),

                if(widget.tsis_events.remarks.isNotEmpty || widget.tsis_events.remarks != "")
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.01,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Remarks :  ",
                          style: TextStyle(
                              fontSize: fontSmallSize,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Colors.grey
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${widget.tsis_events.remarks}",
                            style: TextStyle(
                                fontSize: fontNormalSize * 0.85,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                color: Colors.black54
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: screenHeight * 0.01,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client : ',
                      style: TextStyle(
                          fontSize: fontSmallSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.grey
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${widget.tsis_events.client_name}  | ${widget.tsis_events.contact_person} | ${widget.tsis_events.contact_number} | ${widget.tsis_events.email}",
                        style: TextStyle(
                            fontSize: fontNormalSize * 0.85,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: Colors.black54
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          widget.tsis_events.events.isNotEmpty
          ? Column(
            children: [
              SizedBox(height: screenHeight * 0.02,),
              ...widget.tsis_events.events.map((event) => ExpansionTile(
                childrenPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                initiallyExpanded: true,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.deepOrange,
                      size: fontNormalSize * 1.5,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      '${DateFormat.yMMMd().format(DateTime.parse(event.start))} TO ${DateFormat.yMMMd().format(DateTime.parse(event.end))}',
                      style: TextStyle(
                          fontSize: fontSmallSize,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                children: [
                  event.engineer.isNotEmpty || event.engineer != ""
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.0075, horizontal: screenWidth * 0.1),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.shade300,
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(color: Colors.white70, width: 1.5),
                          ),
                          child: Text(
                            'Engineers',
                            style: TextStyle(
                              fontSize: fontSmallSize,
                              letterSpacing: 0.8,
                              color: Colors.white, // Optionally, set text color
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01,),

                      ..._engUsers.map((engineer) {
                        if(_isUserAssigned(event.engineer, engineer.username)) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: fontNormalSize * 4,
                                height: fontNormalSize * 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: engineer.picture.isNotEmpty == true && engineer.picture != ""
                                        ? Image.network(API.ec_usersImg + engineer.picture).image
                                        : const AssetImage("assets/icons/user.png"),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    final phoneNumber = engineer.mobile;
                                    final url = 'tel:$phoneNumber';

                                    launchURL(url);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                                      children: <Widget>[
                                        Text(
                                          "${engineer.firstname} ${engineer.lastname}",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 4), // Add space between text elements
                                        Text(
                                          "${engineer.role_type}",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 4), // Add space between text elements
                                        Text(
                                          "${engineer.mobile}",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }).toList(),

                      if (_engUsers.every((engineer) => !_isUserAssigned(event.engineer, engineer.username)))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: fontNormalSize * 4.5,
                              height: fontNormalSize * 4.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: const AssetImage("assets/icons/user-empty.png"),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                                  children: <Widget>[
                                    Text(
                                      event.engineer,
                                      style: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 4), // Add space between text elements
                                    Text(
                                      "Resigned",
                                      style: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: screenHeight * 0.01,),
                    ],
                  )
                  : const SizedBox.shrink(),

                  event.technician.isNotEmpty || event.technician != ""
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.shade300,
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(color: Colors.white70, width: 1.5),
                          ),
                          child: Text(
                            'Technicians',
                            style: TextStyle(
                              fontSize: fontSmallSize,
                              letterSpacing: 0.8,
                              color: Colors.white, // Optionally, set text color
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01,),

                      ..._engUsers.map((technician) {
                        if(_isUserAssigned(event.technician, technician.username)) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: fontNormalSize * 4,
                                height: fontNormalSize * 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: technician.picture.isNotEmpty == true && technician.picture != ""
                                        ? Image.network(API.ec_usersImg + technician.picture).image
                                        : const AssetImage("assets/icons/user.png"),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    final phoneNumber = technician.mobile;
                                    final url = 'tel:$phoneNumber';

                                    launchURL(url);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                                      children: <Widget>[
                                        Text(
                                          "${technician.firstname} ${technician.lastname}",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 4), // Add space between text elements
                                        Text(
                                          "${technician.role_type}",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 4), // Add space between text elements
                                        Text(
                                          "${technician.mobile}",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }).toList(),

                      if (_engUsers.every((technician) => !_isUserAssigned(event.technician, technician.username)))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: fontNormalSize * 4.5,
                              height: fontNormalSize * 4.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: const AssetImage("assets/icons/user-empty.png"),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                                  children: <Widget>[
                                    Text(
                                      event.technician,
                                      style: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 4), // Add space between text elements
                                    Text(
                                      "Resigned",
                                      style: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: screenHeight * 0.01,),
                    ],
                  )
                      : const SizedBox.shrink(),

                  Center(
                    child: Wrap(
                      children: <Widget>[
                        ..._serviceOrder.map((serviceOrder) {
                          if (serviceOrder.tsis_id == widget.tsis_events.tsis_id && serviceOrder.event_id == event.id) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ServiceOrderPage(so_id: serviceOrder.so_id),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.download_for_offline_rounded,
                                        color: Colors.white,
                                        size: fontNormalSize, // Specify your desired icon size
                                      ),
                                    ),
                                    Text(
                                      "SO# ${serviceOrder.so_no}",
                                      style: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }).toList()
                      ],
                    ),
                  ),
                  Center(
                    child: Wrap(
                      children: <Widget>[
                        ..._serviceOrder.map((serviceOrder) {
                          if (serviceOrder.coc == "" || serviceOrder.coc.isEmpty) {
                            return const SizedBox.shrink();
                          } else {
                            if (serviceOrder.tsis_id == widget.tsis_events.tsis_id && serviceOrder.event_id == event.id){
                              return _progress != null
                                  ? SizedBox(
                                width: screenWidth * 0.1,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                                  : GestureDetector(
                                onTap: () {
                                  String url = API.ECcompAtt + serviceOrder.coc.toString();

                                  FileDownloader.downloadFile(
                                      url: url.trim(),
                                      onProgress: (name, progress) {
                                        setState(() {
                                          _progress = progress;
                                        });
                                      },
                                      onDownloadCompleted: (value) {
                                        print('path  $value ');
                                        custSnackbar(
                                            context,
                                            "File successfully downloaded.",
                                            Colors.green,
                                            Icons.check_box,
                                            Colors.white
                                        );
                                        setState(() {
                                          _progress = null;
                                        });
                                      });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: fontSmallSize * 1.7,
                                        backgroundColor: Colors.green.shade100,
                                        child: Icon(Icons.insert_drive_file, color: Colors.green, size: fontSmallSize * 1.5),
                                      ),
                                      SizedBox(width: screenWidth * 0.05,),
                                      Expanded(
                                        child: Text(
                                          "${serviceOrder.coc} (Attached File)",
                                          style: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        }).toList()
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02,),
                ],
              )).toList()
            ],
          )
          : SizedBox.shrink(),

          SizedBox(height: screenHeight * 0.05,),
        ],
      ),
    );
  }
}