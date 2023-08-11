import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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

class _StatusPageState extends State<StatusPage> {
  clientInfo? ClientInfo;
  bool? userSessionFuture;
  final searchController = TextEditingController();

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
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  late List<TechnicalData> _services;

  _getServices(){
    TechnicalDataServices.clientTechnicalData(ClientInfo!.client_id).then((technicalData){
      setState(() {
        _services = technicalData;
      });
      print("Length ${technicalData.length}");
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

  @override
  Widget build(BuildContext context) {
    if(widget.message!.data["goToPage"] == "Status"){
      searchController.text = '${widget.message!.data["code"]}';
      filterSystemsList();
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Status', imagePath: '',),
      /*drawer: CustomDrawer(),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10,),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filterSystemsList();
              });
            },
            onEditingComplete: (){
              filterSystemsList();
            },
          ),

          SizedBox(height: 10,),
          Expanded(
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
                                //_showBottomSheet(context, services);
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
    );
  }
}

