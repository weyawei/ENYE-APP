import 'package:enye_app/screens/systems/system_page2.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/custom_drawer.dart';
import '../projects/project_page.dart';

class SystemsPage extends StatelessWidget {
  static const String routeName = '/systems';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => SystemsPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Systems', imagePath: '',),
      /*drawer: CustomDrawer(),*/
      body: CustomScrollView(
          slivers: [
      const SliverAppBar(
      leading: Text(''),
      // title: Image.asset("images/logo/enyecontrols.png", height: 30),
      backgroundColor: Colors.deepOrangeAccent,
      expandedHeight: 70,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        //  background: Image.asset('images/logo/header.jpg', fit: BoxFit.cover,),
        //  title: Image.asset("images/logo/enyecontrols.png", height: 15,),
        title: Text('SYSTEMS OF ENYECONTROLS', style: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          //fontStyle: FontStyle.italic,
          decorationColor: Colors.red,
          decorationThickness: 5.0,
          letterSpacing: .2,
          shadows: [
            Shadow(
              color: Colors.black12,
              blurRadius: 2.0,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),),
        centerTitle: true,
      ),
       ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen1.routeName),
                    screen: SystemScreen1(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix1.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen2.routeName),
                    screen: SystemScreen2(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix2.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen3.routeName),
                    screen: SystemScreen3(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix3.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen4.routeName),
                    screen: SystemScreen4(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix4.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen5.routeName),
                    screen: SystemScreen5(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix5.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen6.routeName),
                    screen: SystemScreen6(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix6.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen66.routeName),
                    screen: SystemScreen66(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix6.2.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen666.routeName),
                    screen: SystemScreen666(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix6.3.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen7.routeName),
                    screen: SystemScreen7(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix7.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen8.routeName),
                    screen: SystemScreen8(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix8.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen9.routeName),
                    screen: SystemScreen9(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix9.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen10.routeName),
                    screen: SystemScreen10(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix10.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: SystemScreen11.routeName),
                    screen: SystemScreen11(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      color: Colors.deepOrange,
                      margin: EdgeInsets.all(15.0),
                      child: Image.asset(
                          'assets/images_1/pix11.png',
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),

      ],
      ),
    );

  }
}







// Create a model class to represent the data for each item
class ItemData {
  final String title;
  final String imgUrl;
  final String description;
  final String description2;
  final String description3;

  ItemData({required this.title, required this.imgUrl, required this.description, required this.description2, required this.description3});
}

class SystemsPage1 extends StatefulWidget {
  const SystemsPage1({super.key});

  @override
  State<SystemsPage1> createState() => _SystemsPage1State();

}

class _SystemsPage1State extends State<SystemsPage1> {
    double screenHeight = 0;
    double screenWidth = 0;
    String searchText = '';
    List<ItemData> filteredItemDataList = [];

    void filterItemDataList() {
      filteredItemDataList = itemDataList.where((itemData) {
        final description = itemData.description.toLowerCase();
        final searchQuery = searchText.toLowerCase();
        return description.contains(searchQuery);
      }).toList();
    }
    List<ItemData> itemDataList = [
      ItemData(
        title: 'SYSTEM 1: CHILLED WATER TEMPERATURE CONTROL & MONITORING SYSTEM',
        imgUrl: "assets/images_1/pix1.png",
        description: "search1",
        description2: '-Design for real-tme detection air carbon monoxide.\n-High accuracy temperature.\n-LCD display carbon monoxide and temperature measurement.\n-Smart bu􀆩ons or easy operation.\n-CO sensor is replaced\n-Provide up to two dry contact output\n-BACnet MS/TP communication\n-PC/ABS fireproof plastic material\n-IP30 protection class',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 2: INTELLIGENT VARIABLE AIR VOLUME SYSTEM (I-VAV SYSTEM)',
        imgUrl: "assets/images_1/pix2.png",
        description: "search2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 3: WATER BY-PASS SYSTEM',
        imgUrl: "assets/images_1/pix3.png",
        description: "This is system .",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 4: TEMPERATURE AND HUMIDITY CONTROL AND MONITORING SYSTEM',
        imgUrl: "assets/images_1/pix4.png",
        description: "   -Designed to protect the building tenants/public from being expose to CO since Carbon Monoxide is colorless, odorless gas it cannot be easily detected. Nevertheless, it also monitors Temperature on each zone to minimize high temperature reading for comfort.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 5: INTELLIGENT FAN COIL CONTROL AND MONITORING SYSTEM',
        imgUrl: "assets/images_1/pix5.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 6.1: LIFE AND PROPERTY SAFETY SYSTEM (FIRE & SMOKE PROTECTION SYSTEM)',
        imgUrl: "assets/images_1/pix6.png",
        description: "search6.1",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 6.2: LIFE AND PROPERTY SAFETY SYSTEM (STAIRWELL PRESSURIZATION SYSTEM)',
        imgUrl: "assets/images_1/pix6.2.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 6.3: LIFE AND PROPERTY SAFETY SYSTEM (SMOKE EXTRACTION SYSTEM)',
        imgUrl: "assets/images_1/pix6.3.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 7: HAZARDOUS GASES CONTROL AND MONITORING SYSTEM',
        imgUrl: "assets/images_1/pix7.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 8: WATER LEAK DETECTION AND ALARM SYSTEM',
        imgUrl: "assets/images_1/pix8.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 9: NETWORKABLE STANDALONE CONTROL SYSTEM',
        imgUrl: "assets/images_1/pix9.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 11: FUEL LEAK DETECTION AND ALARM SYSTEM',
        imgUrl: "assets/images_1/pix10.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      ItemData(
        title: 'SYSTEM 12: SEISMIC MONITORING SYSTEM',
        imgUrl: "assets/images_1/pix11.png",
        description: "This is system 2.",
        description2: '',
        description3: '',
      ),
      // ... Add more item data for each item
    ];


