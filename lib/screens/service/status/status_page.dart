import 'package:enye_app/screens/service/status/status_view_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class StatusPage extends StatefulWidget {
  static const String routeName = '/status';

  final RemoteMessage? message;

  StatusPage({required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => StatusPage(message: message,)
    );
  }

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> with TickerProviderStateMixin {
  clientInfo? ClientInfo;
  UserAdminData2? UserAdminInfo;
  bool? userSessionFuture;
  String? _dropdownError; //kapag wala pa na-select sa option

  final searchController = TextEditingController();
  final reasonController = TextEditingController();
  bool _isLoading = true;

  DateTimeRange? selectedDate;
  DateTime firstDate = DateTime.now().add(Duration(days: 5));
  DateTime lastDate = DateTime.now().add(Duration(days: 60));

  final TextEditingController note = TextEditingController();

  void initState(){
    super.initState();
    _services = [];
    _servicess = [];

    _ecUsers = [];
    _ecEvent = [];
    _ecSO = [];
    _ecTSIS = [];

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          ClientInfo = value;
          _getServices();
          _getServicess();

          _getEcUsers();
          _getEcEvent();
          _getEcSO();
          _getEcTSIS();
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });

    if(widget.message!.data["goToPage"] == "Status"){
      searchController.text = '${widget.message!.data["code"]}';
    }
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    reasonController.dispose();
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  //snackbars
  _custSnackbar(context, message, Color color, IconData iconData){
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: RichText(
          softWrap: true,
          text: TextSpan(
            children: <TextSpan> [
              TextSpan(
                text: message.toString().toUpperCase(),
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: fontNormalSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  late List<TechnicalData> _services;

  _getServices(){
    TechnicalDataServices.clientTechnicalData(ClientInfo!.client_id).then((technicalData){
      setState(() {
        _services = technicalData.where((element) => element.status != "Complete" && element.status != "Cancelled").toList();
      });
      _isLoading = false;
    });
  }

  late List<ServiceOrder> _servicess;

  _getServicess(){
    TechnicalDataServices.getServiceOrder().then((ServiceOrder){
      setState(() {
        _servicess = ServiceOrder.where((ServiceOrder) => ServiceOrder.stat == "Saved" || ServiceOrder.stat == "Completed").toList();
      });
    });
  }


  late List<EcUsers> _ecUsers;

  _getEcUsers(){
    ECTechnicalDataServices.getEcUsers().then((EcUsers){
      setState(() {
        _ecUsers = EcUsers;
      });
    });
  }

  late List<EcEvent> _ecEvent;

  _getEcEvent(){
    ECTechnicalDataServices.getEcEvents().then((EcEvent){
      setState(() {
        _ecEvent = EcEvent;
      });
    });
  }

  late List<EcSO> _ecSO;

  _getEcSO(){
    ECTechnicalDataServices.getEcSO().then((EcSO){
      setState(() {
        _ecSO = EcSO;
      });
    });
  }

  late List<EcTSIS> _ecTSIS;

  _getEcTSIS(){
    ECTechnicalDataServices.getEcTSIS().then((EcTSIS){
      setState(() {
        _ecTSIS = EcTSIS;
      });
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

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }

    return false;
  }

  _editToCancel(TechnicalData services){
    TechnicalDataServices.editCancelBooking(services.id, services.svcId, reasonController.text.trim()).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
        _getServicess();
        _custSnackbar(
          context,
          "Cancelled Booking Successfully",
          Colors.green,
          Icons.check
        );
        reasonController.text = '';
      } else {
        _custSnackbar(
            context,
            "Error occured...",
            Colors.redAccent,
            Icons.dangerous_rounded
        );
      }
    });
  }

  _editToAccepted(TechnicalData services){
    TechnicalDataServices.editToAccepted(
        services.id, services.svcId,
       /* DateFormat('yyyy-MM-dd').format(selectedDate!.start),
        DateFormat('yyyy-MM-dd').format(selectedDate!.end)*/).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
        sendPushNotifications("Accepted", services.svcId);
        _custSnackbar(
            context,
            "Booking successfully accepted.",
            Colors.green,
            Icons.check
        );
        _dropdownError = null;
      } else {
        _custSnackbar(
            context,
            "Error occured...",
            Colors.redAccent,
            Icons.dangerous_rounded
        );
      }
    });
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

  Future<void> sendPushNotifications(String status, String svcId) async {
    //final url = 'https://enye.com.ph/enyecontrols_app/login_user/send1.php'; // Replace this with the URL to your PHP script
    final response = await http.post(
      Uri.parse(API.pushNotif),
      body: {
        'action' : status,
        'svc_id' : svcId,
      },
    );
    if (response.statusCode == 200) {
      if(response.body == "success"){
        print('send push notifications.');
      }
    } else {
      print('Failed to send push notifications.');
    }
  }

 /* _editToResched(TechnicalData services){
    TechnicalDataServices.editToResched(
        services.id, services.svcId,
        DateFormat('yyyy-MM-dd').format(selectedDate!.start),
        DateFormat('yyyy-MM-dd').format(selectedDate!.end),
        note.text).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
        sendPushNotifications("Re-sched", services.svcId);
        _custSnackbar(
            context,
            "Booking successfully re-schedule. \n Wait someone to accept it",
            Colors.green,
            Icons.info
        );
        _dropdownError = null;
      } else {
        _custSnackbar(
            context,
            "Error occured...",
            Colors.redAccent,
            Icons.dangerous_rounded
        );
      }
    });
  }

  void _selectDate(BuildContext context, TechnicalData services, String accORresched, Function(DateTimeRange) onDateSelected) async {

    DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: accORresched == "Accept" ? DateTime.parse(services.sDateSched.toString()) : firstDate,
      lastDate: accORresched == "Accept" ? DateTime.parse(services.eDateSched.toString()) : lastDate,
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }*/

  /*void _showDatePicker(BuildContext context, TechnicalData services, String accORresched) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
        var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

        return Dialog(
          // Set dialog properties such as shape, elevation, etc.
          child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SizedBox(height: screenHeight * 0.02,),
                      _dropdownError == null
                          ? SizedBox.shrink()
                          : Text(
                        _dropdownError ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontNormalSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          letterSpacing: 0.8
                        ),
                      ),

                      accORresched == "Accept"
                       ? Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "For 1 day booking, \n choose the same day twice.",
                            style: TextStyle(
                              fontSize: fontNormalSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              letterSpacing: 0.8
                            ),
                          ),
                        )
                       : Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Available Date for you",
                            style: TextStyle(
                              fontSize: fontNormalSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              letterSpacing: 0.8
                            ),
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.01,),
                      //select date range of availability
                      InkWell(
                        onTap: () {
                          _selectDate(context, services, accORresched, (DateTimeRange pickedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,),
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,),
                          height: screenHeight * 0.065,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.deepOrange.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  selectedDate != null
                                      ? '${DateFormat('(EEE) MMM d, y').format(selectedDate!.start)} to ${DateFormat('(EEE) MMM d, y').format(selectedDate!.end)}'
                                      : 'Select Date *',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: fontNormalSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      letterSpacing: 0.8
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.deepOrange,
                                size: (screenHeight + screenWidth) / 45,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015,),
                      accORresched == "Re-sched"
                       ? NormalTextField(
                          controller: note,
                          hintText: 'Note',
                          disabling: false,
                        ) : SizedBox.shrink(),

                      SizedBox(height: screenHeight * 0.015,),
                      GestureDetector(
                        onTap: (){
                          if(accORresched == "Accept"){
                            if(selectedDate == null){
                              setState(() => _dropdownError = "Required Date");
                            } else {
                              _editToAccepted(services);
                              Navigator.pop(context);
                            }
                          } else {
                            if(selectedDate == null || note.text == "" || note.text.isEmpty){
                              setState(() => _dropdownError = "Required Date and notes");
                            } else {
                              _editToResched(services);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.deepOrangeAccent,
                          child: Center(
                            child: Text(
                              accORresched.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontExtraSize,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),
        );
      },
    ).whenComplete(() {
      selectedDate = null;
      note.text = '';
      _dropdownError = null;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    if(widget.message!.data["goToPage"] == "Status"){
      filterSystemsList();
    }

    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: CustomAppBar(title: 'Status', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        /*drawer: CustomDrawer(),*/
        body: _isLoading
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _getServices();
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
                          if(searchController.text.isEmpty){
                            FocusScope.of(context).unfocus();
                          }
                        });
                      },
                      onEditingComplete: (){
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
                      itemCount: searchController.text.isEmpty ? _services.length : _filteredServices.length,
                      itemBuilder: (_, index){
                        _filteredServices = searchController.text.isEmpty ? _services : _filteredServices;

                       /* ServiceAppointment? appointment = _appointment.where((appoint) => _filteredServices[index].id == appoint.svc_id).elementAtOrNull(0);

                        EcSO? ecServiceOrder = _ecSO.where((ecso) => _filteredServices[index].tsis_id == ecso.tsis_id).elementAtOrNull(0);
                        EcEvent? ecEvent = _ecEvent.where((ecevent) => _filteredServices[index].tsis_id == ecevent.tsis_id).elementAtOrNull(0);*/

                        TechnicalData service = _filteredServices[index];
                        EcTSIS? tsis = _ecTSIS.where((tsis) => tsis.tsis_id == service.tsis_id).elementAtOrNull(0);
                        List<EcEvent> events = _ecEvent.where((e) => e.tsis_id == service.tsis_id).toList();


                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if (_filteredServices[index].status == "Unread") {
                                        _showBottomSheet(context, service);
                                      }

                                      /*if (_filteredServices[index].status ==
                                          "Set-sched") {
                                        _showBottomSheet1(context,
                                            _filteredServices[index], ecServiceOrder!, ecEvent!);
                                      }

                                      if(_filteredServices[index].status == "On Process"){
                                        _showBottomSheet2(context, _filteredServices[index], ecServiceOrder!, ecEvent!);
                                      }*/

                                    if(tsis != null) {
                                      setState(() {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StatusViewPage(tsis: tsis,
                                                    events: events,
                                                    service: service,)),
                                        );
                                      });
                                    }else{
                                      Text('Null');
                                    }

                                    },
                                    child: TaskTile(services: service),
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






  _showBottomSheet (BuildContext context, TechnicalData services) {

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

               services.status == "Unread" ?
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "CANCEL",
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                        _showAnotherBottomSheet(context, services, "Cancel");
                      });
                    },
                    clr: Colors.redAccent,
                    context:context,
                  ),
                ): SizedBox.shrink(),

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







  _showBottomSheet1 (BuildContext context, TechnicalData services, EcSO ecso, EcEvent ecevent) {

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
                if (services.status == "Unread")
              //  services.status == "Unread" ?
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "CANCEL",
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                        _showAnotherBottomSheet(context, services, "Cancel");
                      });
                    },
                    clr: Colors.redAccent,
                    context:context,
                  ),
                ),//: SizedBox.shrink(),



             //   services.status == "Set-sched" ?

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
                                TextSpan(text: "Subject :  ",
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

                      SizedBox(height: screenHeight * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 18,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat.yMMMMd().format(DateTime.parse(ecso.time_in))} TO ${DateFormat.yMMMMd().format(DateTime.parse(ecso.time_out))}',
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
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat.jm().format(DateTime.parse(ecso.time_in))} - ${DateFormat.jm().format(DateTime.parse(ecso.time_out))}',
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


                // service.status == "On Process" ?
                SizedBox(height: screenHeight * 0.02,),
                ecevent.engineer.isNotEmpty || ecevent.engineer != ""
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
                          'Engineers',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 0.8,
                            color: Colors.white, // Optionally, set text color
                          ),
                        ),
                      ),
                    ),

                    ..._ecUsers.map((engineer) {
                      if(_isUserAssigned(ecevent.engineer, engineer.username)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: engineer.picture.isNotEmpty == true && engineer.picture != ""
                                      ? Image.network(API.ec_usersImg + engineer.picture).image
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
                                    TextSpan(text: engineer.username,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${engineer.role_type} ",
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
                                final phoneNumber  = engineer.mobile;
                                final url = 'tel:$phoneNumber';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.call, size: fontNormalSize,),
                              label: Text(engineer.mobile,
                                style: TextStyle(
                                  color: Colors.black54,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,),
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
                ecevent.technician.isNotEmpty || ecevent.technician != ""
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

                    ..._ecUsers.map((technician) {
                      if(_isUserAssigned(ecevent.technician, technician.username)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: technician.picture.isNotEmpty == true && technician.picture != ""
                                      ? Image.network(API.usersImages + technician.picture).image
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
                                    TextSpan(text: technician.username,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${technician.role_type}",
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
                                final phoneNumber  = technician.mobile;
                                final url = 'tel:$phoneNumber';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.call, size: fontNormalSize,),
                              label: Text(technician.mobile,
                                style: TextStyle(
                                  color: Colors.black54,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,),
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




                ..._servicess.map((ServiceOrder) {
                  if(ServiceOrder.svc_id == services.id) {
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SOPdfPreviewPage(so_id: ecso.so_id),
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
                            color: Colors.deepOrange.shade300,
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
                              color: Colors.deepOrange.shade300,
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
                if (services.status == "Set-sched")
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "ACCEPT",
                    onTap: (){
                      setState(() {
                        _editToAccepted(services);
                        Navigator.pop(context);
                      });
                    },
                    clr: Colors.green,
                    context:context,
                  ),
                ),

              /*  services.status == "Set-sched" ?
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "RE-SCHED",
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                        _showDatePicker(context, services, "Re-sched");
                      });
                    },
                    clr: Colors.redAccent,
                    context:context,
                  ),
                ): SizedBox.shrink(),*/

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

            /*Container(
            padding: const EdgeInsets.only(top: 4),
            width: screenWidth,
            height: services.status == "Set-sched"
                ? screenHeight * 0.34
                : screenHeight * 0.24,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.007,
                  width: screenWidth * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]
                  ),
                ),

                const Spacer(),
                Container(),

                services.status == "Unread" ?
                _bottomSheetButton(
                  label: "CANCEL",
                  onTap: (){
                    setState(() {
                      Navigator.pop(context);
                      _showAnotherBottomSheet(context, services, "Cancel");
                    });
                  },
                  clr: Colors.redAccent,
                  context:context,
                ): Container(),

                services.status == "Set-sched" ?
                _bottomSheetButton(
                  label: "ACCEPT",
                  onTap: (){
                    setState(() {
                      Navigator.pop(context);
                      _showDatePicker(context, services, "Accept");
                    });
                  },
                  clr: Colors.green,
                  context:context,
                ): Container(),

                services.status == "Set-sched" ?
                _bottomSheetButton(
                  label: "RE-SCHED",
                  onTap: (){
                    setState(() {
                      Navigator.pop(context);
                      _showDatePicker(context, services, "Re-sched");
                    });
                  },
                  clr: Colors.redAccent,
                  context:context,
                ): Container(),

                const SizedBox(height: 20,),
                _bottomSheetButton(
                  label: "CLOSE",
                  onTap: (){
                    Navigator.pop(context);
                  },
                  clr: Colors.orangeAccent,
                  context:context,
                  isClose: true,
                ),

                const SizedBox(height: 10,),
              ],
            ),
          );*/
        }
    );
  }




  _showBottomSheet2 (BuildContext context, TechnicalData service, EcSO ecso, EcEvent ecevent) {

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
                                TextSpan(text: "Subject :  ",
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
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat.yMMMMd().format(DateTime.parse(ecevent.start))} TO ${DateFormat.yMMMMd().format(DateTime.parse(ecevent.end))}',
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
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat.jm().format(DateTime.parse(ecevent.start))} - ${DateFormat.jm().format(DateTime.parse(ecevent.end))}',
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

                      SizedBox(height: screenHeight * 0.012,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Client Name : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${service.clientName}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Contact : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${service.clientContact}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Email : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: service.clientEmail,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),
                                //Text(services.svcDesc, maxLines: 5, softWrap: false,),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: screenWidth * 0.38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Project Name : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${service.clientProjName}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Company : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${service.clientCompany}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.0025,),
                                Text("Location : ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: fontXSmallSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                RichText(
                                  softWrap: true,
                                  text: TextSpan(text: "\t${service.clientLocation}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: fontSmallSize,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


               // service.status == "On Process" ?
                SizedBox(height: screenHeight * 0.02,),
                ecevent.engineer.isNotEmpty || ecevent.engineer != ""
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
                          'Engineers',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 0.8,
                            color: Colors.white, // Optionally, set text color
                          ),
                        ),
                      ),
                    ),

                    ..._ecUsers.map((engineer) {
                      if(_isUserAssigned(ecevent.engineer, engineer.username)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: engineer.picture.isNotEmpty == true && engineer.picture != ""
                                      ? Image.network(API.ec_usersImg + engineer.picture).image
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
                                    TextSpan(text: engineer.username,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${engineer.role_type}",
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
                                final phoneNumber  = engineer.mobile;
                                final url = 'tel:$phoneNumber';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.call, size: fontNormalSize,),
                              label: Text(engineer.mobile,
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
                ecevent.technician.isNotEmpty || ecevent.technician != ""
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

                    ..._ecUsers.map((technician) {
                      if(_isUserAssigned(ecevent.technician, technician.username)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: (screenWidth + screenHeight) / 25,
                              height: (screenWidth + screenHeight) / 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: technician.picture.isNotEmpty == true && technician.picture != ""
                                      ? Image.network(API.ec_usersImg + technician.picture).image
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
                                    TextSpan(text: technician.username,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: fontSmallSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),

                                    TextSpan(text: "\n${technician.role_type} ",
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
                                final phoneNumber  = technician.mobile;
                                final url = 'tel:$phoneNumber';

                                _launchURL(url);
                              },
                              icon: Icon(Icons.call, size: fontNormalSize,),
                              label: Text(technician.mobile,
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


                ..._ecSO.map((Ecso) {
                  if(Ecso.tsis_id == service.tsis_id) {
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SOPdfPreviewPage(so_id: ecso.so_id),
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
                            "SO# " + Ecso.so_no + " - " +
                                Ecso.date_so,
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




  String? valueChooseAccount;
  _showAnotherBottomSheet (BuildContext context, TechnicalData services, String whatToDo) {
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;

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

                SizedBox(height: screenHeight * 0.04,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Title :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: services.svcTitle,
                                  style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Description :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: services.svcDesc,
                                  style: TextStyle(fontSize: fontExtraSize, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Requestor Name :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: services.reqName,
                                  style: TextStyle(fontSize: fontExtraSize, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Designation :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: services.reqPosition,
                                  style: TextStyle(fontSize: fontExtraSize, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),
                    ],
                  ),
                ),

                //save data into Task Completed
                whatToDo == "Cancel"
                    ? StatefulBuilder(
                    builder: (BuildContext context, setState){
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                          child: Column(
                            children: [

                              //drop-down button
                              SizedBox(height: screenHeight * 0.01,),
                              NormalTextField(
                                controller: reasonController,
                                hintText: 'Reason *',
                                disabling: false,
                              ),

                              _dropdownError == null
                                  ? const SizedBox.shrink()
                                  : Center(
                                child: Text(
                                  _dropdownError ?? "",
                                  style: TextStyle(fontSize: fontNormalSize, color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),

                              //save button for acknowledge
                              const SizedBox(height: 20,),
                              _bottomSheetButton(
                                label: "Cancel Booking",
                                onTap: (){
                                  setState(() {
                                    if (reasonController.text.trim().isEmpty) {
                                      setState(() => _dropdownError = "Fill out the fields!");
                                    } else {
                                      setState(() {
                                        _editToCancel(services);
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  });
                                },
                                clr: Colors.redAccent,
                                context:context,
                              ),
                            ],
                          )
                      );
                    }
                )
                    : const SizedBox.shrink(),

                SizedBox(height: screenHeight * 0.02,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "Close",
                    onTap: (){
                      _dropdownError = null;
                      valueChooseAccount = null;
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
    ).whenComplete(() {
      valueChooseAccount = null;
      _dropdownError = null;
    });
  }




  String? valueChooseAccount1;
  _showServiceOrder (BuildContext context, TechnicalData service, String whatToDo) {
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;

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

                SizedBox(height: screenHeight * 0.04,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Title :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: _servicess.where((serviceOrder) => serviceOrder.svc_id == service.id).elementAt(0).project,
                                  style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Description :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: _servicess.where((serviceOrder) => serviceOrder.svc_id == service.id).elementAt(0).project,
                                  style: TextStyle(fontSize: fontExtraSize, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),

                      SizedBox(height: screenHeight * 0.01,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Requestor Name :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: _servicess.where((serviceOrder) => serviceOrder.svc_id == service.id).elementAt(0).project,
                                  style: TextStyle(fontSize: fontExtraSize, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),



                      SizedBox(height: screenHeight * 0.01,),
                      RichText(
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          text:TextSpan(
                              children: <TextSpan> [
                                TextSpan(text: "Designation :  ",
                                  style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),

                                TextSpan(text: _servicess.where((serviceOrder) => serviceOrder.svc_id == service.id).elementAt(0).project,
                                  style: TextStyle(fontSize: fontExtraSize, color: Colors.black54, letterSpacing: 0.8),),
                              ]
                          )
                      ),
                    ],
                  ),
                ),



                SizedBox(height: screenHeight * 0.02,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "Close",
                    onTap: (){
                      _dropdownError = null;
                      valueChooseAccount = null;
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
    ).whenComplete(() {
      valueChooseAccount = null;
      _dropdownError = null;
    });
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

