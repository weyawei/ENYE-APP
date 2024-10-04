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

class _TSIStatusPageState extends State<TSIStatusPage> {
  final searchController = TextEditingController();
  final reasonController = TextEditingController();

  bool _isLoadingTSIS = true;
  bool _isLoadingEvents = true;

  void initState(){
    super.initState();
    _ecEvent = [];
    _ecTSIS = [];

    _getEcTSISbasedEmail();
    // if(widget.message!.data["goToPage"] == "Status"){
    //   searchController.text = '${widget.message!.data["code"]}';
    // }
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    reasonController.dispose();
    super.dispose();
  }

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

  List<EcTSIS> _filteredTSIS = [];
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
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: CustomAppBar(title: 'Technical Status', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        body: _isLoadingEvents || _isLoadingTSIS
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              _getEcTSISbasedEmail();
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
                        : null, // Set suffixIcon to null when text is empty
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
                    itemBuilder: (_, index){

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
