// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:refresh/refresh.dart';
import 'package:url_launcher/url_launcher.dart';

// class NewsItemMain {
//   final String imageUrl;
//   final String category;
//   final String title;
//   final String summary;
//   final String time;
//   final String articleUrl;

//   NewsItemMain({
//     required this.imageUrl,
//     required this.category,
//     required this.title,
//     required this.summary,
//     required this.time,
//     required this.articleUrl,
//   });
// }

// class NewsItemSub {
//   final String imageUrl;
//   final String category;
//   final String title;
//   final String time;
//   final String articleUrl;

//   NewsItemSub({
//     required this.imageUrl,
//     required this.category,
//     required this.title,
//     required this.time,
//     required this.articleUrl,
//   });
// }

// class NewScreen extends StatefulWidget {
//   const NewScreen({super.key});

//   @override
//   State<NewScreen> createState() => _NewScreenState();
// }

// class _NewScreenState extends State<NewScreen> {
//   final List<NewsItemSub> newsItemsSub = [];
//   final List<NewsItemMain> newsItemsMain = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchNews();
//   }

//   Future<void> fetchNews() async {
//     final response =
//         await http.get(Uri.parse('https://www.icc-cricket.com/news'));

//     if (response.statusCode == 200) {
//       final document = html.parse(response.body);

//       final divElementsSub = document.querySelectorAll(
//           '.sticky-hero-list__item.col-12-phab.col-6-tab.col-12-desk.col-6');

//       for (var divElement in divElementsSub) {
//         final anchorElement =
//             divElement.querySelector('a.thumbnail.thumbnail--sticky-secondary');
//         // final figureElement = divElement.querySelector('figure');
//         final imageElement = anchorElement!.querySelector('.thumbnail__image');
//         final captionElement =
//             anchorElement.querySelector('.thumbnail__caption');
//         final categoryElement =
//             captionElement!.querySelector('.thumbnail__category');
//         final titleElement = captionElement.querySelector('.thumbnail__title');
//         final timeElement = captionElement.querySelector('.thumbnail__time');

//         final imageUrl = imageElement!.attributes['data-image-src'];
//         final category = categoryElement!.text;
//         final title = titleElement!.text;
//         final time = timeElement!.text.trim();
//         final articleUrl = anchorElement.attributes['href'];

//         newsItemsSub.add(NewsItemSub(
//           imageUrl: imageUrl!,
//           category: category,
//           title: title,
//           time: time,
//           articleUrl: articleUrl!,
//         ));

//         print('Image URL: ${imageUrl.length}');
//         print('Category: ${category.length}');
//         print('Title: ${title.length}');
//         print('Time: ${time.length}');
//       }

//       final divElementsMain = document.querySelectorAll(
//           '.sticky-hero-list__column.sticky-hero-list__column--primary');

//       for (var divElement in divElementsMain) {
//         final anchorElement = divElement.querySelector(
//             'a.thumbnail.thumbnail--hero.thumbnail--sticky-hero');
//         final imageElement =
//             anchorElement!.querySelector('img.thumbnail__image');
//         final captionElement =
//             anchorElement.querySelector('.thumbnail__caption');
//         final categoryElement =
//             captionElement!.querySelector('.thumbnail__category');
//         final titleElement = captionElement.querySelector('.thumbnail__title');
//         final summaryElement =
//             captionElement.querySelector('.thumbnail__summary');
//         final timeElement = captionElement.querySelector('.thumbnail__time');

//         final imageUrl = imageElement!.attributes['src'];
//         final category = categoryElement!.text;
//         final title = titleElement!.text;
//         final summary = summaryElement!.text;
//         final time = timeElement!.text.trim();
//         final articleUrl = anchorElement.attributes['href'];

//         newsItemsMain.add(NewsItemMain(
//           imageUrl: imageUrl!,
//           category: category,
//           title: title,
//           summary: summary,
//           time: time,
//           articleUrl: articleUrl!,
//         ));

//         print('Image URL: ${imageUrl.length}');
//         print('Category: ${category.length}');
//         print('Title: ${title.length}');
//         print('Summary: ${summary.length}');
//         print('Time: ${time.length}');
//       }

//       setState(() {});
//     } else {
//       print('Failed to fetch news: ${response.statusCode}');
//     }
//   }

