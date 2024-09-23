import 'package:flutter/material.dart';
import '../../config/api_connection.dart';
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

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return GestureDetector(
      // When tapped, dismiss the keyboard by unfocusing the TextField
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
       // appBar: CustomAppBar(title: 'Systems', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        backgroundColor: Colors.white,
        body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  setState(() {
                    _getSystems();
                  });
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth / 50,
                  ),
                  child: Column(
                    children: [
                      // const SizedBox(height: 10,),
                      // TextField(
                      //   controller: searchController,
                      //   decoration: InputDecoration(
                      //     labelText: 'Search',
                      //     labelStyle: TextStyle(fontSize: fontExtraSize),
                      //     prefixIcon: Icon(Icons.search),
                      //     suffixIcon: searchController.text.isNotEmpty
                      //       ? IconButton(
                      //         onPressed: () {
                      //           searchController.clear();
                      //           FocusScope.of(context).unfocus();
                      //           filterSystemsList();
                      //         },
                      //         icon: Icon(Icons.clear, size: (screenHeight + screenWidth) / 40,),
                      //       )
                      //       : null, // Set suffixIcon to null when text is empty
                      //   ),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       filterSystemsList();
                      //       if(searchController.text.isEmpty){
                      //         FocusScope.of(context).unfocus();
                      //       }
                      //     });
                      //   },
                      //   onEditingComplete: (){
                      //     filterSystemsList();
                      //     if(searchController.text.isEmpty){
                      //       FocusScope.of(context).unfocus();
                      //     }
                      //   },
                      // ),

                      const SizedBox(height: 10,),
                      // ListView.builder(
                      //     primary: false,
                      //     shrinkWrap: true,
                      //     itemCount: searchController.text.isEmpty ? _systems.length : _filteredSystems.length,
                      //     itemBuilder: (context, index) {
                      //       _filteredSystems = searchController.text.isEmpty ? _systems : _filteredSystems;
                      //       return InkWell(
                      //         onTap: () {
                      //           // Handle the onTap event here
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => detailedSysPage(systems: _filteredSystems[index]),
                      //             ),
                      //           );
                      //         },
                      //         child: Container(
                      //           height: screenHeight / 13,
                      //           width: screenWidth,
                      //           margin: EdgeInsets.only(
                      //             bottom: screenHeight / 50,
                      //           ),
                      //           padding: EdgeInsets.symmetric(
                      //             horizontal: screenWidth / 50
                      //           ),
                      //           decoration: BoxDecoration(
                      //             color: Colors.white10,
                      //             borderRadius: BorderRadius.circular(10),
                      //             border: Border.all(
                      //               color: Colors.deepOrange,
                      //               width: 2,
                      //               style: BorderStyle.solid,
                      //             ),
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Expanded(
                      //                 child: Text(
                      //                   " ${_filteredSystems[index].title}",
                      //                   style: TextStyle(
                      //                     fontSize: fontNormalSize,
                      //                     fontWeight: FontWeight.bold,
                      //                     letterSpacing: 1.2,
                      //                   ),
                      //                 ),
                      //               ),
                      //               SizedBox(width: 15,),
                      //               Icon(
                      //                 Icons.label_important,
                      //                 size: (screenHeight + screenWidth) / 50,
                      //                 color: Colors.deepOrange,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      _filteredSystems.isEmpty
                        ? GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenLayout ? 2 : 3,
                              crossAxisSpacing: (screenHeight + screenWidth) / 90,
                              mainAxisSpacing: (screenHeight + screenWidth) / 90,
                              mainAxisExtent: screenHeight * 0.3,
                            ),
                            itemCount: _systems.length,
                            itemBuilder: (context, index){

                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => detailedSysPage(systems: _systems[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.orange[200],
                                  ), //no function?? nasasapawan ng pictures
                                  child: Column(
                                    children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(12.0),
                                        child: Container(
                                          height: screenHeight * 0.3,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("${API.systemsImg + _systems[index].image}"),
                                              fit: BoxFit.cover,
                                              onError: (exception, stackTrace) {
                                                // Handle image loading error here
                                                print("Image loading failed: $exception");
                                              },
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Colors.blue.withOpacity(0.18), Colors.deepOrange.shade100.withOpacity(0.28)],
                                                stops: [0.0, 1],
                                                begin: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                            },
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenLayout ? 2 : 3,
                              crossAxisSpacing: (screenHeight + screenWidth) / 90,
                              mainAxisSpacing: (screenHeight + screenWidth) / 90,
                              mainAxisExtent: screenHeight * 0.3,
                            ),
                            itemCount: _filteredSystems.length,
                            itemBuilder: (context, index){

                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => detailedSysPage(systems: _filteredSystems[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.orange[200],
                                  ), //no function?? nasasapawan ng pictures
                                  child: Column(
                                    children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(12.0),
                                        child: Container(
                                          height: screenHeight * 0.3,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("${API.systemsImg + _filteredSystems[index].image}"),
                                              fit: BoxFit.cover,
                                              onError: (exception, stackTrace) {
                                                // Handle image loading error here
                                                print("Image loading failed: $exception");
                                              },
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.3)],
                                                stops: [0.0, 1],
                                                begin: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
