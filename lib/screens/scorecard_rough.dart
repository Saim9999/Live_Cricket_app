import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:intl/intl.dart';

class MatchItem {
  final String matchLabel;
  final String matchvalue;

  MatchItem({
    required this.matchLabel,
    required this.matchvalue,
  });
}

class SquadItem {
  final String squadLabel;
  // final String squadvalue;

  SquadItem({
    required this.squadLabel,
    // required this.squadvalue,
  });
}

class ScorecardRough extends StatefulWidget {
  final String url;
  const ScorecardRough({super.key, required this.url});

  @override
  State<ScorecardRough> createState() => _ScorecardRoughState();
}

class _ScorecardRoughState extends State<ScorecardRough> {
  final List<MatchItem> matchItems = [];
  final List<SquadItem> squadItems = [];

  @override
  void initState() {
    super.initState();
    scorecardMatches();
  }

  // Future<void> scorecardMatches() async {
  //   final response = await http.get(
  //     Uri.parse(widget.url),
  //   );
  //   if (response.statusCode == 200) {
  //     final document = html.parse(response.body);

  //     final matchCardElements = document
  //         .querySelectorAll('.cb-col.cb-col-67.cb-scrd-lft-col.html-refresh');

  //     var matchInfoElements =
  //         document.querySelectorAll('.cb-col.cb-col-100.cb-mtch-info-itm');

  //     for (var matchInfoElement in matchInfoElements) {
  //       var label = matchInfoElement.querySelector('.cb-col-27')?.text;
  //       var value = matchInfoElement.querySelector('.cb-col-73')?.text;

  //       if (label != null && value != null) {
  //         print("$label: $value");
  //         // print("$squad");
  //       }
  //       matchItems.add(MatchItem(matchLabel: label!, matchvalue: value!));
  //     }

  //     setState(() {});
  //   } else {
  //     print('Failed to fetch matches: ${response.statusCode}');
  //   }
  // }

  Future<void> scorecardMatches() async {
    final response = await http.get(
      Uri.parse(widget.url),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final matchCardElements = document
          .querySelectorAll('.cb-col.cb-col-67.cb-scrd-lft-col.html-refresh');

      for (var matchCardElement in matchCardElements) {
        final matchInfoElements =
            matchCardElement.querySelectorAll('.cb-mtch-info-itm');

        String matchLabel = '';
        String matchValue = '';

        for (var matchInfoElement in matchInfoElements) {
          final labelElement = matchInfoElement.querySelector('.cb-col-27');
          final valueElement = matchInfoElement.querySelector('.cb-col-73');

          if (labelElement != null && valueElement != null) {
            matchLabel = labelElement.text;
            matchValue = valueElement.text;

            if (matchLabel == 'Date' || matchLabel == 'Time') {
              final timestamp = valueElement
                  .querySelector('.schedule-date')
                  ?.attributes['timestamp'];
              if (timestamp != null) {
                final dateTime =
                    DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
                matchValue = matchLabel == 'Date'
                    ? DateFormat('EEEE, MMMM dd, yyyy').format(dateTime)
                    : DateFormat.jm().format(dateTime);
              }
            }
            print("$matchLabel: $matchValue");
          }
          matchItems.add(MatchItem(
            matchLabel: matchLabel,
            matchvalue: matchValue,
          ));
        }
      }

      final squadElements = document.querySelectorAll('.cb-minfo-tm-nm');
      for (var squadElement in squadElements) {
        final squadLabel = squadElement.text;
        print(squadLabel);
        squadItems.add(SquadItem(squadLabel: squadLabel));
      }

      // if (squadElement != null) {
      //   final squadLabel = squadElement.text;
      //   final playerLinks =
      //       squadElement.nextElementSibling?.querySelectorAll('a');

      //   if (squadLabel.isNotEmpty &&
      //       playerLinks != null &&
      //       playerLinks.isNotEmpty) {
      //     final squadPlayers = playerLinks.map((playerLink) {
      //       final playerName = playerLink.text;
      //       final playerProfileUrl = playerLink.attributes['href'];
      //       return '$playerName ($playerProfileUrl)';
      //     }).join(', ');

      //     squadItems
      //         .add(SquadItem(squadLabel: squadLabel, squadvalue: squadPlayers));
      //   }
      // }

      setState(() {});
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScoreCard'),
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: matchItems.length,
            itemBuilder: (context, index) {
              final matchItem = matchItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '${matchItem.matchLabel} : ',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(matchItem.matchvalue),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: squadItems.length,
            itemBuilder: (context, index) {
              final squadItem = squadItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('${squadItem.squadLabel}'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
