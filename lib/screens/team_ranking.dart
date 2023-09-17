import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TeamRanking extends StatefulWidget {
  const TeamRanking({super.key});

  @override
  State<TeamRanking> createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> {
  List<String> testTeamNames = [];
  List<String> odiTeamNames = [];
  List<String> t20TeamNames = [];

  List<String> testTeamRating = [];
  List<String> odiTeamRating = [];
  List<String> t20TeamRating = [];

  List<String> testTeamPoints = [];
  List<String> odiTeamPoints = [];
  List<String> t20TeamPoints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCricketRankings();
  }

  Future<void> fetchCricketRankings() async {
    if (!mounted) {
      // Check if the widget is still mounted before proceeding
      return;
    }
    // Set isLoading to true before fetching data
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://www.cricbuzz.com/cricket-stats/icc-rankings/men/teams'));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final teamNameElements =
          document.querySelectorAll('.cb-col.cb-col-50.cb-lst-itm-sm');
      final teamRatingElements =
          document.querySelectorAll('.cb-col.cb-col-14.cb-lst-itm-sm');
      final teamPointsElements = document
          .querySelectorAll('.cb-col.cb-col-14.cb-lst-itm-sm:last-child');

      final List<String> allTeamNames =
          teamNameElements.map((element) => element.text).toList();
      final List<String> allTeamPoints =
          teamPointsElements.map((element) => element.text).toList();

      // Divide the teams into Test, ODI, and T20 based on their ratings
      for (var i = 0; i < teamRatingElements.length; i++) {
        if (i % 2 == 0) {
          var value = teamRatingElements[i].text;
          if (i < 20) {
            testTeamRating.add(value);
          } else if (i < 40) {
            odiTeamRating.add(value);
          } else if (i > 56 && i < 78) {
            t20TeamRating.add(value);
          }
        }
      }

      // Divide the teams into Test, ODI, and T20 based on their names and points
      for (var i = 0; i < allTeamNames.length; i++) {
        if (i < 10) {
          print("Number of player names: ${allTeamNames.length}");

          testTeamNames.add(allTeamNames[i]);
          testTeamPoints.add(allTeamPoints[i]);
        } else if (i < 20) {
          odiTeamNames.add(allTeamNames[i]);
          odiTeamPoints.add(allTeamPoints[i]);
        } else if (i < 30) {
          t20TeamNames.add(allTeamNames[i + 9]);
          t20TeamPoints.add(allTeamPoints[i + 9]);
        }
      }
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }

      setState(() {
        // No need to set state for allPlayerNames as we separated them into different lists
        isLoading = false;
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      if (!mounted) {
        // Check if the widget is still mounted before calling setState
        return;
      }
      setState(() {
        isLoading = false; // Set isLoading to false in case of failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 19, 1),
        appBar: AppBar(
          toolbarHeight: 90.h,
          bottom: TabBar(
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 114, 255, 48)),
            tabs: [
              Tab(
                child: Text(
                  'TEST',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'ODI',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'T20I',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
            ],
          ), // TabBar
          title: Text(
            'Team Rankings',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Mulish-ExtraBold'),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ), // AppBar
        body: Stack(
          children: [
            Image.asset(
              'assets/images/blur backgroung.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            TabBarView(
              children: [
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          size: 50,
                          color: Color.fromARGB(255, 114, 255, 48),
                        ),
                      )
                    : ListView(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Ratings',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 114, 255, 48),
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  'Points',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 114, 255, 48),
                                    fontSize: 14.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: testTeamNames.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                horizontalTitleGap: 4,
                                leading: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                                title: Text(
                                  testTeamNames[index],
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Mulish-ExtraBold',
                                      color: Colors.white),
                                ),
                                trailing: Container(
                                  width: 110.w,
                                  child: Row(
                                    children: [
                                      Text(testTeamRating[index],
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              color: Colors.white)),
                                      SizedBox(width: 45.w),
                                      Text(testTeamPoints[index],
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          size: 50,
                          color: Color.fromARGB(255, 114, 255, 48),
                        ),
                      )
                    : ListView(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Ratings',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 114, 255, 48),
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  'Points',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 114, 255, 48),
                                    fontSize: 14.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: odiTeamNames.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                horizontalTitleGap: 4,
                                leading: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                                title: Text(
                                  odiTeamNames[index],
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Mulish-ExtraBold',
                                      color: Colors.white),
                                ),
                                trailing: Container(
                                  width: 110.w,
                                  child: Row(
                                    children: [
                                      Text(odiTeamRating[index],
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              color: Colors.white)),
                                      SizedBox(width: 45.w),
                                      Text(odiTeamPoints[index],
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          size: 50,
                          color: Color.fromARGB(255, 114, 255, 48),
                        ),
                      )
                    : ListView(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Ratings',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 114, 255, 48),
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  'Points',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 114, 255, 48),
                                    fontSize: 14.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: t20TeamNames.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                horizontalTitleGap: 4,
                                leading: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                  ),
                                ),
                                title: Text(
                                  t20TeamNames[index],
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Mulish-ExtraBold',
                                      color: Colors.white),
                                ),
                                trailing: Container(
                                  width: 110.w,
                                  child: Row(
                                    children: [
                                      Text(t20TeamRating[index],
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              color: Colors.white)),
                                      SizedBox(width: 45.w),
                                      Text(t20TeamPoints[index],
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  'SpaceGrotesk-Regular',
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