//   void _openFullArticle(String articleUrl) async {
//     // Launch the player's profile URL in the web browser
//     var cricketNewsUri = Uri.parse('https://www.icc-cricket.com/$articleUrl');
//     if (await canLaunchUrl(cricketNewsUri)) {
//       await launchUrl(cricketNewsUri);
//     } else {
//       throw 'Could not launch $articleUrl';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Cricket News'),
//         ),
//         body: ListView(
//           children: [
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const ScrollPhysics(),
//               itemCount: newsItemsMain.length,
//               itemBuilder: (context, index) {
//                 final newsItem = newsItemsMain[index];

//                 return InkWell(
//                   onTap: () {
//                     _openFullArticle(newsItem.articleUrl);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.network(newsItem.imageUrl),
//                         SizedBox(height: 8),
//                         Text(
//                           newsItem.category,
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                         Text(
//                           newsItem.title,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         Text(
//                           newsItem.summary,
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                         Text(
//                           newsItem.time,
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const ScrollPhysics(),
//               itemCount: newsItemsSub.length,
//               itemBuilder: (context, index) {
//                 final newsItem = newsItemsSub[index];
//                 log('message ${newsItemsSub.length}');
//                 return InkWell(
//                   onTap: () {
//                     _openFullArticle(newsItem.articleUrl);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.network(newsItem.imageUrl),
//                         SizedBox(height: 8),
//                         Text(
//                           newsItem.category,
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                         Text(
//                           newsItem.title,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         Text(
//                           newsItem.time,
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ));
//   }
// }

class MatchItem {
  final String matchTitle;
  final String matchLink;
  final String matchType;
  final String matchDate;
  final String matchTime;
  final String matchLocation;
  final String team1Name;
  final String team1Score;
  final String team2Name;
  final String team2Score;
  final String matchStatus;

  MatchItem({
    required this.matchTitle,
    required this.matchLink,
    required this.matchType,
    required this.matchDate,
    required this.matchTime,
    required this.matchLocation,
    required this.team1Name,
    required this.team1Score,
    required this.team2Name,
    required this.team2Score,
    required this.matchStatus,
  });
}

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final List<MatchItem> matchItems = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    final response = await http.get(
      Uri.parse('https://www.cricbuzz.com/cricket-match/live-scores'),
    );

    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      // final matchElements = document
      //     .querySelectorAll('.cb-mtch-lst.cb-col.cb-col-100.cb-tms-itm');

      final matchElements = document.querySelectorAll(
          '.cb-col.cb-col-100.cb-plyr-tbody.cb-rank-hdr.cb-lv-main');

      for (var matchElement in matchElements) {
        final titleElement = matchElement.querySelector('h3 a');
        final typeElement = matchElement.querySelector('.text-gray');
        final dateElement =
            matchElement.querySelector('.text-gray > span:not([ng-if])');
        final timeElement =
            matchElement.querySelector('.text-gray > span[ng-bind]');
        final locationElement =
            matchElement.querySelector('.text-gray .text-gray');
        final team1NameElement =
            matchElement.querySelector('.cb-ovr-flo.cb-hmscg-tm-nm');
        final team1ScoreElement =
            matchElement.querySelector('.cb-ovr-flo[style*="width:140px"]');
        final team2NameElement =
            matchElement.querySelectorAll('.cb-ovr-flo.cb-hmscg-tm-nm')[1];
        // final team2ScoreElement = matchElement.querySelector(
        //     '.cb-ovr-flo.cb-hmscg-tm-nm + .cb-ovr-flo[style*="width:140px"]');
        final team2ScoreElement = matchElement.querySelectorAll(
            '.cb-ovr-flo.cb-hmscg-tm-nm + .cb-ovr-flo[style*="width:140px"]')[1];
        final statusElement = matchElement.querySelector('.cb-text-live');

        final title = titleElement?.text ?? '';
        final link = titleElement?.attributes['href'] ?? '';
        final type = typeElement?.text ?? '';
        final date = dateElement?.text ?? '';
        final time =
            timeElement?.text ?? ''; // Adjust this selector accordingly
        final location = locationElement?.text ?? '';
        final team1Name = team1NameElement?.text ?? '';
        final team1Score = team1ScoreElement?.text ?? '';
        final team2Name = team2NameElement?.text ?? '';
        final team2Score = team2ScoreElement?.text ?? '';
        final status = statusElement?.text ?? '';

        matchItems.add(
          MatchItem(
            matchTitle: title,
            matchLink: link,
            matchType: type,
            matchDate: date,
            matchTime: time,
            matchLocation: location,
            team1Name: team1Name,
            team1Score: team1Score,
            team2Name: team2Name,
            team2Score: team2Score,
            matchStatus: status,
          ),
        );
      }

      setState(() {});
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket Matches'),
      ),
      body: ListView.builder(
        itemCount: matchItems.length,
        itemBuilder: (context, index) {
          final matchItem = matchItems[index];
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matchItem.matchTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(matchItem.matchType),
                Text(
                  matchItem.matchDate + ' ' + matchItem.matchTime,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(matchItem.matchLocation),
                SizedBox(height: 8),
                Text('Team 1: ' + matchItem.team1Name),
                Text('Score: ' + matchItem.team1Score),
                SizedBox(height: 8),
                Text('Team 2: ' + matchItem.team2Name),
                Text('Score: ' + matchItem.team2Score),
                SizedBox(height: 8),
                Text(matchItem.matchStatus),
                SizedBox(height: 16),
                // Add links/buttons for Live Score, Scorecard, Full Commentary, News
              ],
            ),
          );
        },
      ),
    );
  }
}