    List<String> text = [
      "SYSTEM 1: CHILLED WATER TEMPERATURE CONTROL & MONITORING SYSTEM",
      "SYSTEM 2: INTELLIGENT VARIABLE AIR VOLUME SYSTEM (I-VAV SYSTEM)",
      "SYSTEM 3: WATER BY-PASS SYSTEM",
      "SYSTEM 4: TEMPERATURE AND HUMIDITY CONTROL AND MONITORING SYSTEM",
      "SYSTEM 5: INTELLIGENT FAN COIL CONTROL AND MONITORING SYSTEM",
      "SYSTEM 6.1: LIFE AND PROPERTY SAFETY SYSTEM (FIRE & SMOKE PROTECTION SYSTEM)",
      "SYSTEM 6.2: LIFE AND PROPERTY SAFETY SYSTEM (STAIRWELL PRESSURIZATION SYSTEM)",
      "SYSTEM 6.3: LIFE AND PROPERTY SAFETY SYSTEM (SMOKE EXTRACTION SYSTEM)",
      "SYSTEM 7: HAZARDOUS GASES CONTROL AND MONITORING SYSTEM",
      "SYSTEM 8: WATER LEAK DETECTION AND ALARM SYSTEM",
      "SYSTEM 9: NETWORKABLE STANDALONE CONTROL SYSTEM",
      "SYSTEM 11: FUEL LEAK DETECTION AND ALARM SYSTEM",
      "SYSTEM 12: SEISMIC MONITORING SYSTEM",
    ];

    List<IconData>  icons= [
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,
      Icons.label_important,


    ];

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
                const Text(
                  "List of Systems",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                      filterItemDataList();
                    });
                  },
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: searchText.isEmpty ? itemDataList.length : filteredItemDataList.length,
                    itemBuilder: (context, index) {
                      final itemData = searchText.isEmpty ? itemDataList[index] : filteredItemDataList[index];
                      return InkWell(
                        onTap: () {
                          // Handle the onTap event here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(itemData: itemData),
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
                                " ${itemData.title}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              icons[index],
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

class DetailScreen extends StatelessWidget {
  final ItemData itemData;

  const DetailScreen({required this.itemData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Systems', imagePath: '',),

      body: ListView(
        children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'SYSTEM INFORMATION',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(itemData.imgUrl, fit: BoxFit.cover,),
              Text(itemData.description),
             // SizedBox(height: 16),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                'System Descriptions',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
                children: [
                  Text(itemData.description2, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'System Specifications',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                children: [
                  Text(itemData.description2, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Row(
                  children: [
                    Text(
                      'Technical Specifications',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                children: [
                  GridView.count(
                    crossAxisCount: 2, // Adjust the number of columns as needed
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                        Image.asset(
                          itemData.imgUrl,
                          fit: BoxFit.fill,
                        ),

                      SingleChildScrollView(
                        child: Text(
                          itemData.description2,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Text(
                          itemData.description2,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                       Image.asset(
                          itemData.imgUrl,
                          fit: BoxFit.fill,
                        ),
                    ],
                  ),
                ],
              )

            ],
          ),
        ),
    ],
      ),
    );
  }
}