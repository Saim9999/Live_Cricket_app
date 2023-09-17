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
