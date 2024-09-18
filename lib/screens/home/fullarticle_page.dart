import 'dart:math';

import 'package:enye_app/screens/home/model_data/news_data.dart';
import 'package:enye_app/screens/product/productsvc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../config/api_connection.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/widgets.dart';
import '../product/detailed_product.dart';
import '../screens.dart';


class FullArticlePage extends StatefulWidget {
  final String news_id;

  FullArticlePage({
    super.key,
    required this.news_id
  });

  @override
  State<FullArticlePage> createState() => _FullArticlePageState();
}

class _FullArticlePageState extends State<FullArticlePage> {
  @override
  void initState() {
    super.initState();
    _allNews= [];
    _getAllNews();

    _news = [];
    _getNews();

    _newsContent = [];
    _getNewsContent();
  }

  bool _isLoadingAllNews = true;
  late List<NewsUpdates> _allNews;
  _getAllNews(){
    NewsServices.getNewsUpdates().then((NewsUpdates){
      setState(() {
        _allNews = NewsUpdates.where((element) => element.id != widget.news_id).toList();
      });
      _isLoadingAllNews = false;
      print("Length ${NewsUpdates.length}");
    });
  }

  late List<NewsUpdates> _news;
  bool _isLoadingNews = true;
  _getNews(){
    NewsServices.getNewsArticle(widget.news_id.toString()).then((News){
      setState(() {
        _news = News;
      });
       _isLoadingNews = false;
      print("Length ${News.length}");
    });
  }

  late List<NewsContents> _newsContent;
  bool _isLoadingNewsContent = true;
  _getNewsContent(){
    NewsServices.getNewsContent(widget.news_id.toString()).then((NewsContent){
      setState(() {
        _newsContent = NewsContent;
      });
      _isLoadingNewsContent = false;
      print("Length ${NewsContent.length}");
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: screenHeight * 0.05,),
      body: _isLoadingNews || _isLoadingNewsContent || _isLoadingAllNews
        ? Center(child: CircularProgressIndicator())
        : ListView(
          children: [
            Image(
              image: NetworkImage("${API.newsImages + _news[0].news_image}"),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.01
              ),
              child: Text(
                _news[0].title,
                style: TextStyle(
                  fontSize: fontXXSize,
                  letterSpacing: 0.8,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.01
              ),
              child: Text(
                "\t\t\t\t" + _news[0].description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: fontExtraSize,
                  letterSpacing: 0.8,
                  height: 1.75,
                  color: Colors.grey.shade800,
                ),
              ),
            ),

            ..._newsContent.map((NewsContent) {
              return Column(
                children: [
                  NewsContent.content_image.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.025
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImage(imagePath: "${API.newsImages + NewsContent.content_image}",),
                            ),
                          );
                        },
                        child: Image(
                          image: NetworkImage("${API.newsImages + NewsContent.content_image}"),
                        ),
                      ),
                    ),

                  NewsContent.description.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.01
                      ),
                      child: Text(
                        "\t\t\t\t" + NewsContent.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: fontExtraSize,
                          letterSpacing: 0.8,
                          height: 1.75,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                ],
              );
            }),

            SizedBox(height: 40),

            _allNews.length == 0
            ? SizedBox.shrink()
            : Container(
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
                    itemCount: _allNews.length,
                    itemBuilder: (context, index) {
                      final news = _allNews[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullArticlePage(news_id: news.id.toString()),
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
                                    image: NetworkImage("${API.newsImages + news.news_image}"),
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
    );
  }
}

