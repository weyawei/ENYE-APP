import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return Column(
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
                    'Quezon City Office',
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
                            text: '  Lofice 1, 82 Scout Ojeda St., Brgy. Obrero Diliman, Quezon City. 1103 Philippines',
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

              //Contact Sales Eng.
              Padding(
                padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: (){
                            final phoneNumber  = '+63976165949';
                            final url = 'tel:$phoneNumber';

                            _launchURL(url);
                          },
                          icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                          label: Text('(02)7616-5949',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: fontNormalSize,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.visible,),
                          ),
                        ),

                        Text(' ', style: TextStyle(color: Colors.black54,fontSize: fontExtraSize,letterSpacing: 1.2,fontWeight: FontWeight.bold, overflow: TextOverflow.visible,),),

                        TextButton(
                          onPressed: (){
                            final phoneNumber  = '(02)8352-3250';
                            final url = 'tel:$phoneNumber';

                            _launchURL(url);
                          },
                          child: Text('(02) 8352-3250',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: fontNormalSize,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.visible,),
                          ),
                        ),
                      ],
                    ),

                  ],
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
                            text: '  Lofice 2, Lot 5, Blk 7, Phase 2 Sta. Lucia Town Square Consolacion, Cebu 6001 Philippines',
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
                      final toEmail  = 'pearlguevarra.enyecontrols@gmail.com';
                      final url = 'mailto:$toEmail';

                      _launchURL(url);
                    },
                    icon: Icon(Icons.mail, size: (screenHeight + screenWidth) / 55,),
                    label: Text('pearlguevarra.enyecontrols@gmail.com',
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
                      final phoneNumber  = '(+032)4231759';
                      final url = 'tel:$phoneNumber';

                      _launchURL(url);
                    },
                    icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                    label: Text('(+032) 423-1759',
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
                    'LAGUNA Office',
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
                    _launchURL("https://www.google.com/maps/place/14%C2%B020'46.4%22N+121%C2%B003'20.7%22E/@14.3463273,121.0552596,18.75z/data=!4m4!3m3!8m2!3d14.3462222!4d121.05575?entry=ttu");
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
                            text: 'Lofice 3, Lot 6, Blk 17, Pacita Ave Pacita Complex, San Vicente San Pedro, Laguna 4023 Philippines',
                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: fontNormalSize, letterSpacing: 1.2, overflow: TextOverflow.visible,),
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
                  margin: EdgeInsets.only(left: 20.0),
                  padding: EdgeInsets.only(top: 5.0),
                  child: TextButton.icon(
                    onPressed: (){
                      final toEmail  = 'janice.capinpin@enyecontrols.com';
                      final url = 'mailto:$toEmail';

                      _launchURL(url);
                    },
                    icon: Icon(Icons.mail, size: (screenHeight + screenWidth) / 55,),
                    label: Text('janice.capinpin@enyecontrols.com',
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
                      final phoneNumber  = '+639171387049';
                      final url = 'tel:$phoneNumber';

                      _launchURL(url);
                    },
                    icon: Icon(Icons.call, size: (screenHeight + screenWidth) / 55,),
                    label: Text('(+63) 917 138-7049',
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
      ],
    );
  }
}

