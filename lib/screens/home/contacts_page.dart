import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens.dart';

class ContactsHome extends StatelessWidget {

  Future<void> _launchURL (String url) async{
    try {
      bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }

  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.deepOrange, size: fontExtraSize * 1.3),
        toolbarHeight: kToolbarHeight, // Ensure the toolbar height is set if needed
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              'assets/lottie/contacts_page.json',
              frameRate: FrameRate.max,
              height: screenHeight / 4.5,
            ),
          ),

          Container(
            child: Column(
              children: [
                //OFFICE LOCATED
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Text(
                      'MANILA Office',
                      style: TextStyle(
                          fontSize: fontXXSize,
                          fontFamily: 'Rowdies',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.deepOrange.shade600
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                //MAPS LOCATION OF OFFICE
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/backgrounds/mapqc.png"), fit: BoxFit.fill),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _launchURL("https://www.google.com/maps?ll=14.62891,121.028002&z=16&t=m&hl=en&gl=PH&mapclient=embed&cid=10169760891713574313");
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                    child: TextButton(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.location_on, size: (screenHeight + screenWidth) / 55, )),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                            TextSpan(
                              text: '  LOFICE I, #82 Scout Ojeda St., Brgy. Obrero Diliman, Quezon City 1103 Philippines',
                              style: TextStyle(color: Colors.black54, fontSize: fontNormalSize, fontWeight: FontWeight.bold, letterSpacing: 1.2, overflow: TextOverflow.visible,),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        _launchURL("https://www.google.com/maps?ll=14.62891,121.028002&z=16&t=m&hl=en&gl=PH&mapclient=embed&cid=10169760891713574313");
                      },
                    ),
                  ),
                ),

                //EMAIL ME
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final toEmail  = 'enyecontrols@enyecontrols.com';
                        final url = 'mailto:$toEmail';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.mail, size: (screenHeight + screenWidth) / 55,),
                      label: Text('enyecontrols@enyecontrols.com',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

                //Contact
                Container(
                  margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: (){
                          final phoneNumber  = '+639176317175';
                          final url = 'tel:$phoneNumber';

                          _launchURL(url);
                        },
                        icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                        label: Text('+63 917 631 7175',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: fontNormalSize,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.visible,),
                        ),
                      ),

                      Text(
                        '/',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),

                      TextButton(
                        onPressed: (){
                          final phoneNumber  = '(02) 7616 5949';
                          final url = 'tel:$phoneNumber';

                          _launchURL(url);
                    },
                        child: Text(
                          '(02) 7616-5949',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: fontNormalSize,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.visible,),
                        ),
                      )
                    ],
                  ),
                ),

                //fax
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final faxNumber = '8352-3250';
                        final url = 'fax:$faxNumber';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.fax, size: (screenHeight + screenWidth) / 55,),
                      label: Text('8352-3250',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //CEBU OFFICE DATA
          Container(
            child: Column(
              children: [

                //OFFICE LOCATED
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Text(
                      'CEBU Office',
                      style: TextStyle(
                          fontSize: fontXXSize,
                          fontFamily: 'Rowdies',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.deepOrange.shade600
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                //MAPS LOCATION OF OFFICE
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/backgrounds/mapcebu.png"), fit: BoxFit.fill),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                    child: TextButton(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.location_on, size: (screenHeight + screenWidth) / 55, )),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                            TextSpan(
                              text: '  LOFICE II, Lot 5, Blk 7, Phase 2 Sta. Lucia Town Square Consolacion, Cebu 6001 Philippines',
                              style: TextStyle(color: Colors.black54, fontSize: fontNormalSize, fontWeight: FontWeight.bold, letterSpacing: 1.2, overflow: TextOverflow.visible,),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        _launchURL("https://www.google.com/maps/place/Enye+Ltd+Corporation/@10.3729606,123.9570973,20z/data=!4m15!1m8!3m7!1s0x33a9a2a3893d39cf:0xd458b729586d3abe!2sSta.+Lucia+Town+Square,+Consolacion,+6001+Cebu!3b1!8m2!3d10.3736865!4d123.9580107!16s%2Fg%2F11c1_vj9rn!3m5!1s0x33a9a31aad4a80b7:0x99af3a18c21847f6!8m2!3d10.3728218!4d123.9569089!16s%2Fg%2F11rbx51pzj?entry=ttu");
                      },
                    ),
                  ),
                ),

                //EMAIL ME
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final toEmail  = 'enyecontrols@enyecontrols.com';
                        final url = 'mailto:$toEmail';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.mail, size: (screenHeight + screenWidth) / 55,),
                      label: Text('enyecontrols@enyecontrols.com',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

                //Contact
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final phoneNumber  = '+63322658117';
                        final url = 'tel:$phoneNumber';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                      label: Text('+63 32 265 8117',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          //LAGUNA OFFICE DATA
          Container(
            child: Column(
              children: [

                //OFFICE LOCATED
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Text(
                      'SOUTH Office',
                      style: TextStyle(
                          fontSize: fontXXSize,
                          fontFamily: 'Rowdies',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.deepOrange.shade600
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                //MAPS LOCATION OF OFFICE
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/backgrounds/maplaguna.png"), fit: BoxFit.fill),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _launchURL("https://www.google.com/maps/place/5,+12+P.+Ocampo+Ave,+San+Pedro,+Laguna/@14.3419666,121.0628213,17z/data=!4m9!1m2!2m1!1sLot+5,+Blk+12,+P.+Ocampo+St.,+Ph.+7+Pacita+San+Vicente+San+Pedro,+Laguna!3m5!1s0x3397d74f3c2103ad:0x85c44f2ca56fa9a6!8m2!3d14.3419146!4d121.0630895!15sCkhMb3QgNSwgQmxrIDEyLCBQLiBPY2FtcG8gU3QuLCBQaC4gNyBQYWNpdGEgU2FuIFZpY2VudGUgU2FuIFBlZHJvLCBMYWd1bmGSARBjb21wb3VuZF9zZWN0aW9u4AEA?entry=ttu");
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0),
                    child: TextButton(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.location_on, size: (screenHeight + screenWidth) / 55, )),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                            TextSpan(
                              text: '  Lot 5, Blk 12, P. Ocampo St., Ph. 7 Pacita San Vicente San Pedro, Laguna 4023 Philippines',
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: fontNormalSize, letterSpacing: 1.2, overflow: TextOverflow.visible,),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        _launchURL("https://www.google.com/maps/place/5,+12+P.+Ocampo+Ave,+San+Pedro,+Laguna/@14.3419666,121.0628213,17z/data=!4m9!1m2!2m1!1sLot+5,+Blk+12,+P.+Ocampo+St.,+Ph.+7+Pacita+San+Vicente+San+Pedro,+Laguna!3m5!1s0x3397d74f3c2103ad:0x85c44f2ca56fa9a6!8m2!3d14.3419146!4d121.0630895!15sCkhMb3QgNSwgQmxrIDEyLCBQLiBPY2FtcG8gU3QuLCBQaC4gNyBQYWNpdGEgU2FuIFZpY2VudGUgU2FuIFBlZHJvLCBMYWd1bmGSARBjb21wb3VuZF9zZWN0aW9u4AEA?entry=ttu");
                      },
                    ),
                  ),
                ),

                //EMAIL ME
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final toEmail  = 'enyecontrols@enyecontrols.com';
                        final url = 'mailto:$toEmail';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.mail, size: (screenHeight + screenWidth) / 55,),
                      label: Text('enyecontrols@enyecontrols.com',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

                //Contact
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final phoneNumber  = '+639176345225';
                        final url = 'tel:$phoneNumber';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                      label: Text('+63 917 634 5225',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          //WAREHOUSE
          Container(
            child: Column(
              children: [

                //OFFICE LOCATED
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Text(
                      'WAREHOUSE',
                      style: TextStyle(
                          fontSize: fontXXSize,
                          fontFamily: 'Rowdies',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.deepOrange.shade600
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                //MAPS LOCATION OF OFFICE
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/backgrounds/mapwarehouse.png"), fit: BoxFit.fill),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _launchURL("https://www.google.com/maps/place/14%C2%B037'18.6%22N+121%C2%B008'06.5%22E/@14.621404,121.1344085,19z/data=!4m4!3m3!8m2!3d14.621834!4d121.135147?entry=ttu&g_ep=EgoyMDI0MTAyMi4wIKXMDSoASAFQAw%3D%3D");
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20.0),
                    child: TextButton(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.location_on, size: (screenHeight + screenWidth) / 55, )),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                            TextSpan(
                              text: '  Blk 4 Lot 10 Agnes Ville Subd. Brgy. Mambugan Antipolo, Rizal 1870 Philippines',
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: fontNormalSize, letterSpacing: 1.2, overflow: TextOverflow.visible,),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        _launchURL("https://www.google.com/maps/place/14%C2%B037'18.6%22N+121%C2%B008'06.5%22E/@14.621404,121.1344085,19z/data=!4m4!3m3!8m2!3d14.621834!4d121.135147?entry=ttu&g_ep=EgoyMDI0MTAyMi4wIKXMDSoASAFQAw%3D%3D");
                      },
                    ),
                  ),
                ),

                //EMAIL ME
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final toEmail  = 'enyecontrols@enyecontrols.com';
                        final url = 'mailto:$toEmail';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.mail, size: (screenHeight + screenWidth) / 55,),
                      label: Text('enyecontrols@enyecontrols.com',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

                //Contact
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: TextButton.icon(
                      onPressed: (){
                        final phoneNumber  = '(02) 7005 9675';
                        final url = 'tel:$phoneNumber';

                        _launchURL(url);
                      },
                      icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                      label: Text('(02) 7005-9675',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.05,),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
              height: screenHeight * 0.07,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.deepOrange),
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment,
                    size: fontExtraSize * 1.3,
                    color: Colors.deepOrange,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Report a Feedback",
                    style: TextStyle(
                      fontSize: fontExtraSize,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 60,),
        ],
      ),
    );
  }
}

