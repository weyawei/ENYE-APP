import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../config/config.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

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
    TechnicalDataServices.clientTechnicalData(ClientInfo!.client_id).then((technicalData){
      setState(() {
        _services = technicalData.where((element) => element.status == "Completed" || element.status == "Cancelled").toList();
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

  @override
  Widget build(BuildContext context) {
    if(widget.message!.data["goToPage"] == "Completed"){
      filterSystemsList();
    }

    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: CustomAppBar(title: 'History', imagePath: '',),
        /*drawer: CustomDrawer(),*/
        body: _isLoading
          ? Center(child: SpinningContainer(controller: _controller),)
          : Column(
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
      ),
    );
  }
}

