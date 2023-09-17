import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MatchItem {
  final String matchTitle;
  final String matchFormat;
  final String team1Name;
  final String team1Score;
  final String team2Name;
  final String team2Score;
  final String matchResult;
  final String team1Flag;
  final String team2Flag;

  MatchItem({
    required this.matchTitle,
    required this.matchFormat,
    required this.team1Name,
    required this.team1Score,
    required this.team2Name,
    required this.team2Score,
    required this.matchResult,
    required this.team1Flag,
    required this.team2Flag,
  });
}

class LiveScoreScreen extends StatefulWidget {
  const LiveScoreScreen({super.key});

  @override
  State<LiveScoreScreen> createState() => _LiveScoreScreenState();
}

class _LiveScoreScreenState extends State<LiveScoreScreen> {
  final List<MatchItem> matchItems = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
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
        final link =
            matchCardElement.querySelector('a[href]')?.attributes['href'] ?? '';

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

        print('Match Title: $matchTitle');
        print('Match Format: $matchFormat');
        print('Team 1 Name: $team1Name');
        print('Team 1 Score: $team1Score');
        print('Team 2 Name: $team2Name');
        print('Team 2 Score: $team2Score');
        print('Match Result: $matchResult');
        print('Team 1 Image URL: $team1Flag');
        print('Team 2 Image URL: $team2Flag');
        print('Match Link: $link');
        // print('Time: $date');

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
      appBar: AppBar(),
      body: matchItems.isEmpty
          ? Center(
              child: LoadingAnimationWidget.horizontalRotatingDots(
                size: 50,
                color: Color.fromARGB(255, 114, 255, 48),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              backgroundColor: Color.fromARGB(255, 15, 19, 1),
              color: Color.fromARGB(255, 114, 255, 48),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    CarouselSlider.builder(
                      itemCount: matchItems.length,
                      itemBuilder: (context, index, realIndex) {
                        final matchItem = matchItems[index];
                        return Container(
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
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          matchItem.matchTitle,
                                          style: TextStyle(
                                              color: Colors.white,
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
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        matchItem.matchFormat,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SpaceGrotesk-Regular'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Image.network(
                                              'https://www.cricbuzz.com/${matchItem.team1Flag}'),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                matchItem.team1Name,
                                                style: TextStyle(
                                                    fontFamily:
                                                        'SpaceGrotesk-Regular',
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            matchItem.team1Score,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mulish-ExtraBold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Image.network(
                                              'https://www.cricbuzz.com/${matchItem.team2Flag}'),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                matchItem.team2Name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'SpaceGrotesk-Regular',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            matchItem.team2Score,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mulish-ExtraBold'),
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      matchItem.matchResult,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: 'SpaceGrotesk-Regular',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: matchItems.asMap().entries.map(
                          (e) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(e.key),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Color.fromARGB(255, 114, 255, 48))
                                      .withOpacity(
                                          _current == e.key ? 0.9 : 0.4),
                                ),
                              ),
                            );
                          },
                        ).toList()),
                  ],
                ),
              ),
            ),
    );
  }
}



// ListView.builder(
//         itemCount: matchItems.length,
//         itemBuilder: (context, index) {
//           final matchItem = matchItems[index];
//           return Column(
//             children: [
//               SizedBox(
//                 height: 10.h,
//               ),
//               Text(
//                 'Match Title: ${matchItem.matchTitle}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 'Match format: ${matchItem.matchFormat}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 'Team 1 Name: ${matchItem.team1Name}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 'Team 1 Score: ${matchItem.team1Score}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 'Team 2 Name: ${matchItem.team2Name}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 'Team 2 Score: ${matchItem.team2Score}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Text(
//                 'Match Result: ${matchItem.matchResult}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Image.network('https://www.cricbuzz.com/${matchItem.team1Flag}'),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Image.network('https://www.cricbuzz.com/${matchItem.team2Flag}'),
//               SizedBox(
//                 height: 10.h,
//               ),
//             ],
//           );
//         },
//       )
