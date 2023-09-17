import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class NewsItemMain {
  final String imageUrl;
  final String category;
  final String title;
  final String summary;
  final String time;
  final String articleUrl;

  NewsItemMain({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.summary,
    required this.time,
    required this.articleUrl,
  });
}

class NewsItemSub {
  final String imageUrl;
  final String category;
  final String title;
  final String time;
  final String articleUrl;

  NewsItemSub({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.time,
    required this.articleUrl,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<NewsItemSub> newsItemsSub = [];
  final List<NewsItemMain> newsItemsMain = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://www.icc-cricket.com/news'));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final divElementsSub = document.querySelectorAll(
          '.sticky-hero-list__item.col-12-phab.col-6-tab.col-12-desk.col-6');

      for (var divElement in divElementsSub) {
        final anchorElement =
            divElement.querySelector('a.thumbnail.thumbnail--sticky-secondary');
        // final figureElement = divElement.querySelector('figure');
        final imageElement = anchorElement!.querySelector('.thumbnail__image');
        final captionElement =
            anchorElement.querySelector('.thumbnail__caption');
        final categoryElement =
            captionElement!.querySelector('.thumbnail__category');
        final titleElement = captionElement.querySelector('.thumbnail__title');
        final timeElement = captionElement.querySelector('.thumbnail__time');

        final imageUrl = imageElement!.attributes['data-image-src'];
        final category = categoryElement!.text;
        final title = titleElement!.text;
        final time = timeElement!.text.trim();
        final articleUrl = anchorElement.attributes['href'];

        newsItemsSub.add(NewsItemSub(
          imageUrl: imageUrl!,
          category: category,
          title: title,
          time: time,
          articleUrl: articleUrl!,
        ));

        print('Image URL: ${imageUrl.length}');
        print('Category: ${category.length}');
        print('Title: ${title.length}');
        print('Time: ${time.length}');
      }

      final divElementsMain = document.querySelectorAll(
          '.sticky-hero-list__column.sticky-hero-list__column--primary');

      for (var divElement in divElementsMain) {
        final anchorElement = divElement.querySelector(
            'a.thumbnail.thumbnail--hero.thumbnail--sticky-hero');
        final imageElement =
            anchorElement!.querySelector('img.thumbnail__image');
        final captionElement =
            anchorElement.querySelector('.thumbnail__caption');
        final categoryElement =
            captionElement!.querySelector('.thumbnail__category');
        final titleElement = captionElement.querySelector('.thumbnail__title');
        final summaryElement =
            captionElement.querySelector('.thumbnail__summary');
        final timeElement = captionElement.querySelector('.thumbnail__time');

        final imageUrl = imageElement!.attributes['src'];
        final category = categoryElement!.text;
        final title = titleElement!.text;
        final summary = summaryElement!.text;
        final time = timeElement!.text.trim();
        final articleUrl = anchorElement.attributes['href'];

        newsItemsMain.add(NewsItemMain(
          imageUrl: imageUrl!,
          category: category,
          title: title,
          summary: summary,
          time: time,
          articleUrl: articleUrl!,
        ));

        print('Image URL: ${imageUrl.length}');
        print('Category: ${category.length}');
        print('Title: ${title.length}');
        print('Summary: ${summary.length}');
        print('Time: ${time.length}');
      }
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch news: ${response.statusCode}');
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }
      setState(() {
        isLoading = false; // Set isLoading to false in case of failure
      });
    }
  }

  void _openFullArticle(String articleUrl) async {
    // Launch the player's profile URL in the web browser
    var cricketNewsUri = Uri.parse('https://www.icc-cricket.com/$articleUrl');
    if (await canLaunchUrl(cricketNewsUri)) {
      await launchUrl(cricketNewsUri);
    } else {
      throw 'Could not launch $articleUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 19, 1),
        body: isLoading
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: LoadingAnimationWidget.horizontalRotatingDots(
                    size: 50,
                    color: Color.fromARGB(255, 114, 255, 48),
                  ),
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color.fromARGB(255, 15, 19, 1),
                    centerTitle: true,
                    pinned: true,
                    floating: true,
                    expandedHeight: 160.0.h,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Cricket News',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Mulish-ExtraBold',
                          color: Colors.white,
                        ),
                      ),
                      centerTitle: true,
                      expandedTitleScale: 2,
                      background: Image.asset(
                        'assets/images/backgroun_cricket_image3.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Rectangle 6370.png'),
                                fit: BoxFit.cover)),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: newsItemsMain.length,
                              itemBuilder: (context, index) {
                                final newsItem = newsItemsMain[index];
                                return InkWell(
                                  onTap: () {
                                    _openFullArticle(newsItem.articleUrl);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Icon(
                                                CupertinoIcons.doc_text,
                                                size: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                newsItem.category,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 114, 255, 48),
                                                  fontFamily:
                                                      'SpaceGrotesk-Regular',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.network(newsItem.imageUrl),
                                        const SizedBox(height: 8),
                                        Text(
                                          newsItem.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Mulish-ExtraBold',
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          newsItem.summary,
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'SpaceGrotesk-Regular',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          newsItem.time,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'SpaceGrotesk-Regular',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Divider(
                              endIndent: 16,
                              indent: 16,
                              color: Colors.white,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: newsItemsSub.length,
                              itemBuilder: (context, index) {
                                final newsItem = newsItemsSub[index];
                                log('message ${newsItemsSub.length}');
                                return InkWell(
                                  onTap: () {
                                    _openFullArticle(newsItem.articleUrl);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.doc_text,
                                              size: 17,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                newsItem.category,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 114, 255, 48)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Image.network(newsItem.imageUrl),
                                        SizedBox(height: 10.h),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          newsItem.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Mulish-ExtraBold',
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          newsItem.time,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'SpaceGrotesk-Regular',
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )),
                ],
              ));
  }
}
