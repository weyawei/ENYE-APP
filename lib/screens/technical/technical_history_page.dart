import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../widget/widgets.dart';
import '../screens.dart';

class TechnicalHistoryPage extends StatefulWidget {
  static const String routeName = '/status';

  final RemoteMessage? message;
  final String email;

  TechnicalHistoryPage({required this.message, required this.email});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => StatusPage(message: message,)
    );
  }

  @override
  State<TechnicalHistoryPage> createState() => _TechnicalHistoryPageState();
}

class _TechnicalHistoryPageState extends State<TechnicalHistoryPage> {
  final searchController = TextEditingController();
  bool _isLoadingTSISEvents = true;
  bool _isLoadingAppointment= true;

  void initState(){
    super.initState();
    _listTsisEvents = [];
    _appointment = [];

    _getTsisEventsEmailBased();
    _getAppointment();

    if(widget.message!.data["goToPage"] == "Completed"){
      searchController.text = '${widget.message!.data["code"]}';
    }
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  late List<TechnicalData> _appointment;
  _getAppointment(){
    EngineeringServices.getAppointmentsEmailBased(widget.email).then((appointment){
      setState(() {
        _appointment = appointment;
      });
      _isLoadingAppointment = false;
    });
  }

  late List<EngTSIS> _listTsisEvents;
  List<EngTSIS> _filteredTsisEvent = [];
  _getTsisEventsEmailBased(){
    EngineeringServices.getTsisEventsEmailBasedComplete(widget.email).then((TsisEvents){
      setState(() {
        _listTsisEvents = TsisEvents;
        _filteredTsisEvent = TsisEvents;
      });
      _isLoadingTSISEvents = false;
    });
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty || query.length == 0) {
      setState(() {
        _filteredTsisEvent = List.from(_listTsisEvents);
      });
    } else {
      setState(() {
        _filteredTsisEvent = _listTsisEvents.where((tsis) => tsis.tsis_no.toLowerCase().contains(query.toLowerCase()) ||
            tsis.problem.toLowerCase().contains(query.toLowerCase()) ||
            tsis.project.toLowerCase().contains(query.toLowerCase()) ||
            tsis.subject.toLowerCase().contains(query.toLowerCase()) ||
            tsis.client_name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'History', imagePath: '', appBarHeight: screenHeight * 0.05,),
        body: _isLoadingTSISEvents || _isLoadingAppointment
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getTsisEventsEmailBased();
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
                          _filterSearchResults('');
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.clear),
                      )
                          : null,
                    )
                ),
              ),

              SizedBox(height: 25,),
              _listTsisEvents.isEmpty
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
                    itemCount: _filteredTsisEvent.length,
                    itemBuilder: (context, index) {

                      EngTSIS tsis = _filteredTsisEvent[index];

                      List<TechnicalData> appointment = _appointment.where((a) => a.tsis_id == tsis.tsis_id).toList();

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DetailedTechnicalStatusPage(tsis_events: tsis, appointment_no: appointment.isEmpty ? '' : appointment[0].svcId,)),
                                    );
                                  },
                                  child: appointment.isEmpty
                                    ? TaskTileTSISEvents(tsis_events: tsis,)
                                    : TaskTileAppointment(services: appointment[0], tsis_events: tsis,),
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