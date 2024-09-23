import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = '/status';

  final RemoteMessage? message;
  final clientInfo? client;

  HistoryPage({required this.message, required this.client});

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
  final searchController = TextEditingController();
  bool _isLoadingService = true;
  bool _isLoadingTSIS = true;
  bool _isLoadingEvents = true;

  void initState(){
    super.initState();
    _services = [];
    _ecTSIS = [];
    _filteredTSIS = [];

    _getServices();
    _getEcTSIS();

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
    TechnicalDataServices.clientTechnicalData(widget.client!.client_id).then((technicalData){
      setState(() {
        _services = technicalData.where((element) => element.status == "Complete").toList();
      });
      _isLoadingService = false;
    });
  }

  late List<EcTSIS> _ecTSIS;
  late List<EcTSIS> _filteredTSIS;
  _getEcTSIS(){
    ECTechnicalDataServices.getEcCompleteTSISbasedEmail(widget.client!.email).then((EcTSIS){
      setState(() {
        _ecTSIS = EcTSIS;
        _filteredTSIS = EcTSIS;
      });
      _isLoadingTSIS = false;
      if(_ecTSIS.length > 0){
        _getEcEvent();
      } else {
        _isLoadingEvents = false;
      }
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

  void _filterSearchResults(String query) {
    if (query.isEmpty || query.length == 0) {
      setState(() {
        _filteredTSIS = List.from(_ecTSIS);
      });
    } else {
      setState(() {
        _filteredTSIS = _ecTSIS.where((tsis) => tsis.tsis_no.toLowerCase().contains(query.toLowerCase()) ||
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
        body: _isLoadingService || _isLoadingTSIS || _isLoadingEvents
          ? Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  _getServices();
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
                  _ecTSIS.isEmpty
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
                      itemCount: _filteredTSIS.length,
                      itemBuilder: (context, index) {

                        EcTSIS tsis = _filteredTSIS[index];

                        List<EcEvent> events = _ecEvent.where((e) => e.tsis_id == tsis.tsis_id).toList();

                        List<TechnicalData> service = _services.where((s) => s.tsis_id == tsis.tsis_id && s.clientId == widget.client!.client_id).toList();

                        return AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {

                                      },
                                      child: service.isEmpty
                                        ? TSISTaskTile(tsis: tsis, event: events)
                                        : TaskTile(services: service[0], tsis: tsis, event: events),
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