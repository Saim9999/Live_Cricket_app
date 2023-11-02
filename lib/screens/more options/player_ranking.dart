// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerRanking extends StatefulWidget {
  final String url;
  const PlayerRanking({super.key, required this.url});

  @override
  State<PlayerRanking> createState() => _PlayerRankingState();
}

class _PlayerRankingState extends State<PlayerRanking> {
  List<String> testPlayerNames = [];
  List<String> odiPlayerNames = [];
  List<String> t20PlayerNames = [];
  bool isLoading = true;

  List<String> testPlayerImages = [];
  List<String> odiPlayerImages = [];
  List<String> t20PlayerImages = [];

  List<String> testPlayerUrls = [];
  List<String> odiPlayerUrls = [];
  List<String> t20PlayerUrls = [];

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

    final response = await http.get(Uri.parse(widget.url));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final playerNameElements =
          document.querySelectorAll('.cb-col.cb-col-50 a');
      final countryNameElements =
          document.querySelectorAll('.cb-font-12.text-gray');
      final ratingElements =
          document.querySelectorAll('.cb-col.cb-col-17.pull-right');
      final playerImageElements =
          document.querySelectorAll('.cb-col.cb-col-50 img');
      final playerUrlElement =
          document.querySelectorAll('.cb-col.cb-col-67.cb-rank-plyr a');

      final List<String> allPlayerNames =
          playerNameElements.map((element) => element.text).toList();
      final List<String> allCountryNames =
          countryNameElements.map((element) => element.text).toList();
      final List<String> allRatings =
          ratingElements.map((element) => element.text).toList();
      final List<String?> allPlayerImages = playerImageElements
          .map((element) => element.attributes['src'])
          .toList();
      final List<String?> allPlayerUrls = playerUrlElement
          .map((element) => element.attributes['href'])
          .toList();

      // Divide the players into Test, ODI, and T20 based on their ranks
      for (var i = 0; i < allPlayerNames.length; i++) {
        if (i < 10) {
          testPlayerNames.add(
              '${allPlayerNames[i]} (${allCountryNames[i]}) - Rating: ${allRatings[i + 1]}');
          testPlayerImages.add(allPlayerImages[i]!);
          testPlayerUrls.add(allPlayerUrls[i]!);
        } else if (i < 20) {
          odiPlayerNames.add(
              '${allPlayerNames[i]} (${allCountryNames[i]}) - Rating: ${allRatings[i + 2]}');
          odiPlayerImages.add(allPlayerImages[i - 0]!);
          odiPlayerUrls.add(allPlayerUrls[i - 0]!);
        } else if (i < 30) {
          t20PlayerNames.add(
              '${allPlayerNames[i]} (${allCountryNames[i]}) - Rating: ${allRatings[i + 3]}');
          t20PlayerImages.add(allPlayerImages[i]!);
          t20PlayerUrls.add(allPlayerUrls[i]!);
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
            'Player Rankings',
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
                    : ListView.builder(
                        itemCount: testPlayerNames.length,
                        itemBuilder: (context, index) {
                          // Split the player name , country name and rating
                          List<String> parts =
                              testPlayerNames[index].split(' - Rating: ');
                          String playerAndCountry = parts[0];
                          String rating = parts[1];

                          List<String> playerAndCountryParts =
                              playerAndCountry.split(' (');
                          String playerName = playerAndCountryParts[0];
                          String countryName = playerAndCountryParts[1]
                              .substring(
                                  0, playerAndCountryParts[1].length - 1);
                          return ListTile(
                            onTap: () async {
                              // Launch the player's profile URL in the web browser
                              var playerProfileUri = Uri.parse(
                                  'https://www.cricbuzz.com/${testPlayerUrls[index]}');
                              if (await canLaunchUrl(playerProfileUri)) {
                                await launchUrl(playerProfileUri);
                              } else {
                                print("Could not launch player profile.");
                              }
                            },
                            leading: Container(
                              width: 70.w,
                              height: 65.h,
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontFamily: 'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  CircleAvatar(
                                    // radius: 20,
                                    backgroundImage: NetworkImage(
                                      'https://www.cricbuzz.com/${testPlayerImages[index]}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              playerName,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Mulish-ExtraBold',
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              countryName,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                  color: Colors.grey),
                            ),
                            trailing: Text(rating,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                    color: Colors.white)),
                          );
                        },
                      ),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          size: 50,
                          color: Color.fromARGB(255, 114, 255, 48),
                        ),
                      )
                    : ListView.builder(
                        itemCount: odiPlayerNames.length,
                        itemBuilder: (context, index) {
                          // Split the player name , country name and rating
                          List<String> parts =
                              odiPlayerNames[index].split(' - Rating: ');
                          String playerAndCountry = parts[0];
                          String rating = parts[1];
                          List<String> playerAndCountryParts =
                              playerAndCountry.split(' (');
                          String playerName = playerAndCountryParts[0];
                          String countryName = playerAndCountryParts[1]
                              .substring(
                                  0, playerAndCountryParts[1].length - 1);
                          return ListTile(
                            onTap: () async {
                              // Launch the player's profile URL in the web browser
                              var playerProfileUri = Uri.parse(
                                  'https://www.cricbuzz.com/${odiPlayerUrls[index]}');
                              if (await canLaunchUrl(playerProfileUri)) {
                                await launchUrl(playerProfileUri);
                              } else {
                                print("Could not launch player profile.");
                              }
                            },
                            leading: Container(
                              width: 70.w,
                              height: 65.h,
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontFamily: 'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  CircleAvatar(
                                    // radius: 20,
                                    backgroundImage: NetworkImage(
                                      'https://www.cricbuzz.com/${odiPlayerImages[index]}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              playerName,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Mulish-ExtraBold',
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              countryName,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                  color: Colors.grey),
                            ),
                            trailing: Text(rating,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                    color: Colors.white)),
                          );
                        },
                      ),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          size: 50,
                          color: Color.fromARGB(255, 114, 255, 48),
                        ),
                      )
                    : ListView.builder(
                        itemCount: t20PlayerNames.length,
                        itemBuilder: (context, index) {
                          // Split the player name , country name and rating
                          List<String> parts =
                              t20PlayerNames[index].split(' - Rating: ');
                          String playerAndCountry = parts[0];
                          String rating = parts[1];

                          List<String> playerAndCountryParts =
                              playerAndCountry.split(' (');
                          String playerName = playerAndCountryParts[0];
                          String countryName = playerAndCountryParts[1]
                              .substring(
                                  0, playerAndCountryParts[1].length - 1);
                          return ListTile(
                            onTap: () async {
                              // Launch the player's profile URL in the web browser
                              var playerProfileUri = Uri.parse(
                                  'https://www.cricbuzz.com/${t20PlayerUrls[index]}');
                              if (await canLaunchUrl(playerProfileUri)) {
                                await launchUrl(playerProfileUri);
                              } else {
                                print("Could not launch player profile.");
                              }
                            },
                            leading: Container(
                              width: 70.w,
                              height: 65.h,
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontFamily: 'SpaceGrotesk-Regular',
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      'https://www.cricbuzz.com/${t20PlayerImages[index]}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              playerName,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'Mulish-ExtraBold',
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              countryName,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk-Regular',
                                  color: Colors.grey),
                            ),
                            trailing: Text(rating,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'SpaceGrotesk-Regular',
                                    color: Colors.white)),
                          );
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
