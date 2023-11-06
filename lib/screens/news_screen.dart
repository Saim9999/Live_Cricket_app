import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

import '../classes/commentary classes.dart';
import '../rough_screens/scorecard_rough.dart';
import 'scorecard/score_info_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<NewsItemSub> newsItemsSub = [];
  final List<NewsItemMain> newsItemsMain = [];
  final List<MatchItem> matchItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
    fetchMatches();
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

  Future<void> fetchMatches() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    final response = await http.get(
      Uri.parse('https://www.cricbuzz.com/'),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final matchCardElements = document
          .querySelectorAll('.cb-view-all-ga.cb-match-card.cb-bg-white');

      for (var matchCardElement in matchCardElements) {
        final matchHeaderElement = matchCardElement.querySelector(
            '.cb-mtch-crd-hdr .cb-col-90.cb-color-light-sec.cb-ovr-flo');
        final matchFormatElement =
            matchCardElement.querySelector('.cb-card-match-format');
        final team1NameElement = matchCardElement
            .querySelector('.cb-hmscg-tm-bat-scr.cb-font-14 span')!
            .attributes['title'];
        final team2NameElement = matchCardElement
            .querySelector('.cb-hmscg-tm-bwl-scr.cb-font-14 span')!
            .attributes['title'];
        final team1ScoreElement = matchCardElement
            .querySelector('.cb-col-50.cb-ovr-flo[style*="width:100%"]');
        final team2ScoreElement = matchCardElement.querySelector(
            '.cb-hmscg-tm-bwl-scr.cb-font-14 .cb-col-50.cb-ovr-flo[style*="width:100%"]');
        final matchResultElement =
            matchCardElement.querySelector('.cb-mtch-crd-state');
        final team1FlagElement =
            matchCardElement.querySelector('.cb-hmscg-tm-nm-img img');
        final team2FlagElement = matchCardElement.querySelector(
            '.cb-hmscg-tm-bwl-scr.cb-font-14 .cb-hmscg-tm-nm-img img');
        // final link =
        //     matchCardElement.querySelector('a[href]')?.attributes['href'] ?? '';
        final link = matchCardElement.querySelector('a');

        // Extract and print the content
        final matchTitle = matchHeaderElement?.text ?? '';
        final matchFormat = matchFormatElement?.text ?? '';
        final team1Name = team1NameElement;
        final team1Score = team1ScoreElement?.text ?? '';
        final team2Name = team2NameElement;
        final team2Score = team2ScoreElement?.text ?? '';
        final matchResult = matchResultElement?.text ?? '';
        final team1Flag = team1FlagElement?.attributes['src'] ?? '';
        final team2Flag = team2FlagElement?.attributes['src'] ?? '';
        final linkurl = link?.attributes['href'] ?? '';
        print('Match Link: $linkurl');

        matchItems.add(MatchItem(
          matchTitle: matchTitle,
          matchFormat: matchFormat,
          team1Name: team1Name!,
          team1Score: team1Score,
          team2Name: team2Name!,
          team2Score: team2Score,
          matchResult: matchResult,
          team1Flag: team1Flag,
          team2Flag: team2Flag,
          linkurl: linkurl,
        ));
      }
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }

      setState(() {});
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }
    }
  }

  Future<void> _refreshData() async {
    // For example, you can clear the existing data and fetch new data
    matchItems.clear();
    await fetchMatches();
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

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
                    expandedHeight: 200.0.h,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.none,
                        expandedTitleScale: 2,
                        background: matchItems.isEmpty
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  size: 50,
                                  color: Color.fromARGB(255, 114, 255, 48),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _refreshData,
                                backgroundColor: Color.fromARGB(255, 15, 19, 1),
                                color: Color.fromARGB(255, 114, 255, 48),
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                      CarouselSlider.builder(
                                        itemCount: matchItems.length,
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          final matchItem = matchItems[index];
                                          return InkWell(
                                            onTap: () async {
                                              String originalUrl =
                                                  "https://www.cricbuzz.com${matchItem.linkurl}";
                                              String scorecardUrl =
                                                  originalUrl.replaceFirst(
                                                      "/live-cricket-scores/",
                                                      "/live-cricket-scorecard/");
                                              String squaddUrl =
                                                  originalUrl.replaceFirst(
                                                      "/live-cricket-scores/",
                                                      "/cricket-match-squads/");
                                              Get.to(CompleteScore(
                                                url1: originalUrl,
                                                url2: scorecardUrl,
                                                url3: squaddUrl,
                                              ));
                                              print(
                                                  'Lint Url wwhdhwdh: $scorecardUrl');
                                            },
                                            child: Container(
                                              height: 200.h,
                                              width: 300.w,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Decorated container.png'),
                                                      fit: BoxFit.cover),
                                                  border: Border.all(
                                                    color: Colors.white24,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                              matchItem
                                                                  .matchTitle,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'SpaceGrotesk-Regular'),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Container(
                                                          height: 18.h,
                                                          width: 40.w,
                                                          decoration: BoxDecoration(
                                                              color: _getColorForMatchFormat(
                                                                  matchItem
                                                                      .matchFormat),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            matchItem
                                                                .matchFormat,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'SpaceGrotesk-Regular'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.network(
                                                                      'https://www.cricbuzz.com/${matchItem.team1Flag}'),
                                                                  SizedBox(
                                                                    width: 5.w,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Text(
                                                                        matchItem
                                                                            .team1Name,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'SpaceGrotesk-Regular',
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  matchItem
                                                                      .team1Score,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Mulish-ExtraBold'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                            // flex: 1,
                                                            child: Container(
                                                          height: 40.h,
                                                          width: 30.h,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/versus_image 1.png'))),
                                                        )),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Image.network(
                                                                      'https://www.cricbuzz.com/${matchItem.team2Flag}'),
                                                                  SizedBox(
                                                                    width: 5.w,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Text(
                                                                        matchItem
                                                                            .team2Name,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'SpaceGrotesk-Regular',
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  matchItem
                                                                      .team2Score,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Mulish-ExtraBold'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          matchItem.matchResult,
                                                          style: TextStyle(
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    152,
                                                                    26),
                                                            color: Colors.black,
                                                            fontSize: 16.sp,
                                                            fontFamily:
                                                                'SpaceGrotesk-Regular',
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        carouselController: _controller,
                                        options: CarouselOptions(
                                          height: 130.h,
                                          viewportFraction: 0.9,
                                          initialPage: 0,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: false,
                                          enlargeFactor: 0.3,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children:
                                              matchItems.asMap().entries.map(
                                            (e) {
                                              return GestureDetector(
                                                onTap: () => _controller
                                                    .animateToPage(e.key),
                                                child: Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Color.fromARGB(
                                                                255,
                                                                114,
                                                                255,
                                                                48))
                                                        .withOpacity(
                                                            _current == e.key
                                                                ? 0.9
                                                                : 0.4),
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList()),
                                    ],
                                  ),
                                ),
                              )),
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
                                        Text(
                                          'Latest News',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                            fontFamily: 'Mulish-ExtraBold',
                                          ),
                                        ),
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
                                        Image.network(
                                          newsItem.imageUrl,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/news_logo.jpg', // Replace with your fallback image
                                            );
                                          },
                                        ),
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
                                        Image.network(
                                          newsItem.imageUrl,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/news_logo.jpg', // Replace with your fallback image
                                            );
                                          },
                                        ),
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

  Color _getColorForMatchFormat(String format) {
    switch (format) {
      case 'ODI':
        return Colors.amber;
      case 'T20I':
        return Colors.blue;
      case 'Test':
        return Colors.red;
      case 'T20':
        return Colors.tealAccent;
      case 'List A':
        return Colors.orangeAccent;
      case 'FC':
        return Colors.pinkAccent;
      default:
        return Colors.green;
    }
  }
}
