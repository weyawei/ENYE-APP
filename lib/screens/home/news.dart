import 'dart:math';

import 'package:enye_app/screens/product/productsvc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../config/api_connection.dart';
import '../../widget/custom_appbar.dart';
import '../product/detailed_product.dart';


class FullArticleNews extends StatefulWidget {
  late final news newsletter;
  final int selectedIndex;
  FullArticleNews({required this.newsletter, required this.selectedIndex});

  @override
  State<FullArticleNews> createState() => _FullArticleNewsState();
}

class _FullArticleNewsState extends State<FullArticleNews> {
  late news newsletter;

  @override
  void initState() {
    super.initState();
    newsletter = widget.newsletter;
    _news = [];
    _getNews();
  }

  late List<news> _news;
  _getNews(){
    productService.getProductNews().then((News){
      setState(() {
        _news = News;
      });
    //  _isLoadingProj = false;
      print("Length ${News.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("${API.projectsImage + newsletter.news_image}"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(height: 20),
            // Title
            Text(
              newsletter.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Description
            Text(
              newsletter.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("${API.projectsImage + newsletter.content_image}"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(height: 20),
            Text(
              newsletter.content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "More News",
                    style: TextStyle(
                      fontFamily: "Rowdies",
                      fontSize: MediaQuery.of(context).size.width * 0.065,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: min(_news.length, 3),
                    itemBuilder: (context, index) {
                      if (index == widget.selectedIndex) {
                        return Container(); // Skip the selected news item
                      }
                      final news = _news[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullArticleNews(newsletter: news, selectedIndex: index,),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image at the top
                              Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                  image: DecorationImage(
                                    image: NetworkImage("${API.projectsImage + news.news_image}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Text below the image
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news.title,
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    news.isExpanded
                                        ? Text(
                                      news.description,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 1,
                                        color: Colors.black,
                                      ),
                                    )
                                        : RichText(
                                      text: TextSpan(
                                        text: news.description.length > 100
                                            ? news.description.substring(0, 100)
                                            : news.description,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.03,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 1,
                                          color: Colors.black,
                                        ),
                                        children: news.description.length > 100
                                            ? [
                                          TextSpan(
                                            text: '... See More',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width * 0.03,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  news.isExpanded = true;
                                                });
                                              },
                                          ),
                                        ]
                                            : [],
                                      ),
                                    ),
                                    if (news.description.length > 100 && news.isExpanded)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            news.isExpanded = !news.isExpanded;
                                          });
                                        },
                                        child: Text(
                                          news.isExpanded ? "See Less" : "",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.028,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

