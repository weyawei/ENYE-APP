import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class StatusPage extends StatefulWidget {
  static const String routeName = '/status';

  RemoteMessage? message;

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

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          ClientInfo = value;
          _getServices();
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
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: (screenHeight + screenWidth) / 75,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Text(
              message.toString().toUpperCase(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: fontNormalSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white
                ),
              ),
            ),
          ],
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

  List<TechnicalData> _filteredServices = [];
  void filterSystemsList() {
    _filteredServices = _services.where((technicalData) {
      final svcId = technicalData.svcId.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return svcId.contains(searchQuery);
    }).toList();
  }

  _editToCancel(TechnicalData services){
    TechnicalDataServices.editCancelBooking(services.id, services.svcId, reasonController.text.trim()).then((result) {
      if('success' == result){
        _getServices(); //refresh the list after update
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
        DateFormat('yyyy-MM-dd').format(selectedDate!.start),
        DateFormat('yyyy-MM-dd').format(selectedDate!.end)).then((result) {
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

  _editToResched(TechnicalData services){
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
  }

  void _showDatePicker(BuildContext context, TechnicalData services, String accORresched) {
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

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(_filteredServices[index].status == "Unread"){
                                        _showBottomSheet(context, _filteredServices[index]);
                                      }

                                      if(_filteredServices[index].status == "Set-sched"){
                                        _showBottomSheet(context, _filteredServices[index]);
                                      }
                                    },
                                    child: TaskTile(services: _filteredServices[index]),
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

                services.status == "Set-sched" ?
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: _bottomSheetButton(
                    label: "ACCEPT",
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                        _showDatePicker(context, services, "Accept");
                      });
                    },
                    clr: Colors.green,
                    context:context,
                  ),
                ): SizedBox.shrink(),

                services.status == "Set-sched" ?
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

