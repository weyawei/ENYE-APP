import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widget/widgets.dart';
import '../screens.dart';

class AppointmentStatusPage extends StatefulWidget {
  final String email;
  final RemoteMessage? message;
  const AppointmentStatusPage({super.key, required this.email, required this.message });

  @override
  State<AppointmentStatusPage> createState() => _AppointmentStatusPageState();
}

class _AppointmentStatusPageState extends State<AppointmentStatusPage> {
  String? _dropdownError; //kapag wala pa na-select sa option

  final searchController = TextEditingController();
  final reasonController = TextEditingController();

  bool _isLoadingTSISEvents = true;
  bool _isLoadingAppointment = true;

  DateTimeRange? selectedDate;
  DateTime firstDate = DateTime.now().add(Duration(days: 5));
  DateTime lastDate = DateTime.now().add(Duration(days: 60));

  final TextEditingController note = TextEditingController();

  @override
  void initState(){
    super.initState();
    _appointment = [];
    _listTsisEvents = [];

    _getAppointment();

    if(widget.message!.data["goToPage"] == "Status"){
      searchController.text = '${widget.message!.data["code"]}';
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    reasonController.dispose();
    searchController.dispose();
    super.dispose();
  }

  late List<TechnicalData> _appointment;
  List<TechnicalData> _filteredAppointment = [];
  _getAppointment(){
    EngineeringServices.getAppointmentsEmailBased(widget.email).then((appointment){
      setState(() {
        _appointment = appointment.where((element) => element.status != "Complete" && element.status != "Cancelled").toList();
        _filteredAppointment = appointment.where((element) => element.status != "Complete" && element.status != "Cancelled").toList();

        _appointment.forEach((element) {
          if (element.tsis_id.isNotEmpty) {
            _getTsisEventsEmailBased(element.tsis_id);
          }
        });
      });
      _isLoadingAppointment = false;
      _isLoadingTSISEvents = false;
    });
  }

  late List<EngTSIS> _listTsisEvents;
  _getTsisEventsEmailBased(String tsis_id){
    EngineeringServices.getTSISbyID(tsis_id).then((TsisEvents){
      setState(() {
        _listTsisEvents = TsisEvents;
      });
    });
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty || query.length == 0) {
      setState(() {
        _filteredAppointment = List.from(_listTsisEvents);
      });
    } else {
      setState(() {
        _filteredAppointment = _appointment.where((appointment) => appointment.svcId.toLowerCase().contains(query.toLowerCase()) ||
            appointment.svcTitle.toLowerCase().contains(query.toLowerCase()) ||
            appointment.svcDesc.toLowerCase().contains(query.toLowerCase()) ||
            appointment.clientProjName.toLowerCase().contains(query.toLowerCase()) ||
            appointment.service.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  _editToCancel(TechnicalData services){
    TechnicalDataServices.editCancelBooking(services.id, services.svcId, reasonController.text.trim()).then((result) {
      if('success' == result){
        _getAppointment();
        custSnackbar(
          context,
          "Cancelled Booking Successfully",
          Colors.green,
          Icons.check,
          Colors.greenAccent
        );
        reasonController.text = '';
      } else {
        custSnackbar(
            context,
            "Error occured...",
            Colors.redAccent,
            Icons.dangerous_rounded,
            Colors.white
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.message!.data["goToPage"] == "Status"){
    //   filterSystemsList();
    // }

    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: CustomAppBar(title: 'Status', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        body: _isLoadingAppointment || _isLoadingTSISEvents
            ? Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getAppointment();
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  onChanged: _filterSearchResults,
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search SERVICE #',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        _filterSearchResults('');
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null,
                  ),
                ),
              ),

              SizedBox(height: 25,),
              _appointment.isEmpty
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
                    itemCount: _filteredAppointment.length,
                    itemBuilder: (_, index){

                      TechnicalData appointment = _filteredAppointment[index];

                      EngTSIS? tsis = _listTsisEvents.where((tsis) => tsis.tsis_id == appointment.tsis_id).elementAtOrNull(0);

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if (appointment.status == "Unread") {
                                      _showBottomSheet(context, appointment);
                                    }

                                    if(appointment.tsis_id != '') {
                                      setState(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailedTechnicalStatusPage(tsis_events: tsis!, appointment_no: appointment.svcId,)),
                                        );
                                      });
                                    }
                                  },
                                  child: TaskTileAppointment(services: appointment, tsis_events: tsis,),
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

