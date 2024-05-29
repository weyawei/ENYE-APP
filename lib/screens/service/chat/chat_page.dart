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
import '../status/SOPdfPage.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/status';

  RemoteMessage? message;

  ChatPage({required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => StatusPage(message: message,)
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
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
    _users = [];
    _position = [];
    _appointment = [];

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          ClientInfo = value;
          _getServices();
          _getServicess();
          _getUsers();
          _getPosition();
          _getAppointment();
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
    double screenHeight = MediaQuery.of(context).size.height;
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
        _services = technicalData.where((element) => element.status != "Completed" && element.status != "Cancelled").toList();
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


  List<TechnicalData> _filteredServices = [];
  void filterSystemsList() {
    _filteredServices = _services.where((technicalData) {
      final svcId = technicalData.svcId.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return svcId.contains(searchQuery);
    }).toList();
  }


  List<ServiceAppointment> _filteredService = [];
  void filterSystemsLists() {
    _filteredService = _appointment.where((ServiceAppointment) {
      final svcId = ServiceAppointment.svc_id.toLowerCase();
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

                      ServiceAppointment? appointment = _appointment.where((appoint) => _filteredServices[index].id == appoint.svc_id).elementAtOrNull(0);

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: TaskTiles(services: _filteredServices[index]),
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




}




class TaskTiles extends StatefulWidget {
  final TechnicalData services;
  const TaskTiles({super.key, required this.services});

  @override
  State<TaskTiles> createState() => _TaskTilesState();
}

class _TaskTilesState extends State<TaskTiles> {
  List<UserAdminData> _handler = [];

  _getServices(){
    if (widget.services.status != "Unread") {
      TechnicalDataServices.handlerData(widget.services.svcHandler).then((
          UserAdminData) {
        setState(() {
          _handler = UserAdminData;
        });
        print("Length ${UserAdminData.length}");
      });
    }
  }

  List<Position> _position = [];
  _getPositions(){
    TechnicalDataServices.getPositions().then((positions){
      setState(() {
        _position = positions;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    _getServices();
    _getPositions();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontExtra2Size = ResponsiveTextUtils.getXFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.020),
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight * 0.010),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getStatusColor(widget.services.status),
        ),
        child: Row(
            children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [

                    TextSpan(text: "${widget.services.reqName}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                  ]
                  ),
                ),

                SizedBox(height: screenHeight * 0.01,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [

                    TextSpan(text: "${widget.services.svcDesc}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: fontNormalSize, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                  ]
                  ),
                ),



              ],
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
    } else if (status == "Completed") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }
}
