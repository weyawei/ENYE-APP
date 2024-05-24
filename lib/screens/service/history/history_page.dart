import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';
import '../status/SOPdfPage.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = '/status';

  RemoteMessage? message;

  HistoryPage({required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => StatusPage(message: message,)
    );
  }

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  clientInfo? ClientInfo;
  bool? userSessionFuture;
  final searchController = TextEditingController();
  bool _isLoading = true;

  void initState(){
    super.initState();
    _services = [];
    _users = [];
    _position = [];
    _appointment = [];
    _servicess = [];

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          ClientInfo = value;
          _getServices();
          _getAppointment();
          _getPosition();
          _getServicess();
          _getUsers();
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });

    if(widget.message!.data["goToPage"] == "Completed"){
      searchController.text = '${widget.message!.data["code"]}';
    }
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  late List<TechnicalData> _services;

  _getServices(){
    TechnicalDataServices.clientTechnicalData(ClientInfo!.client_id).then((technicalData){
      setState(() {
        _services = technicalData.where((element) => element.status == "Completed" || element.status == "Cancelled").toList();
      });
      _isLoading = false;
    });
  }

  List<TechnicalData> _filteredServices = [];
  void filterSystemsList() {
    _filteredServices = _services.where((technicalData) {
      final svcId = technicalData.svcId.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return svcId.contains(searchQuery);
    }).toList();
  }


  late List<ServiceOrder> _servicess;

  _getServicess(){
    TechnicalDataServices.getServiceOrder().then((ServiceOrder){
      setState(() {
        _servicess = ServiceOrder.where((ServiceOrder) => ServiceOrder.stat == "Saved" || ServiceOrder.stat == "Completed").toList();
      });
    });
  }

  late List<UserAdminData2> _users;

  _getUsers(){
    TechnicalDataServices.handlerData2().then((UserAdminData2){
      setState(() {
        _users = UserAdminData2;
      });
    });
  }


  late List<Position> _position;

  _getPosition(){
    TechnicalDataServices.getPositions().then((Position){
      setState(() {
        _position = Position;
      });
    });
  }

  late List<ServiceAppointment> _appointment;

  _getAppointment(){
    TechnicalDataServices.getServiceAppoint().then((ServiceAppointment){
      setState(() {
        _appointment = ServiceAppointment;
      });
    });
  }


  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }

    return false;
  }



  Future<void> _launchURL (String url) async{
    try {
      bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }



  bool _isDownloading = false;
  double? _progress;
  String _filePath = '';

  _custSnackbar(context, message, Color color, IconData iconData){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.82),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
          content: Row(
            children: [
              Icon(
                iconData,
                color: Colors.white,
                size: (screenHeight + screenWidth) / 50,
              ),
              SizedBox(width: screenWidth * 0.01,),
              Expanded(
                child: RichText(
                  softWrap: true,
                  textAlign: TextAlign.start,
                  text: TextSpan(children: <TextSpan>
                  [
                    TextSpan(
                      text: message,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: fontNormalSize,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ]
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (widget.message!.data["goToPage"] == "Completed") {
      filterSystemsList();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'History', imagePath: '', appBarHeight: MediaQuery
            .of(context)
            .size
            .height * 0.05,),
        /*drawer: CustomDrawer(),*/
        body: _isLoading
            ? Center(child: SpinningContainer(controller: _controller),)
            : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getServices();
              _getAppointment();
              _getPosition();
              _getServicess();
              _getUsers();

            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search SERVICE #',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        FocusScope.of(context).unfocus();
                        filterSystemsList();
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null, // Set suffixIcon to null when text is empty
                  ),
                  onChanged: (value) {
                    setState(() {
                      filterSystemsList();
                      if (searchController.text.isEmpty) {
                        FocusScope.of(context).unfocus();
                      }
                    });
                  },
                  onEditingComplete: () {
                    filterSystemsList();
                  },
                ),
              ),

              SizedBox(height: 25,),
              _services.isEmpty
                  ? Expanded(
                child: Container(
                  child: Center(
                    child: (Text(
                      "No Data Available",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey
                      ),
                    )),
                  ),
                ),
              )
                  : Expanded(
                child: ListView.builder(
                    itemCount: searchController.text.isEmpty
                        ? _services.length
                        : _filteredServices.length,
                    itemBuilder: (_, index) {
                      _filteredServices = searchController.text.isEmpty
                          ? _services
                          : _filteredServices;
                      ServiceAppointment? appointment = _appointment.where((appoint) => _filteredServices[index].id == appoint.svc_id).elementAtOrNull(0);

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //_showBottomSheet(context, services);
                                    if (_filteredServices[index].status ==
                                        "Cancelled") {
                                      _showBottomSheet1(context,
                                          _filteredServices[index]);
                                    }

                                    if (_filteredServices[index].status ==
                                        "Completed") {
                                      _showBottomSheet2(context,
                                          _filteredServices[index], appointment!);
                                    }
                                  },
                                  child: TaskTile(
                                      services: _filteredServices[index]),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





  _showBottomSheet1 (BuildContext context, TechnicalData services) {

    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;

          var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
          var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
          var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);

          EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
          return Padding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: MasonryGridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              children: <Widget> [
                Container(
                  height: screenHeight * 0.007,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      top: 4
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]
                  ),
                ),

                SizedBox(height: screenHeight * 0.04,),

                SizedBox(height: screenHeight * 0.03,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Title :  ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),

                                TextSpan(text: services.svcTitle,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontNormalSize,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.005,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Description :  ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),

                                TextSpan(text: services.svcDesc,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.8,
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.005,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(
                                  text: 'Requestor : ',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),

                                TextSpan(
                                  text: '${services.reqName} | ${services.reqPosition}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontSmallSize,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.8,
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(16.0), // Margin around the box
                  padding: EdgeInsets.all(16.0), // Padding inside the box
                  decoration: BoxDecoration(
                    color: Colors.red[200], // Background color of the box
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, // Shadow color
                        blurRadius: 4.0, // Shadow blur radius
                        offset: Offset(2, 2), // Shadow offset
                      ),
                    ],
                  ),
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "REASON FOR CANCELLATION: ",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.white, // Darker color for better readability
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "\n ${services.notesComplete}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.white, // Darker color for better readability
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



                const SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "CLOSE",
                    onTap: (){
                      Navigator.pop(context);
                    },
                    clr: Colors.orangeAccent,
                    context:context,
                    isClose: true,
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
              ],
            ),
          );
        }
    );
  }






  _showBottomSheet2 (BuildContext context, TechnicalData service, ServiceAppointment appointment) {

  showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
        var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
        var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
        var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

        EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: MasonryGridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            children: <Widget> [
              Container(
                height: screenHeight * 0.007,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    top: 4
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]
                ),
              ),


              SizedBox(height: screenHeight * 0.03,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        softWrap: true,
                        text:TextSpan(
                            children: <TextSpan> [
                              TextSpan(text: "Title :  ",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontXSmallSize,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: Colors.grey
                                  ),
                                ),
                              ),

                              TextSpan(text: service.svcTitle,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontNormalSize,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),

                    SizedBox(height: screenHeight * 0.005,),
                    RichText(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        text:TextSpan(
                            children: <TextSpan> [
                              TextSpan(text: "Description :  ",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontXSmallSize,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: Colors.grey
                                  ),
                                ),
                              ),

                              TextSpan(text: service.svcDesc,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontSmallSize,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),

                    SizedBox(height: screenHeight * 0.005,),
                    RichText(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        text:TextSpan(
                            children: <TextSpan> [
                              TextSpan(
                                text: 'Requestor : ',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontXSmallSize,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: Colors.grey
                                  ),
                                ),
                              ),

                              TextSpan(
                                text: '${service.reqName} | ${service.reqPosition}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: fontSmallSize,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),

                    SizedBox(height: screenHeight * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.yMMMMd().format(DateTime.parse(appointment.start_datetime))} TO ${DateFormat.yMMMMd().format(DateTime.parse(appointment.end_datetime))}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: fontSmallSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.005,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_filled_rounded,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.jm().format(DateTime.parse(appointment.start_datetime))} - ${DateFormat.jm().format(DateTime.parse(appointment.end_datetime))}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: fontSmallSize,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),



              SizedBox(height: screenHeight * 0.04,),

              // service.status == "On Process" ?
              SizedBox(height: screenHeight * 0.02,),
              appointment.engineer.isNotEmpty || appointment.engineer != ""
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
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

                  ..._users.map((engineer) {
                    if(_isUserAssigned(appointment.engineer, engineer.user_id)) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: (screenWidth + screenHeight) / 25,
                            height: (screenWidth + screenHeight) / 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: engineer.image.isNotEmpty == true && engineer.image != ""
                                    ? Image.network(API.usersImages + engineer.image).image
                                    : const AssetImage("assets/icons/user.png"),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(children: <TextSpan>
                                [
                                  TextSpan(text: engineer.name,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),

                                  TextSpan(text: "\n${_position.where((position) => position.id == engineer.position).elementAtOrNull(0)?.position}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontXSmallSize,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ]
                                ),
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: (){
                              final phoneNumber  = engineer.contact;
                              final url = 'tel:$phoneNumber';

                              _launchURL(url);
                            },
                            icon: Icon(Icons.call, size: fontNormalSize, color: Colors.green,),
                            label: Text(engineer.contact,
                              style: TextStyle(
                                color: Colors.black54,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.visible,),
                            ),
                          )
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList(),
                ],
              )
                  : const SizedBox.shrink(),


              SizedBox(height: screenHeight * 0.01,),
              appointment.technician.isNotEmpty || appointment.technician != ""
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.1),
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
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

                  ..._users.map((technician) {
                    if(_isUserAssigned(appointment.technician, technician.user_id)) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: (screenWidth + screenHeight) / 25,
                            height: (screenWidth + screenHeight) / 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: technician.image.isNotEmpty == true && technician.image != ""
                                    ? Image.network(API.usersImages + technician.image).image
                                    : const AssetImage("assets/icons/user.png"),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(children: <TextSpan>
                                [
                                  TextSpan(text: technician.name,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),

                                  TextSpan(text: "\n${_position.where((position) => position.id == technician.position).elementAtOrNull(0)?.position}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontXSmallSize,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ]
                                ),
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: (){
                              final phoneNumber  = technician.contact;
                              final url = 'tel:$phoneNumber';

                              _launchURL(url);
                            },
                            icon: Icon(Icons.call, size: fontNormalSize, color: Colors.green),
                            label: Text(technician.contact,
                              style: TextStyle(
                                color: Colors.black54,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.visible,),
                            ),
                          )
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList(),
                ],
              )
                  : const SizedBox.shrink(),

              SizedBox(height: screenHeight * 0.01,),
              appointment.in_charge.isNotEmpty || appointment.in_charge != ""
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.15),
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.white70, width: 1.5),
                      ),
                      child: Text(
                        'Person In Charge',
                        style: TextStyle(
                          fontSize: fontSmallSize,
                          letterSpacing: 0.8,
                          color: Colors.white, // Optionally, set text color
                        ),
                      ),
                    ),
                  ),

                  ..._users.map((incharge) {
                    if(_isUserAssigned(appointment.in_charge, incharge.user_id)) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: (screenWidth + screenHeight) / 25,
                            height: (screenWidth + screenHeight) / 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: incharge.image.isNotEmpty == true && incharge.image != ""
                                    ? Image.network(API.usersImages + incharge.image).image
                                    : const AssetImage("assets/icons/user.png"),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(children: <TextSpan>
                                [
                                  TextSpan(text: incharge.name,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),

                                  TextSpan(text: "\n${_position.where((position) => position.id == incharge.position).elementAtOrNull(0)?.position}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontXSmallSize,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ]
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
                ],
              )
                  : const SizedBox.shrink(),


              ..._servicess.map((ServiceOrder) {
                if(ServiceOrder.svc_id == service.id) {
                  return TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SOPdfPreviewPage(serviceOrder: ServiceOrder),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // Use min to prevent the Row from occupying more space than its children need.
                      children: <Widget>[
                        Icon(
                          Icons.download_for_offline_rounded,
                          color: Colors.green,
                          size: (screenHeight + screenWidth) / 40,
                        ), // Example icon
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "SO# " + ServiceOrder.so_no + " - " +
                              ServiceOrder.date_so,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 12,
                            fontFamily: 'Rowdies',
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }).toList(),


              SizedBox(height: screenHeight * 0.01,),
              if (appointment.attach_file == "" || appointment.attach_file.isEmpty)
                const SizedBox.shrink()
              else
                _progress != null
                    ? SizedBox(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.1,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    String url = API.attachfile + appointment.attach_file.toString();

                    FileDownloader.downloadFile(
                        url: url.trim(),
                        onProgress: (name, progress) {
                          setState(() {
                            _progress = progress;
                          });
                        },
                        onDownloadCompleted: (value) {
                          print('path  $value ');
                          _custSnackbar(
                              context,
                              "File successfully downloaded.",
                              Colors.green,
                              Icons.check_box
                          );
                          setState(() {
                            _progress = null;
                          });
                        });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: fontSmallSize * 1.7,
                          backgroundColor: Colors.green.shade100,
                          child: Icon(Icons.insert_drive_file, color: Colors.green, size: fontSmallSize * 1.5),
                        ),
                        SizedBox(width: screenWidth * 0.05,),
                        Expanded(
                          child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.start,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(
                                text: "${appointment.attach_file} (Attached File)",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: fontXSmallSize,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          Container(
              margin: EdgeInsets.all(16.0), // Margin around the box
              padding: EdgeInsets.all(16.0), // Padding inside the box
              decoration: BoxDecoration(
              color: Colors.green[200], // Background color of the box
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              boxShadow: [
               BoxShadow(
               color: Colors.black12, // Shadow color
               blurRadius: 4.0, // Shadow blur radius
               offset: Offset(2, 2), // Shadow offset
                ),
               ],
              ),
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "NOTES : ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.grey[800], // Darker color for better readability
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: "\n${service.notesComplete}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.grey[800], // Darker color for better readability
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ),

              const SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: _bottomSheetButton(
                  label: "CLOSE",
                  onTap: (){
                    Navigator.pop(context);
                  },
                  clr: Colors.orangeAccent,
                  context:context,
                  isClose: true,
                ),
              ),

              SizedBox(height: screenHeight * 0.01,),
            ],
          ),
        );
      }
  );
}


  _bottomSheetButton ({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context
  }) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: screenHeight * 0.07,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: isClose == true ? Colors.grey.shade300 : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? GoogleFonts.lato(textStyle: TextStyle(fontSize: fontExtraSize, letterSpacing: 0.5, fontWeight: FontWeight.bold, color: Colors.black),)
                : GoogleFonts.lato(textStyle: TextStyle(fontSize: fontExtraSize, letterSpacing: 0.5, fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ),
      ),
    );
  }


}