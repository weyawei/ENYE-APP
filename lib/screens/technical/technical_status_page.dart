import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../widget/widgets.dart';
import '../screens.dart';

class TechnicalStatusPage extends StatefulWidget {
  final String email;
  const TechnicalStatusPage({super.key, required this.email });

  @override
  State<TechnicalStatusPage> createState() => _TechnicalStatusPageState();
}

class _TechnicalStatusPageState extends State<TechnicalStatusPage> with TickerProviderStateMixin {
  final searchController = TextEditingController();

  bool _isLoadingTSISEvents = true;

  void initState(){
    super.initState();
    _listTsisEvents = [];

    _getTsisEventsEmailBased();
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  late List<EngTSIS> _listTsisEvents;
  List<EngTSIS> _filteredTsisEvent = [];
  _getTsisEventsEmailBased(){
    EngineeringServices.getTsisEventsEmailBased(widget.email).then((TsisEvents){
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
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: CustomAppBar(title: 'Technical Status', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        body: _isLoadingTSISEvents
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
                    itemBuilder: (_, index){

                      EngTSIS tsis_events = _filteredTsisEvent[index];

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
                                      MaterialPageRoute(builder: (context) => DetailedTechnicalStatusPage(tsis_events: tsis_events, appointment_no: '',)),
                                    );
                                  },
                                  child: TaskTileTSISEvents(tsis_events: tsis_events,),
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