// for scorecard headers (example: Batter R B 4s 6s SR)
      // final innings1Elements = document.querySelectorAll('#innings_1');
      // for (var innings1Element in innings1Elements) {
      //   final inningsTitle =
      //       innings1Element.querySelector('.cb-scrd-hdr-rw span')?.text ?? '';
      //   final inningsInfo = innings1Element
      //           .querySelector('.cb-scrd-hdr-rw span.pull-right')
      //           ?.text ??
      //       '';

      //   final headerRow = document
      //       .querySelector('.cb-col.cb-col-100.cb-scrd-sub-hdr.cb-bg-gray');
      //   final headerColumns = headerRow!.querySelectorAll('.cb-col');
      //   final batterHeader = headerColumns[0].text;
      //   final runsHeader = headerColumns[2].text;
      //   final ballsHeader = headerColumns[3].text;
      //   final foursHeader = headerColumns[4].text;
      //   final sixesHeader = headerColumns[5].text;
      //   final strikeRateHeader = headerColumns[6].text;

      //   print('Innings Title: $inningsTitle $inningsInfo');
      //   print(
      //       'Batter Header: $batterHeader $runsHeader $ballsHeader $foursHeader $sixesHeader $strikeRateHeader');

      //   scoreHeaderItems.add(ScoreHeaderItem(
      //       inningsTitle: inningsTitle,
      //       inningsInfo: inningsInfo,
      //       batterHeader: batterHeader,
      //       runsHeader: runsHeader,
      //       ballsHeader: ballsHeader,
      //       foursHeader: foursHeader,
      //       sixesHeader: sixesHeader,
      //       strikeRateHeader: strikeRateHeader));
      // }

      // // for for first batting scorecard
      // final innings1Div = document.querySelector('#innings_1');
      // if (innings1Div != null) {
      //   final players = innings1Div.querySelector('.cb-ltst-wgt-hdr');
      //   if (players != null) {
      //     final playersList = players.querySelectorAll('.cb-col.cb-scrd-itms');

      //     for (var playerElement in playersList) {
      //       final playerName =
      //           playerElement.querySelector('a.cb-text-link')?.text.trim() ??
      //               '';

      //       // Skip players with empty names
      //       if (playerName.isEmpty) {
      //         continue;
      //       }
      //       final dismissal =
      //           playerElement.querySelector('.text-gray')?.text.trim() ?? '';
      //       // Skip players with empty names
      //       if (dismissal.isEmpty) {
      //         continue;
      //       }

      //       final runsElements = playerElement.querySelectorAll('.text-right');
      //       final runs =
      //           runsElements.isNotEmpty ? runsElements[0].text.trim() : '';

      //       final ballsElementList =
      //           playerElement.querySelectorAll('.text-right');
      //       final balls = ballsElementList.length > 1
      //           ? ballsElementList[1].text.trim()
      //           : '';

      //       final textRightElements =
      //           playerElement.querySelectorAll('.text-right');
      //       final fours = textRightElements.length > 2
      //           ? textRightElements[2].text.trim()
      //           : '';

      //       final cbColElements = playerElement.querySelectorAll('.cb-col');
      //       final sixes =
      //           cbColElements.length > 5 ? cbColElements[5].text.trim() : '';

      //       final strikeRateElements =
      //           playerElement.querySelectorAll('.text-right');
      //       final strikeRate = strikeRateElements.length > 3
      //           ? strikeRateElements[3].text.trim()
      //           : '';

      //       print(
      //           'Player Name: $playerName $dismissal $runs $balls $fours $sixes $strikeRate');
      //       scorecardItems.add(ScorecardItem(
      //           batterName: playerName,
      //           dismissal: dismissal,
      //           runs: runs,
      //           balls: balls,
      //           fours: fours,
      //           sixes: sixes,
      //           strikeRate: strikeRate));
      //     }
      //   }
      // }

      // // for Extract Extras data
      // final firstinningsextraDiv = document.querySelector('#innings_1');
      // if (firstinningsextraDiv != null) {
      //   final extrasLabel = firstinningsextraDiv
      //           .querySelector('.cb-col.cb-col-60')
      //           ?.text
      //           .trim() ??
      //       '';
      //   final extrasValue = firstinningsextraDiv
      //           .querySelector('.text-bold.cb-text-black.text-right')
      //           ?.text
      //           .trim() ??
      //       '';
      //   final extrasDetails = firstinningsextraDiv
      //           .querySelector('.cb-col-32.cb-col')
      //           ?.text
      //           .trim() ??
      //       '';
      //   print('Extras Data: $extrasLabel $extrasValue $extrasDetails');

      //   // Select the Total div
      //   final totalDiv = firstinningsextraDiv;
      //   // Extract Total data
      //   final totalLabel = 'Total';
      //   final totalValue = firstinningsextraDiv
      //           .querySelector('.text-bold.text-black.text-right')
      //           ?.text
      //           .trim() ??
      //       '';
      //   final totalDetails = firstinningsextraDiv
      //       .querySelectorAll('.cb-col-32.cb-col')[1]
      //       .text
      //       .trim();
      //   print('Total Data: $totalLabel $totalValue $totalDetails');

      //   // Extract data for the "Yet to Bat" section
      //   final yetToBatDiv = firstinningsextraDiv
      //       .querySelector('.cb-col-100.cb-scrd-itms:last-child');

      //   final yetToBatLabel =
      //       yetToBatDiv!.querySelector('.cb-col.cb-col-27')?.text.trim() ?? '';
      //   final yetToBatPlayers = yetToBatDiv
      //           .querySelector('.cb-col-73.cb-col')
      //           ?.text
      //           .trim()
      //           .replaceAll(' , ', '\n') ??
      //       '';
      //   print('Yet to Bat: \n$yetToBatLabel \n$yetToBatPlayers');

      //   // Extract data for the "Fall of Wickets" section
      //   final fallOfwicketsLabel = firstinningsextraDiv
      //           .querySelector('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')
      //           ?.text
      //           .trim() ??
      //       '';
      //   final fallOfWickets = firstinningsextraDiv
      //           .querySelector('.cb-col.cb-col-100.cb-col-rt.cb-font-13')
      //           ?.text
      //           .trim()
      //           .replaceAll('), ', ')\n') ??
      //       '';

      //   print('Fall of Wickets: \n$fallOfwicketsLabel \n$fallOfWickets');

      //   totalscoreItems.add(TotalScoreItem(
      //       extrasLabel: extrasLabel,
      //       extrasValue: extrasValue,
      //       extrasDetails: extrasDetails,
      //       totalLabel: totalLabel,
      //       totalValue: totalValue,
      //       totalDetails: totalDetails,
      //       yettobatLabel: yetToBatLabel,
      //       yettobatPlayers: yetToBatPlayers,
      //       fallofwicketsLabel: fallOfwicketsLabel,
      //       fallofWickets: fallOfWickets));

      //   // Extract data for the bowlers headers
      //   final bowlerheaderDivs =
      //       document.querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray')[2];
      //   final bowlerheaderColumns =
      //       bowlerheaderDivs.querySelectorAll('.cb-col');
      //   final bowlerHeader = bowlerheaderColumns[0].text;
      //   final overs = bowlerheaderColumns[1].text;
      //   final maidens = bowlerheaderColumns[2].text;
      //   final runs = bowlerheaderColumns[3].text;
      //   final wickets = bowlerheaderColumns[4].text;
      //   final noBalls = bowlerheaderColumns[5].text;
      //   final wides = bowlerheaderColumns[6].text;
      //   final economy = bowlerheaderColumns[7].text;

      //   print(
      //       'Bowler Header: $bowlerHeader $overs $maidens $runs $wickets $noBalls $wides $economy');

      //   bowlerHeaderItems.add(BowlerHeaderItem(
      //       bowlerHeader: bowlerHeader,
      //       oversHeader: overs,
      //       maidensHeader: maidens,
      //       runsHeader: runs,
      //       wicketsHeader: wickets,
      //       noballsHeader: noBalls,
      //       widesHeader: wides,
      //       economyHeader: economy));

      //   // Extract data for the bowlers Data
      //   final bowlerDataElements =
      //       firstinningsextraDiv.querySelectorAll('.cb-ltst-wgt-hdr')[1];
      //   final bowlerDivs = bowlerDataElements
      //       .querySelectorAll('.cb-col.cb-col-100.cb-scrd-itms');
      //   for (var bowlerDiv in bowlerDivs) {
      //     final bowlerName =
      //         bowlerDiv.querySelector('a.cb-text-link')?.text.trim() ?? '';
      //     final overs = bowlerDiv
      //             .querySelector('.cb-col.cb-col-8.text-right')
      //             ?.text
      //             .trim() ??
      //         '';
      //     final maidens = bowlerDiv
      //         .querySelectorAll('.cb-col.cb-col-8.text-right')[1]
      //         .text
      //         .trim();
      //     final runs = bowlerDiv
      //             .querySelector('.cb-col.cb-col-10.text-right')
      //             ?.text
      //             .trim() ??
      //         '';
      //     final wickets = bowlerDiv
      //             .querySelector('.cb-col.cb-col-8.text-bold.text-right')
      //             ?.text
      //             .trim() ??
      //         '';
      //     final noBalls = bowlerDiv
      //         .querySelectorAll('.cb-col.cb-col-8.text-right')[3]
      //         .text
      //         .trim();
      //     final wides = bowlerDiv
      //         .querySelectorAll('.cb-col.cb-col-8.text-right')[4]
      //         .text
      //         .trim();

      //     final textRightElements =
      //         bowlerDiv.querySelectorAll('.cb-col.cb-col-10.text-right');
      //     final economy = textRightElements.length > 1
      //         ? textRightElements[1].text.trim()
      //         : '';

      //     print(
      //         'Bowler Data: $bowlerName $overs $maidens $runs $wickets $noBalls $wides $economy');

      //     bowlerDataItems.add(BowlerDataItem(
      //         bowlerName: bowlerName,
      //         overs: overs,
      //         maidens: maidens,
      //         runs: runs,
      //         wickets: wickets,
      //         noballs: noBalls,
      //         wides: wides,
      //         economy: economy));
      //   }

      //   // for extract the Powerplay headers
      //   final powerplaysDiv = firstinningsextraDiv
      //       .querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')[1];
      //   final powerplayHeader =
      //       powerplaysDiv.querySelector('.cb-col-33')?.text ?? '';
      //   final oversHeader =
      //       powerplaysDiv.querySelector('.cb-col-33.text-center')?.text ?? '';
      //   final runsHeader =
      //       powerplaysDiv.querySelector('.cb-col-33.text-right')?.text ?? '';

      //   print('Powerplay: $powerplayHeader $oversHeader $runsHeader');

      //   powerplayItems.add(PowerPlayItem(
      //       powerplaysLabel: powerplayHeader,
      //       oversLabel: oversHeader,
      //       runsLabel: runsHeader));

      //   // for extract the Powerplay Data
      //   final powerplayLabel =
      //       firstinningsextraDiv.querySelectorAll('.cb-col-rt.cb-font-13')[1];
      //   final mandatoryValue =
      //       powerplayLabel.querySelector('.cb-col-33')?.text ?? '';
      //   final oversValue =
      //       powerplayLabel.querySelector('.cb-col-33.text-center')?.text ?? '';
      //   final runsValue =
      //       powerplayLabel.querySelector('.cb-col-33.text-right')?.text ?? '';

      //   print('Powerplay: $mandatoryValue $oversValue $runsValue');
      //   powerplayDataItems.add(PowerPlayDataItem(
      //       powerplaysValue: mandatoryValue,
      //       oversValue: oversValue,
      //       runsValue: runsValue));
      // }
