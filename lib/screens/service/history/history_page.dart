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
import '../ec_technical_data.dart';
import '../ec_technical_svc.dart';
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
  bool _isLoadingTSIS = true;
  bool _isLoadingEvents = true;

  void initState(){
    super.initState();
    _services = [];

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          ClientInfo = value;
          _getServices();
          _getEcTSIS();
          _getEcEvent();

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
  List<TechnicalData> _filteredServices = [];
  _getServices(){
    TechnicalDataServices.clientTechnicalData(ClientInfo!.client_id).then((technicalData){
      setState(() {
        _services = technicalData.where((element) => element.status == "Completed" || element.status == "Cancelled").toList();
        _filteredServices = technicalData.where((element) => element.status == "Completed" || element.status == "Cancelled").toList();
      });
      _isLoading = false;
    });
  }

  List<EcTSIS> _ecTSIS = [];
  _getEcTSIS(){
    ECTechnicalDataServices.getEcTSIS().then((EcTSIS){
      setState(() {
        _ecTSIS = EcTSIS;
      });
      _isLoadingTSIS = false;
    });
  }

  List<EcEvent> _ecEvent = [];
  _getEcEvent(){
    ECTechnicalDataServices.getEcEvents().then((EcEvent){
      setState(() {
        _ecEvent = EcEvent;
      });
      _isLoadingEvents = false;
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

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredServices = List.from(_services);
      });
    } else {
      setState(() {
        _filteredServices = _services.where((service) => service.svcId.toLowerCase().contains(query.toLowerCase()) ||
            service.clientName.toLowerCase().contains(query.toLowerCase()) ||
            service.clientProjName.toLowerCase().contains(query.toLowerCase()) ||
            service.clientCompany.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        body: _isLoading || _isLoadingTSIS || _isLoadingEvents
          ? Center(child: SpinningContainer(controller: _controller),)
          : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getServices();
              _getEcEvent();
              _getEcTSIS();
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
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        FocusScope.of(context).unfocus();
                        // filterSystemsList();
                      },
                      icon: const Icon(Icons.clear),
                    )
                    : null, // Set suffixIcon to null when text is empty
                  ),
                  onEditingComplete: () {
                    // filterSystemsList();
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
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    TechnicalData service = _filteredServices[index];
                    EcTSIS tsis = _ecTSIS.where((tsis) => tsis.tsis_id == service.tsis_id).elementAt(0);
                    List<EcEvent> events = _ecEvent.where((e) => e.tsis_id == tsis.tsis_id).toList();

                    return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // if (_filteredServices[index].status ==
                                    //     "Cancelled") {
                                    //   _showBottomSheet1(context,
                                    //       _filteredServices[index]);
                                    // }
                                    //
                                    // if (_filteredServices[index].status ==
                                    //     "Completed") {
                                    //   _showBottomSheet2(context,
                                    //       _filteredServices[index], appointment!);
                                    // }

                                    setState(() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => HistoryViewPage(tsis: tsis, events: events, service: service,)),
                                      );
                                    });
                                  },
                                  child: TaskTile(
                                      services: service),
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