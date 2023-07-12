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

  late List<Systems> _systems;

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
                    //searchText = value;
                    //filterItemDataList();
                  });
                },
              ),

              const SizedBox(height: 10,),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _systems.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Handle the onTap event here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => detailedSysPage(systems: _systems[index]),
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
                                " ${_systems[index].title}",
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
