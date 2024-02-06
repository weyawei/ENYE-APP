import 'package:flutter/material.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class systemsPage extends StatefulWidget {
  const systemsPage({super.key});

  @override
  State<systemsPage> createState() => _systemsPageState();
}

class _systemsPageState extends State<systemsPage> with TickerProviderStateMixin {
  double screenHeight = 0;
  double screenWidth = 0;

  final searchController = TextEditingController();
  late List<Systems> _systems;
  List<Systems> _filteredSystems = [];

  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _systems = [];
    _getSystems();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  _getSystems(){
    systemService.getSystems().then((Systems){
      setState(() {
        _systems = Systems;
      });
      _isLoading = false;
      print("Length ${Systems.length}");
    });
  }

  void filterSystemsList() {
    _filteredSystems = _systems.where((Systems) {
      final title = Systems.title.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return title.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return GestureDetector(
      // When tapped, dismiss the keyboard by unfocusing the TextField
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Systems', imagePath: '',),
        backgroundColor: Colors.white,
        body: _isLoading
          ? Center(child: SpinningContainer(controller: _controller),)
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 50,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(fontSize: fontExtraSize),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              FocusScope.of(context).unfocus();
                              filterSystemsList();
                            },
                            icon: Icon(Icons.clear, size: (screenHeight + screenWidth) / 40,),
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
                        if(searchController.text.isEmpty){
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),

                    const SizedBox(height: 10,),
                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: searchController.text.isEmpty ? _systems.length : _filteredSystems.length,
                        itemBuilder: (context, index) {
                          _filteredSystems = searchController.text.isEmpty ? _systems : _filteredSystems;
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
                              height: screenHeight / 13,
                              width: screenWidth,
                              margin: EdgeInsets.only(
                                bottom: screenHeight / 50,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth / 50
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
                                        fontSize: fontNormalSize,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Icon(
                                    Icons.label_important,
                                    size: (screenHeight + screenWidth) / 50,
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
      ),
    );
  }
}
