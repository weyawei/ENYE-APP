import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widget/widgets.dart';
import '../../screens.dart';

class Onbording extends StatefulWidget {
  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: screenLayout
                    ? EdgeInsets.all((screenHeight + screenWidth) / 40)
                    : EdgeInsets.all((screenHeight + screenWidth) / 80),
                  child: Column(
                    children: [
                      Center(
                        child: CarouselSlider(
                          items: contents[i].image.map((contentImage){
                            return Center(
                              child: Image.asset(
                                contentImage, // Use the first image in the list for each content
                                width: (screenHeight + screenWidth) / 6,
                                height: (screenHeight + screenWidth) / 5,
                                fit: BoxFit.contain,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            scrollDirection: Axis.vertical,
                            aspectRatio: 1,
                            autoPlayInterval: const Duration(seconds: 7),
                            viewportFraction: 1,
                          ),
                        ),
                      ),
                      Text(
                        contents[i].title,
                        style: GoogleFonts.rowdies(
                          textStyle: TextStyle(
                            fontSize: fontExtraSize,
                            letterSpacing: 1.5,
                            color: Colors.black54
                          ),
                        ),
                      ),
                      SizedBox(height: screenLayout ? screenHeight * 0.05 : screenHeight * 0.01),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: fontNormalSize,
                            letterSpacing: 1.5,
                            color: Colors.grey
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),

          currentIndex == contents.length - 1
          ? Container(
            height: screenHeight * 0.06,
            margin: EdgeInsets.only(
                left: screenWidth * 0.2,
                right: screenWidth * 0.2,
                top: screenWidth * 0.05,
                bottom: screenHeight * 0.07
            ),
            width: double.infinity,
            child: TextButton(
              child: Text(
                currentIndex == contents.length - 1 ? "DONE" : "Next",
                style: GoogleFonts.rowdies(
                  textStyle: TextStyle(
                      fontSize: fontExtraSize,
                      color: Colors.white,
                      letterSpacing: 0.8
                  ),
                ),
              ),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pop(context);
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
          : SizedBox.shrink(),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.015,
      width: currentIndex == index
          ? MediaQuery.of(context).size.width * 0.09
          : MediaQuery.of(context).size.width * 0.03,
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.height * 0.05
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}