import 'package:flutter/material.dart';

import '../../widget/custom_appbar.dart';
import '../screens.dart';

class systemsPage extends StatefulWidget {
  const systemsPage({super.key});

  @override
  State<systemsPage> createState() => _systemsPageState();
}

class _systemsPageState extends State<systemsPage> {
  double screenHeight = 0;
  double screenWidth = 0;
  String searchText = '';

  late List<Systems> _systems;
  List<Systems> _filteredSystems = [];

  @override
  void initState(){
    super.initState();
    _systems = [];
    _getSystems();
  }

  _getSystems(){
    systemService.getSystems().then((Systems){
      setState(() {
        _systems = Systems;
      });
      print("Length ${Systems.length}");
    });
  }

  void filterSystemsList() {
    _filteredSystems = _systems.where((Systems) {
      final title = Systems.title.toLowerCase();
      final searchQuery = searchText.toLowerCase();
      return title.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: 'Systems', imagePath: '',),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth /50,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    filterSystemsList();
                  });
                },
              ),

              const SizedBox(height: 10,),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: searchText.isEmpty ? _systems.length : _filteredSystems.length,
                  itemBuilder: (context, index) {
                    _filteredSystems = searchText.isEmpty ? _systems : _filteredSystems;
                    return InkWell(
                      onTap: () {
                        // Handle the onTap event here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => detailedSysPage(systems: _filteredSystems[index]),
                          ),
                        );
                      },
                      child: Container(
                        height: 55,
                        width: screenWidth,
                        margin: EdgeInsets.only(
                          bottom: 12,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 100,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.deepOrange,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                " ${_filteredSystems[index].title}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.label_important,
                              color: Colors.deepOrange,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
