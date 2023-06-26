import 'package:enye_app/screens/systems/system_page2.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/custom_drawer.dart';
import '../projects/project_page.dart';

class SystemsPage extends StatelessWidget {
  static const String routeName = '/systems';

  List<String> imageUrls = [
    'assets/images_1/pix1.png',
    'assets/images_1/pix2.png',
    'assets/images_1/pix3.png',
    'assets/images_1/pix4.png',
    'assets/images_1/pix5.png',
    'assets/images_1/pix6.png',
    'assets/images_1/pix6.2.png',
    'assets/images_1/pix6.3.png',
    'assets/images_1/pix7.png',
    'assets/images_1/pix8.png',
    'assets/images_1/pix9.png',
    'assets/images_1/pix10.png',
    'assets/images_1/pix11.png',
    // Add more image URLs here
  ];


  List<String> routes = [
    SystemScreen1.routeName,
    SystemScreen2.routeName,
    SystemScreen3.routeName,
    SystemScreen4.routeName,
    SystemScreen5.routeName,
    SystemScreen6.routeName,
    SystemScreen66.routeName,
    SystemScreen666.routeName,
    SystemScreen7.routeName,
    SystemScreen8.routeName,
    SystemScreen9.routeName,
    SystemScreen10.routeName,
    SystemScreen11.routeName,

    // Add more routes here
  ];

  List<Widget> screens = [
    SystemScreen1(),
    SystemScreen2(),
    SystemScreen3(),
    SystemScreen4(),
    SystemScreen5(),
    SystemScreen6(),
    SystemScreen66(),
    SystemScreen666(),
    SystemScreen7(),
    SystemScreen8(),
    SystemScreen9(),
    SystemScreen10(),
    SystemScreen11(),

    // Add more screen classes here
  ];

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
      drawer: CustomDrawer(),
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: routes[index]),
                        screen: screens[index],
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
                            imageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: imageUrls.length,
              ),
            ),

            /* SliverToBoxAdapter(
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
            ),*/

      ],
      ),
    );

  }
}
