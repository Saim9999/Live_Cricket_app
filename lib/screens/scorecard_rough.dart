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

class ScorecardItem {
  final String inningsTitle;
  final String inningsInfo;
  final String batterHeader;
  final String runsHeader;
  final String ballsHeader;
  final String foursHeader;
  final String sixesHeader;
  final String strikeRateHeader;

  ScorecardItem({
    required this.inningsTitle,
    required this.inningsInfo,
    required this.batterHeader,
    required this.runsHeader,
    required this.ballsHeader,
    required this.foursHeader,
    required this.sixesHeader,
    required this.strikeRateHeader,
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
  final List<ScorecardItem> scorecardItems = [];

  @override
  void initState() {
    super.initState();
    scorecardMatches();
  }

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

      final innings1Elements = document.querySelectorAll('#innings_1');
      for (var innings1Element in innings1Elements) {
        final inningsTitle =
            innings1Element.querySelector('.cb-scrd-hdr-rw span');
        final inningsInfo =
            innings1Element.querySelector('.cb-scrd-hdr-rw span.pull-right');

        final headerRow = document
            .querySelector('.cb-col.cb-col-100.cb-scrd-sub-hdr.cb-bg-gray');
        final headerColumns = headerRow!.querySelectorAll('.cb-col');

        final batterHeader = headerColumns[0].text;
        final runsHeader = headerColumns[2].text;
        final ballsHeader = headerColumns[3].text;
        final foursHeader = headerColumns[4].text;
        final sixesHeader = headerColumns[5].text;
        final strikeRateHeader = headerColumns[6].text;

        print('Innings Title: ${inningsTitle!.text}');
        print('Innings Info: ${inningsInfo!.text}');

        print('Batter Header: $batterHeader');
        print('Runs Header: $runsHeader');
        print('Balls Header: $ballsHeader');
        print('Fours Header: $foursHeader');
        print('Sixes Header: $sixesHeader');
        print('Strike Rate Header: $strikeRateHeader');

        final headerRow1 =
            document.querySelector('.cb-col.cb-col-100.cb-scrd-itms');
        final headerColumns1 = headerRow1!.querySelectorAll('.cb-col');

        final batterHeader1 = headerColumns1[0].text;
        final runsHeader1 = headerColumns1[2].text;
        final ballsHeader1 = headerColumns1[3].text;
        final foursHeader1 = headerColumns1[4].text;
        final sixesHeader1 = headerColumns1[5].text;
        final strikeRateHeader1 = headerColumns1[6].text;

        print('Batter Header1: $batterHeader1');
        print('Runs Header1: $runsHeader1');
        print('Balls Header1: $ballsHeader1');
        print('Fours Header1: $foursHeader1');
        print('Sixes Header1: $sixesHeader1');
        print('Strike Rate Header1: $strikeRateHeader1');

        scorecardItems.add(ScorecardItem(
            inningsTitle: inningsTitle.text,
            inningsInfo: inningsInfo.text,
            batterHeader: batterHeader1,
            ballsHeader: ballsHeader1,
            runsHeader: runsHeader1,
            foursHeader: foursHeader1,
            sixesHeader: sixesHeader1,
            strikeRateHeader: strikeRateHeader1));
      }

      // final squadElements = document.querySelectorAll('.cb-minfo-tm-nm');
      // for (var squadElement in squadElements) {
      //   final squadLabel = squadElement.text;
      //   print(squadLabel);
      //   squadItems.add(SquadItem(squadLabel: squadLabel));
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
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: scorecardItems.length,
            itemBuilder: (context, index) {
              final scorecardItem = scorecardItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${scorecardItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${scorecardItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header1:      ${scorecardItem.batterHeader}'),
                  Text('Runs Header1:        ${scorecardItem.runsHeader}'),
                  Text('Balls Header1:       ${scorecardItem.ballsHeader}'),
                  Text('Fours Header1:       ${scorecardItem.foursHeader}'),
                  Text('Sixes Header1:       ${scorecardItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header1: ${scorecardItem.strikeRateHeader}'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
