
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
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

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
      backgroundColor: Colors.white,
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
                _news[0].description,
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
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,),
                child: Column(
                  children: [
                    NewsContent.content_image.isEmpty
                    ? SizedBox.shrink()
                    : GestureDetector(
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

                    NewsContent.description.isEmpty
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015
                        ),
                        child: Text(
                          NewsContent.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: fontExtraSize,
                            letterSpacing: 0.5,
                            height: 1.8,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            SizedBox(height: screenHeight * 0.1),

            _allNews.length == 0
            ? SizedBox.shrink()
            : Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "More News",
                      style: TextStyle(
                        fontFamily: "Rowdies",
                        fontSize: fontXXXSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        letterSpacing: 1.2
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),
                  ListView.builder(
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
                          margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image at the top
                              Container(
                                width: double.infinity,
                                height: screenHeight * 0.1,
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.025,
                                  vertical: screenHeight * 0.025,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news.title,
                                      style: TextStyle(
                                        fontSize: fontExtraSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                        letterSpacing: 1.2,
                                        height: 1.75
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    news.isExpanded
                                        ? Text(
                                      news.description,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: fontNormalSize,
                                        letterSpacing: 1.2,
                                        color: Colors.grey.shade700,
                                        height: 1.75
                                      ),
                                    )
                                        : RichText(
                                      text: TextSpan(
                                        text: news.description.length > 100
                                            ? news.description.substring(0, 100)
                                            : news.description,
                                        style: TextStyle(
                                            fontSize: fontNormalSize,
                                            letterSpacing: 1.2,
                                            color: Colors.grey.shade700,
                                            height: 1.75
                                        ),
                                        children: news.description.length > 100
                                            ? [
                                          TextSpan(
                                            text: '... See More',
                                            style: TextStyle(
                                              fontSize: fontNormalSize,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.blueAccent,
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
                                            fontSize: fontNormalSize,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blueAccent,
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

