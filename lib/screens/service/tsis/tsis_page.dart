import 'package:enye_app/screens/service/tsis/tsis_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../widget/widgets.dart';
import '../../screens.dart';

class TSIStatusPage extends StatefulWidget {
  final String email;
  const TSIStatusPage({super.key, required this.email });

  @override
  State<TSIStatusPage> createState() => _TSIStatusPageState();
}

class _TSIStatusPageState extends State<TSIStatusPage> with TickerProviderStateMixin {
  final searchController = TextEditingController();
  final reasonController = TextEditingController();

  bool _isLoadingTSIS = true;
  bool _isLoadingEvents = true;

  void initState(){
    super.initState();
    _ecEvent = [];
    _ecTSIS = [];

    _getEcTSISbasedEmail();
    _getEcEvent();

    // if(widget.message!.data["goToPage"] == "Status"){
    //   searchController.text = '${widget.message!.data["code"]}';
    // }
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

  late List<EcEvent> _ecEvent;

  _getEcEvent(){
    ECTechnicalDataServices.getEcEvents().then((EcEvent){
      setState(() {
        _ecEvent = EcEvent;
      });
      _isLoadingEvents = false;
    });
  }

  late List<EcTSIS> _ecTSIS;
  _getEcTSISbasedEmail(){
    ECTechnicalDataServices.getEcTSISbasedEmail(widget.email).then((EcTSIS){
      setState(() {
        _ecTSIS = EcTSIS;
      });
      _isLoadingTSIS = false;
    });
  }

  List<EcTSIS> _filteredTSIS = [];
  void filterTSISList() {
    _filteredTSIS = _ecTSIS.where((tsis) {
      final tsisNo = tsis.tsis_no.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return tsisNo.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: CustomAppBar(title: 'Technical Status', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        body: _isLoadingEvents || _isLoadingTSIS
        ? Center(child: SpinningContainer(controller: _controller),)
        : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getEcTSISbasedEmail();
              _getEcEvent();
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
                        filterTSISList();
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null, // Set suffixIcon to null when text is empty
                  ),
                  onChanged: (value) {
                    setState(() {
                      filterTSISList();
                      if(searchController.text.isEmpty){
                        FocusScope.of(context).unfocus();
                      }
                    });
                  },
                  onEditingComplete: (){
                    filterTSISList();
                  },
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
                    itemCount: searchController.text.isEmpty ? _ecTSIS.length : _filteredTSIS.length,
                    itemBuilder: (_, index){
                      _filteredTSIS = searchController.text.isEmpty ? _ecTSIS : _filteredTSIS;

                      /* ServiceAppointment? appointment = _appointment.where((appoint) => _filteredServices[index].id == appoint.svc_id).elementAtOrNull(0);

                        EcSO? ecServiceOrder = _ecSO.where((ecso) => _filteredServices[index].tsis_id == ecso.tsis_id).elementAtOrNull(0);
                        EcEvent? ecEvent = _ecEvent.where((ecevent) => _filteredServices[index].tsis_id == ecevent.tsis_id).elementAtOrNull(0);*/

                      EcTSIS tsis = _filteredTSIS[index];
                      List<EcEvent> events = _ecEvent.where((e) => e.tsis_id == tsis.tsis_id).toList();


                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if (events.isNotEmpty){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TSISViewPage(events: events, tsis: tsis)),
                                      );
                                    }
                                  },
                                  child: TSISTaskTile(tsis: tsis, event: events,),
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
