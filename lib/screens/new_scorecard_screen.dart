import 'package:cricket_worldcup_app/classes/scorecard_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

import '../classes/commentary classes.dart';

class NewScorecard extends StatefulWidget {
  final String url1;
  final String url2;
  const NewScorecard({super.key, required this.url1, required this.url2});

  @override
  State<NewScorecard> createState() => _NewScorecardState();
}

class _NewScorecardState extends State<NewScorecard> {
  final List<TeamScore> teamScores = [];
  final List<MatchStatus> matchStatus = [];
  final List<CurrentRate> currentRate = [];
  final List<RequiredRate> reqRate = [];
  final List<PlayerOfMatch> playerofMatch = [];
  final List<PlayerOfSeries> playerofSeries = [];
  final List<BatterHeaderItem> batterheaderItem = [];
  final List<PlayerData> playerdata = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scorecardMatches();
  }

  Future<void> scorecardMatches() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response1 = await http.get(
      Uri.parse(widget.url1),
    );
    if (response1.statusCode == 200) {
      final document = html.parse(response1.body);

      // for Teams score, current & required runrate and match status
      final scoreText =
          document.querySelector('.cb-text-gray.cb-font-16')?.text ?? '';
      final teamScoreText =
          document.querySelector('.cb-font-20.text-bold')?.text ?? '';

      final inProgressText =
          document.querySelector('.cb-text-inprogress')?.text ?? '';

      print('first team: $scoreText');
      print('second team: $teamScoreText');
      print('match status: $inProgressText');

      teamScores.add(TeamScore(
        teamscorefirst: scoreText,
        teamscoreSecond: teamScoreText,
      ));

      final crrText =
          document.querySelector('.cb-min-bat-rw .cb-font-12.cb-text-gray');
      if (crrText != null) {
        final crrTextquery = crrText.text.toString();
        print('crr: $crrTextquery');
        currentRate.add(CurrentRate(currRate: crrTextquery));
      } else {
        print("No current runrate found.");
      }

      final reqText =
          document.querySelectorAll('.cb-min-bat-rw .cb-font-12.cb-text-gray');
      if (reqText.isNotEmpty && reqText.length > 1) {
        final reqTextquery = reqText[1].text;
        print('req: $reqTextquery');
        reqRate.add(RequiredRate(reqRate: reqTextquery));
      } else {
        print("No required runrate found.");
      }

      // for match status
      final matchstatus =
          document.querySelector('.cb-scrcrd-status')?.text ?? '';
      print("Match Status: $matchstatus");
      matchStatus.add(MatchStatus(matchStatus: matchstatus));

      // for player motm and mots message
      final playerMotm = document.querySelector('.cb-mom-itm');
      if (playerMotm != null) {
        final playerMotmLabel = playerMotm.querySelector('span')?.text ?? '';
        final playerMotmValue =
            playerMotm.querySelector('.cb-link-undrln')?.text ?? '';

        print(playerMotmLabel);
        print(playerMotmValue);
        playerofMatch.add(PlayerOfMatch(
            playerMotmLabel: playerMotmLabel,
            playerMotmValue: playerMotmValue));
      }

      final playerMots = document.querySelectorAll('.cb-mom-itm');
      if (playerMots.isNotEmpty && playerMots.length > 1) {
        final playerMotsquery = playerMots[1];
        final playerMotsLabel =
            playerMotsquery.querySelector('span')?.text ?? '';
        final playerMotsValue =
            playerMotsquery.querySelector('.cb-link-undrln')?.text ?? '';

        print(playerMotsLabel);
        print(playerMotsValue);
        playerofSeries.add(PlayerOfSeries(
            playerMotsLabel: playerMotsLabel,
            playerMotsValue: playerMotsValue));
      } else {
        print("No playerMots found or not enough elements in the list.");
      }

      // for batter header
      final headerRow =
          document.querySelector('.cb-col.cb-col-100.cb-min-hdr-rw.cb-bg-gray');
      if (headerRow != null) {
        final headerColumns = headerRow.querySelectorAll('.cb-col');
        final batterHeader = headerColumns[0].text;
        // final runsHeader = headerColumns[1].text;
        // final ballsHeader = headerColumns[2].text;
        // final foursHeader = headerColumns[3].text;
        // final sixesHeader = headerColumns[4].text;
        // final strikeRateHeader = headerColumns[5].text;

        print('Batter Header: $batterHeader');

        batterheaderItem.add(BatterHeaderItem(
          batterHeader: batterHeader,
          // runsHeader: runsHeader,
          // ballsHeader: ballsHeader,
          // foursHeader: foursHeader,
          // sixesHeader: sixesHeader,
          // strikeRateHeader: strikeRateHeader
        ));
      }

      // for batter data
      final extradiv = document.querySelector('.cb-min-inf');
      if (extradiv != null) {
        final players = extradiv.querySelectorAll('.cb-min-itm-rw');

        for (var playerElement in players) {
          final playerName =
              playerElement.querySelector('a.cb-text-link')?.text.trim() ?? '';

          // Skip players with empty names
          if (playerName.isEmpty) {
            continue;
          }

          final runsElements = playerElement.querySelectorAll('.ab.text-right');
          final runs =
              runsElements.isNotEmpty ? runsElements[0].text.trim() : '';

          final ballsElementList =
              playerElement.querySelectorAll('.ab.text-right');
          final balls = ballsElementList.length > 1
              ? ballsElementList[1].text.trim()
              : '';

          final textRightElements =
              playerElement.querySelectorAll('.ab.text-right');
          final fours = textRightElements.length > 2
              ? textRightElements[2].text.trim()
              : '';

          final cbColElements =
              playerElement.querySelectorAll('.ab.text-right');
          final sixes =
              cbColElements.length > 3 ? cbColElements[3].text.trim() : '';

          final strikeRateElements =
              playerElement.querySelectorAll('.ab.text-right');
          final strikeRate = strikeRateElements.length > 4
              ? strikeRateElements[4].text.trim()
              : '';

          final playerUrl =
              playerElement.querySelector('a.cb-text-link')!.attributes['href'];
          print('Player Url: ${playerUrl.toString()}');

          final response =
              await http.get(Uri.parse('https://cricbuzz.com$playerUrl'));

          if (response.statusCode == 200) {
            final document = html.parse(response.body);
            final playerName =
                document.querySelector('h1[itemprop="name"]')?.text ?? '';
            final playerCountry =
                document.querySelector('h3.cb-font-18.text-gray')?.text ?? '';
            final profileImage = document
                    .querySelector('img[title="profile image"]')
                    ?.attributes['src'] ??
                '';

            print('Player Name: $playerName');
            print('Player Country: $playerCountry');
            print('Profile Image URL: $profileImage');

            playerdata.add(PlayerData(
              playername: playerName,
              playerimage: profileImage,
              playercountry: playerCountry,
              runs: runs,
              ballsfaced: balls,
              fours: fours,
              sixes: sixes,
              strikerate: strikeRate,
            ));
          } else {
            print('Failed to fetch matches: ${response.statusCode}');
          }
          print(
              'Player Name: $playerName $runs $balls $fours $sixes $strikeRate');
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch matches: ${response1.statusCode}');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false; // Set isLoading to false in case of failure
      });
    }

    //////////////////////////////////
    final response2 = await http.get(
      Uri.parse(widget.url2),
    );
    if (response2.statusCode == 200) {
      final document = html.parse(response2.body);

      final matchstatus =
          document.querySelector('.cb-scrcrd-status')?.text ?? '';
      print("Match Status: $matchstatus");
      matchStatus.add(MatchStatus(matchStatus: matchstatus));

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch matches: ${response2.statusCode}');
      if (!mounted) {
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
        backgroundColor: const Color.fromARGB(255, 15, 19, 1),
        appBar: AppBar(
          toolbarHeight: 200.h,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leadingWidth: double.infinity,
          leading: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: listbuilderMethod(
                              teamScores,
                              (item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.teamscoreSecond,
                                    style: textMethod(
                                        Colors.white,
                                        14.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular'),
                                  ),
                                  Text(
                                    item.teamscorefirst,
                                    style: textMethod(
                                        Colors.white,
                                        14.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                listbuilderMethod(
                                    currentRate,
                                    (item) => Column(
                                          children: [
                                            Text(
                                              item.currRate,
                                              style: textMethod(
                                                  Colors.white,
                                                  14.sp,
                                                  FontWeight.normal,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                          ],
                                        )),
                                listbuilderMethod(
                                    reqRate,
                                    (item) => Column(
                                          children: [
                                            Text(
                                              item.reqRate,
                                              style: textMethod(
                                                  Colors.white,
                                                  14.sp,
                                                  FontWeight.normal,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                          ],
                                        )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    listbuilderMethod(
                        matchStatus,
                        (item) => Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                children: [
                                  Text(
                                    item.matchStatus,
                                    style: textMethod(
                                        Colors.white,
                                        14.sp,
                                        FontWeight.bold,
                                        'SpaceGrotesk-Regular'),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )),
                    listbuilderMethod(
                        playerofMatch,
                        (item) => Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                '${item.playerMotmLabel} : ${item.playerMotmValue}',
                                style: textMethod(Colors.white, 14.sp,
                                    FontWeight.bold, 'SpaceGrotesk-Regular'),
                              ),
                            )),
                    listbuilderMethod(
                        playerofSeries,
                        (item) => Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                '${item.playerMotsLabel} : ${item.playerMotsValue}',
                                style: textMethod(Colors.white, 14.sp,
                                    FontWeight.bold, 'SpaceGrotesk-Regular'),
                              ),
                            )),
                    listbuilderMethod(
                      batterheaderItem,
                      (item) => Text(item.batterHeader),
                    ),
                    listbuilderMethod(
                        playerdata,
                        (item) => Container(
                              width: double.infinity,
                              child: ListTile(
                                visualDensity: VisualDensity.compact,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://www.cricbuzz.com/${item.playerimage}'),
                                ),
                                title: Text(
                                  item.playername,
                                  style: textMethod(Colors.white, 12.sp,
                                      FontWeight.bold, 'SpaceGrotesk-Regular'),
                                ),
                                subtitle: Text(
                                  item.playercountry,
                                  style: textMethod(Colors.grey, 12.sp,
                                      FontWeight.bold, 'SpaceGrotesk-Regular'),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.runs,
                                      style: textMethod(
                                          Colors.white,
                                          15.sp,
                                          FontWeight.bold,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      '(${item.ballsfaced})',
                                      style: textMethod(
                                          Colors.grey,
                                          14.sp,
                                          FontWeight.normal,
                                          'SpaceGrotesk-Regular'),
                                    ),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'SR : ',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              item.strikerate,
                                              style: textMethod(
                                                  Colors.grey,
                                                  14.sp,
                                                  FontWeight.bold,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '4s : ',
                                              style: textMethod(
                                                  Colors.white,
                                                  14.sp,
                                                  FontWeight.normal,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                            Text(
                                              item.fours,
                                              style: textMethod(
                                                  Color.fromARGB(
                                                      255, 0, 166, 255),
                                                  14.sp,
                                                  FontWeight.normal,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                            Text(
                                              ' | 6s : ',
                                              style: textMethod(
                                                  Colors.white,
                                                  14.sp,
                                                  FontWeight.normal,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                            Text(
                                              item.sixes,
                                              style: textMethod(
                                                  Color.fromARGB(
                                                      255, 255, 217, 0),
                                                  14.sp,
                                                  FontWeight.bold,
                                                  'SpaceGrotesk-Regular'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  ],
                ),
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 114, 255, 48),
            tabs: [
              Tab(
                child: Text(
                  'Scorecard',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Squads',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Match Info',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk-Regular',
                  ),
                ),
              ),
            ],
          ), // TabBar
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
            const TabBarView(
              children: [
                Icon(Icons.music_note),
                Icon(Icons.music_video),
                Icon(Icons.camera_alt),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textMethod(
      Color color, double fontSize, FontWeight fontWeight, String fontFamily) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  ListView listbuilderMethod(List items, Widget Function(dynamic) itemBuilder) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return itemBuilder(item);
      },
    );
  }
}
