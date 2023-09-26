import 'package:cricket_worldcup_app/screens/scorecard_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:intl/intl.dart';

class ScorecardRough extends StatefulWidget {
  final String url;
  const ScorecardRough({super.key, required this.url});

  @override
  State<ScorecardRough> createState() => _ScorecardRoughState();
}

class _ScorecardRoughState extends State<ScorecardRough> {
  final List<MatchItem> matchItems = [];
  final List<SquadItem> squadItems = [];
  final List<ScoreHeaderItem> scoreHeaderItems = [];
  final List<ScorecardItem> scorecardItems = [];
  final List<TotalScoreItem> totalscoreItems = [];
  final List<BowlerHeaderItem> bowlerHeaderItems = [];
  final List<BowlerDataItem> bowlerDataItems = [];
  final List<PowerPlayItem> powerplayItems = [];
  final List<PowerPlayDataItem> powerplayDataItems = [];

  final List<FirstScoreHeaderItem> firstscoreHeaderItems = [];
  final List<FirstScorecardItem> firstscorecardItems = [];
  final List<FirstTotalScoreItem> firsttotalscoreItems = [];
  final List<FirstBowlerHeaderItem> firstbowlerHeaderItems = [];
  final List<FirstBowlerDataItem> firstbowlerDataItems = [];
  final List<FirstPowerPlayItem> firstpowerplayItems = [];
  final List<FirstPowerPlayDataItem> firstpowerplayDataItems = [];

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

      final matchstatus =
          document.querySelector('.cb-scrcrd-status')?.text ?? '';
      print("Match Status: $matchstatus");

      // for match info
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

      // for squad/playing info
      final squadElements = document.querySelectorAll('.cb-minfo-tm-nm');
      for (var squadElement in squadElements) {
        final squadLabel = squadElement.text;
        print(squadLabel);
        squadItems.add(SquadItem(squadLabel: squadLabel));
      }

      // for scorecard headers (example: Batter R B 4s 6s SR)
      final innings2Elements = document.querySelectorAll('#innings_2');
      for (var innings2Element in innings2Elements) {
        final inningsTitle =
            innings2Element.querySelector('.cb-scrd-hdr-rw span')?.text ?? '';
        final inningsInfo = innings2Element
                .querySelector('.cb-scrd-hdr-rw span.pull-right')
                ?.text ??
            '';

        final headerRow = document
            .querySelector('.cb-col.cb-col-100.cb-scrd-sub-hdr.cb-bg-gray');
        final headerColumns = headerRow!.querySelectorAll('.cb-col');
        final batterHeader = headerColumns[0].text;
        final runsHeader = headerColumns[2].text;
        final ballsHeader = headerColumns[3].text;
        final foursHeader = headerColumns[4].text;
        final sixesHeader = headerColumns[5].text;
        final strikeRateHeader = headerColumns[6].text;

        print('Innings Title: $inningsTitle $inningsInfo');
        print(
            'Batter Header: $batterHeader $runsHeader $ballsHeader $foursHeader $sixesHeader $strikeRateHeader');

        scoreHeaderItems.add(ScoreHeaderItem(
            inningsTitle: inningsTitle,
            inningsInfo: inningsInfo,
            batterHeader: batterHeader,
            runsHeader: runsHeader,
            ballsHeader: ballsHeader,
            foursHeader: foursHeader,
            sixesHeader: sixesHeader,
            strikeRateHeader: strikeRateHeader));
      }

      // for for first batting scorecard
      final innings2Div = document.querySelector('#innings_2');
      if (innings2Div != null) {
        final players = innings2Div.querySelector('.cb-ltst-wgt-hdr');
        if (players != null) {
          final playersList = players.querySelectorAll('.cb-col.cb-scrd-itms');

          for (var playerElement in playersList) {
            final playerName =
                playerElement.querySelector('a.cb-text-link')?.text.trim() ??
                    '';

            // Skip players with empty names
            if (playerName.isEmpty) {
              continue;
            }
            final dismissal =
                playerElement.querySelector('.text-gray')?.text.trim() ?? '';
            // Skip players with empty names
            if (dismissal.isEmpty) {
              continue;
            }

            final runsElements = playerElement.querySelectorAll('.text-right');
            final runs =
                runsElements.isNotEmpty ? runsElements[0].text.trim() : '';

            final ballsElementList =
                playerElement.querySelectorAll('.text-right');
            final balls = ballsElementList.length > 1
                ? ballsElementList[1].text.trim()
                : '';

            final textRightElements =
                playerElement.querySelectorAll('.text-right');
            final fours = textRightElements.length > 2
                ? textRightElements[2].text.trim()
                : '';

            final cbColElements = playerElement.querySelectorAll('.cb-col');
            final sixes =
                cbColElements.length > 5 ? cbColElements[5].text.trim() : '';

            final strikeRateElements =
                playerElement.querySelectorAll('.text-right');
            final strikeRate = strikeRateElements.length > 3
                ? strikeRateElements[3].text.trim()
                : '';

            print(
                'Player Name: $playerName $dismissal $runs $balls $fours $sixes $strikeRate');
            scorecardItems.add(ScorecardItem(
                batterName: playerName,
                dismissal: dismissal,
                runs: runs,
                balls: balls,
                fours: fours,
                sixes: sixes,
                strikeRate: strikeRate));
          }
        }
      }

      // for Extract Extras data
      final secondinningsextraDiv = document.querySelector('#innings_2');
      if (secondinningsextraDiv != null) {
        final extrasLabel = secondinningsextraDiv
                .querySelector('.cb-col.cb-col-60')
                ?.text
                .trim() ??
            '';
        final extrasValue = secondinningsextraDiv
                .querySelector('.text-bold.cb-text-black.text-right')
                ?.text
                .trim() ??
            '';
        final extrasDetails = secondinningsextraDiv
                .querySelector('.cb-col-32.cb-col')
                ?.text
                .trim() ??
            '';
        print('Extras Data: $extrasLabel $extrasValue $extrasDetails');

        // Select the Total div
        final totalDiv = secondinningsextraDiv;
        // Extract Total data
        final totalLabel = 'Total';
        final totalValue = secondinningsextraDiv
                .querySelector('.text-bold.text-black.text-right')
                ?.text
                .trim() ??
            '';
        final totalDetails = secondinningsextraDiv
            .querySelectorAll('.cb-col-32.cb-col')[1]
            .text
            .trim();
        print('Total Data: $totalLabel $totalValue $totalDetails');

        // Extract data for the "Yet to Bat" section
        final yetToBatDiv = secondinningsextraDiv
            .querySelector('.cb-col-100.cb-scrd-itms:last-child');

        final yetToBatLabel =
            yetToBatDiv!.querySelector('.cb-col.cb-col-27')?.text.trim() ?? '';
        final yetToBatPlayers = yetToBatDiv
                .querySelector('.cb-col-73.cb-col')
                ?.text
                .trim()
                .replaceAll(' , ', '\n') ??
            '';
        print('Yet to Bat: \n$yetToBatLabel \n$yetToBatPlayers');

        // Extract data for the "Fall of Wickets" section
        final fallOfwicketsLabel = secondinningsextraDiv
                .querySelector('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')
                ?.text
                .trim() ??
            '';
        final fallOfWickets = secondinningsextraDiv
                .querySelector('.cb-col.cb-col-100.cb-col-rt.cb-font-13')
                ?.text
                .trim()
                .replaceAll('), ', ')\n') ??
            '';

        print('Fall of Wickets: \n$fallOfwicketsLabel \n$fallOfWickets');

        totalscoreItems.add(TotalScoreItem(
            extrasLabel: extrasLabel,
            extrasValue: extrasValue,
            extrasDetails: extrasDetails,
            totalLabel: totalLabel,
            totalValue: totalValue,
            totalDetails: totalDetails,
            yettobatLabel: yetToBatLabel,
            yettobatPlayers: yetToBatPlayers,
            fallofwicketsLabel: fallOfwicketsLabel,
            fallofWickets: fallOfWickets));

        // Extract data for the bowlers headers
        final bowlerheaderDivs =
            document.querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray')[2];
        final bowlerheaderColumns =
            bowlerheaderDivs.querySelectorAll('.cb-col');
        final bowlerHeader = bowlerheaderColumns[0].text;
        final overs = bowlerheaderColumns[1].text;
        final maidens = bowlerheaderColumns[2].text;
        final runs = bowlerheaderColumns[3].text;
        final wickets = bowlerheaderColumns[4].text;
        final noBalls = bowlerheaderColumns[5].text;
        final wides = bowlerheaderColumns[6].text;
        final economy = bowlerheaderColumns[7].text;

        print(
            'Bowler Header: $bowlerHeader $overs $maidens $runs $wickets $noBalls $wides $economy');

        bowlerHeaderItems.add(BowlerHeaderItem(
            bowlerHeader: bowlerHeader,
            oversHeader: overs,
            maidensHeader: maidens,
            runsHeader: runs,
            wicketsHeader: wickets,
            noballsHeader: noBalls,
            widesHeader: wides,
            economyHeader: economy));

        // Extract data for the bowlers Data
        final bowlerDataElements =
            secondinningsextraDiv.querySelectorAll('.cb-ltst-wgt-hdr')[1];
        final bowlerDivs = bowlerDataElements
            .querySelectorAll('.cb-col.cb-col-100.cb-scrd-itms');
        for (var bowlerDiv in bowlerDivs) {
          final bowlerName =
              bowlerDiv.querySelector('a.cb-text-link')?.text.trim() ?? '';
          final overs = bowlerDiv
                  .querySelector('.cb-col.cb-col-8.text-right')
                  ?.text
                  .trim() ??
              '';
          final maidens = bowlerDiv
              .querySelectorAll('.cb-col.cb-col-8.text-right')[1]
              .text
              .trim();
          final runs = bowlerDiv
                  .querySelector('.cb-col.cb-col-10.text-right')
                  ?.text
                  .trim() ??
              '';
          final wickets = bowlerDiv
                  .querySelector('.cb-col.cb-col-8.text-bold.text-right')
                  ?.text
                  .trim() ??
              '';
          final noBalls = bowlerDiv
              .querySelectorAll('.cb-col.cb-col-8.text-right')[3]
              .text
              .trim();
          final wides = bowlerDiv
              .querySelectorAll('.cb-col.cb-col-8.text-right')[4]
              .text
              .trim();

          final textRightElements =
              bowlerDiv.querySelectorAll('.cb-col.cb-col-10.text-right');
          final economy = textRightElements.length > 1
              ? textRightElements[1].text.trim()
              : '';

          print(
              'Bowler Data: $bowlerName $overs $maidens $runs $wickets $noBalls $wides $economy');

          bowlerDataItems.add(BowlerDataItem(
              bowlerName: bowlerName,
              overs: overs,
              maidens: maidens,
              runs: runs,
              wickets: wickets,
              noballs: noBalls,
              wides: wides,
              economy: economy));
        }

        // for extract the Powerplay headers
        final powerplaysDiv = secondinningsextraDiv
            .querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')[1];
        final powerplayHeader =
            powerplaysDiv.querySelector('.cb-col-33')?.text ?? '';
        final oversHeader =
            powerplaysDiv.querySelector('.cb-col-33.text-center')?.text ?? '';
        final runsHeader =
            powerplaysDiv.querySelector('.cb-col-33.text-right')?.text ?? '';

        print('Powerplay: $powerplayHeader $oversHeader $runsHeader');

        powerplayItems.add(PowerPlayItem(
            powerplaysLabel: powerplayHeader,
            oversLabel: oversHeader,
            runsLabel: runsHeader));

        // for extract the Powerplay Data
        final powerplayLabel =
            secondinningsextraDiv.querySelectorAll('.cb-col-rt.cb-font-13')[1];
        final mandatoryValue =
            powerplayLabel.querySelector('.cb-col-33')?.text ?? '';
        final oversValue =
            powerplayLabel.querySelector('.cb-col-33.text-center')?.text ?? '';
        final runsValue =
            powerplayLabel.querySelector('.cb-col-33.text-right')?.text ?? '';

        print('Powerplay: $mandatoryValue $oversValue $runsValue');
        powerplayDataItems.add(PowerPlayDataItem(
            powerplaysValue: mandatoryValue,
            oversValue: oversValue,
            runsValue: runsValue));
      }

      //////////////////////////////////////

      // for scorecard headers (example: Batter R B 4s 6s SR)
      final innings1Elements = document.querySelectorAll('#innings_1');
      for (var innings1Element in innings1Elements) {
        final inningsTitle =
            innings1Element.querySelector('.cb-scrd-hdr-rw span')?.text ?? '';
        final inningsInfo = innings1Element
                .querySelector('.cb-scrd-hdr-rw span.pull-right')
                ?.text ??
            '';

        final headerRow = document
            .querySelector('.cb-col.cb-col-100.cb-scrd-sub-hdr.cb-bg-gray');
        final headerColumns = headerRow!.querySelectorAll('.cb-col');
        final batterHeader = headerColumns[0].text;
        final runsHeader = headerColumns[2].text;
        final ballsHeader = headerColumns[3].text;
        final foursHeader = headerColumns[4].text;
        final sixesHeader = headerColumns[5].text;
        final strikeRateHeader = headerColumns[6].text;

        print('Innings Title: $inningsTitle $inningsInfo');
        print(
            'Batter Header: $batterHeader $runsHeader $ballsHeader $foursHeader $sixesHeader $strikeRateHeader');

        firstscoreHeaderItems.add(FirstScoreHeaderItem(
            inningsTitle: inningsTitle,
            inningsInfo: inningsInfo,
            batterHeader: batterHeader,
            runsHeader: runsHeader,
            ballsHeader: ballsHeader,
            foursHeader: foursHeader,
            sixesHeader: sixesHeader,
            strikeRateHeader: strikeRateHeader));
      }

      // for for first batting scorecard
      final innings1Div = document.querySelector('#innings_1');
      if (innings1Div != null) {
        final players = innings1Div.querySelector('.cb-ltst-wgt-hdr');
        if (players != null) {
          final playersList = players.querySelectorAll('.cb-col.cb-scrd-itms');

          for (var playerElement in playersList) {
            final playerName =
                playerElement.querySelector('a.cb-text-link')?.text.trim() ??
                    '';

            // Skip players with empty names
            if (playerName.isEmpty) {
              continue;
            }
            final dismissal =
                playerElement.querySelector('.text-gray')?.text.trim() ?? '';
            // Skip players with empty names
            if (dismissal.isEmpty) {
              continue;
            }

            final runsElements = playerElement.querySelectorAll('.text-right');
            final runs =
                runsElements.isNotEmpty ? runsElements[0].text.trim() : '';

            final ballsElementList =
                playerElement.querySelectorAll('.text-right');
            final balls = ballsElementList.length > 1
                ? ballsElementList[1].text.trim()
                : '';

            final textRightElements =
                playerElement.querySelectorAll('.text-right');
            final fours = textRightElements.length > 2
                ? textRightElements[2].text.trim()
                : '';

            final cbColElements = playerElement.querySelectorAll('.cb-col');
            final sixes =
                cbColElements.length > 5 ? cbColElements[5].text.trim() : '';

            final strikeRateElements =
                playerElement.querySelectorAll('.text-right');
            final strikeRate = strikeRateElements.length > 3
                ? strikeRateElements[3].text.trim()
                : '';

            print(
                'Player Name: $playerName $dismissal $runs $balls $fours $sixes $strikeRate');
            firstscorecardItems.add(FirstScorecardItem(
                batterName: playerName,
                dismissal: dismissal,
                runs: runs,
                balls: balls,
                fours: fours,
                sixes: sixes,
                strikeRate: strikeRate));
          }
        }
      }

      // for Extract Extras data
      final firstinningsextraDiv = document.querySelector('#innings_1');
      if (firstinningsextraDiv != null) {
        final extrasLabel = firstinningsextraDiv
                .querySelector('.cb-col.cb-col-60')
                ?.text
                .trim() ??
            '';
        final extrasValue = firstinningsextraDiv
                .querySelector('.text-bold.cb-text-black.text-right')
                ?.text
                .trim() ??
            '';
        final extrasDetails = firstinningsextraDiv
                .querySelector('.cb-col-32.cb-col')
                ?.text
                .trim() ??
            '';
        print('Extras Data: $extrasLabel $extrasValue $extrasDetails');

        // Select the Total div
        final totalDiv = firstinningsextraDiv;
        // Extract Total data
        final totalLabel = 'Total';
        final totalValue = firstinningsextraDiv
                .querySelector('.text-bold.text-black.text-right')
                ?.text
                .trim() ??
            '';
        final totalDetails = firstinningsextraDiv
            .querySelectorAll('.cb-col-32.cb-col')[1]
            .text
            .trim();
        print('Total Data: $totalLabel $totalValue $totalDetails');

        // Extract data for the "Yet to Bat" section
        final yetToBatDiv = firstinningsextraDiv
            .querySelector('.cb-col-100.cb-scrd-itms:last-child');

        final yetToBatLabel =
            yetToBatDiv!.querySelector('.cb-col.cb-col-27')?.text.trim() ?? '';
        final yetToBatPlayers = yetToBatDiv
                .querySelector('.cb-col-73.cb-col')
                ?.text
                .trim()
                .replaceAll(' , ', '\n') ??
            '';
        print('Yet to Bat: \n$yetToBatLabel \n$yetToBatPlayers');

        // Extract data for the "Fall of Wickets" section
        final fallOfwicketsLabel = firstinningsextraDiv
                .querySelector('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')
                ?.text
                .trim() ??
            '';
        final fallOfWickets = firstinningsextraDiv
                .querySelector('.cb-col.cb-col-100.cb-col-rt.cb-font-13')
                ?.text
                .trim()
                .replaceAll('), ', ')\n') ??
            '';

        print('Fall of Wickets: \n$fallOfwicketsLabel \n$fallOfWickets');

        firsttotalscoreItems.add(FirstTotalScoreItem(
            extrasLabel: extrasLabel,
            extrasValue: extrasValue,
            extrasDetails: extrasDetails,
            totalLabel: totalLabel,
            totalValue: totalValue,
            totalDetails: totalDetails,
            yettobatLabel: yetToBatLabel,
            yettobatPlayers: yetToBatPlayers,
            fallofwicketsLabel: fallOfwicketsLabel,
            fallofWickets: fallOfWickets));

        // Extract data for the bowlers headers
        final bowlerheaderDivs =
            document.querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray')[2];
        final bowlerheaderColumns =
            bowlerheaderDivs.querySelectorAll('.cb-col');
        final bowlerHeader = bowlerheaderColumns[0].text;
        final overs = bowlerheaderColumns[1].text;
        final maidens = bowlerheaderColumns[2].text;
        final runs = bowlerheaderColumns[3].text;
        final wickets = bowlerheaderColumns[4].text;
        final noBalls = bowlerheaderColumns[5].text;
        final wides = bowlerheaderColumns[6].text;
        final economy = bowlerheaderColumns[7].text;

        print(
            'Bowler Header: $bowlerHeader $overs $maidens $runs $wickets $noBalls $wides $economy');

        firstbowlerHeaderItems.add(FirstBowlerHeaderItem(
            bowlerHeader: bowlerHeader,
            oversHeader: overs,
            maidensHeader: maidens,
            runsHeader: runs,
            wicketsHeader: wickets,
            noballsHeader: noBalls,
            widesHeader: wides,
            economyHeader: economy));

        // Extract data for the bowlers Data
        final bowlerDataElements =
            firstinningsextraDiv.querySelectorAll('.cb-ltst-wgt-hdr')[1];
        final bowlerDivs = bowlerDataElements
            .querySelectorAll('.cb-col.cb-col-100.cb-scrd-itms');
        for (var bowlerDiv in bowlerDivs) {
          final bowlerName =
              bowlerDiv.querySelector('a.cb-text-link')?.text.trim() ?? '';
          final overs = bowlerDiv
                  .querySelector('.cb-col.cb-col-8.text-right')
                  ?.text
                  .trim() ??
              '';
          final maidens = bowlerDiv
              .querySelectorAll('.cb-col.cb-col-8.text-right')[1]
              .text
              .trim();
          final runs = bowlerDiv
                  .querySelector('.cb-col.cb-col-10.text-right')
                  ?.text
                  .trim() ??
              '';
          final wickets = bowlerDiv
                  .querySelector('.cb-col.cb-col-8.text-bold.text-right')
                  ?.text
                  .trim() ??
              '';
          final noBalls = bowlerDiv
              .querySelectorAll('.cb-col.cb-col-8.text-right')[3]
              .text
              .trim();
          final wides = bowlerDiv
              .querySelectorAll('.cb-col.cb-col-8.text-right')[4]
              .text
              .trim();

          final textRightElements =
              bowlerDiv.querySelectorAll('.cb-col.cb-col-10.text-right');
          final economy = textRightElements.length > 1
              ? textRightElements[1].text.trim()
              : '';

          print(
              'Bowler Data: $bowlerName $overs $maidens $runs $wickets $noBalls $wides $economy');

          firstbowlerDataItems.add(FirstBowlerDataItem(
              bowlerName: bowlerName,
              overs: overs,
              maidens: maidens,
              runs: runs,
              wickets: wickets,
              noballs: noBalls,
              wides: wides,
              economy: economy));
        }

        // for extract the Powerplay headers
        final powerplaysDiv = firstinningsextraDiv
            .querySelectorAll('.cb-scrd-sub-hdr.cb-bg-gray.text-bold')[1];
        final powerplayHeader =
            powerplaysDiv.querySelector('.cb-col-33')?.text ?? '';
        final oversHeader =
            powerplaysDiv.querySelector('.cb-col-33.text-center')?.text ?? '';
        final runsHeader =
            powerplaysDiv.querySelector('.cb-col-33.text-right')?.text ?? '';

        print('Powerplay: $powerplayHeader $oversHeader $runsHeader');

        firstpowerplayItems.add(FirstPowerPlayItem(
            powerplaysLabel: powerplayHeader,
            oversLabel: oversHeader,
            runsLabel: runsHeader));

        // for extract the Powerplay Data
        final powerplayLabel =
            firstinningsextraDiv.querySelectorAll('.cb-col-rt.cb-font-13')[1];
        final mandatoryValue =
            powerplayLabel.querySelector('.cb-col-33')?.text ?? '';
        final oversValue =
            powerplayLabel.querySelector('.cb-col-33.text-center')?.text ?? '';
        final runsValue =
            powerplayLabel.querySelector('.cb-col-33.text-right')?.text ?? '';

        print('Powerplay: $mandatoryValue $oversValue $runsValue');
        firstpowerplayDataItems.add(FirstPowerPlayDataItem(
            powerplaysValue: mandatoryValue,
            oversValue: oversValue,
            runsValue: runsValue));
      }

      //////////////////////////////////////

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
            itemCount: scoreHeaderItems.length,
            itemBuilder: (context, index) {
              final scoreHeaderItem = scoreHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${scoreHeaderItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${scoreHeaderItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header: ${scoreHeaderItem.batterHeader}'),
                  Text('Runs Header: ${scoreHeaderItem.runsHeader}'),
                  Text('Balls Header: ${scoreHeaderItem.ballsHeader}'),
                  Text('Fours Header: ${scoreHeaderItem.foursHeader}'),
                  Text('Sixes Header: ${scoreHeaderItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header: ${scoreHeaderItem.strikeRateHeader}'),
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
                  Text('Batter Name: ${scorecardItem.batterName}'),
                  Text('Dissmisal: ${scorecardItem.dismissal}'),
                  Text('Runs: ${scorecardItem.runs}'),
                  Text('Balls: ${scorecardItem.balls}'),
                  Text('Fours: ${scorecardItem.fours}'),
                  Text('Sixes: ${scorecardItem.sixes}'),
                  Text('Strike Rate: ${scorecardItem.strikeRate}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: totalscoreItems.length,
            itemBuilder: (context, index) {
              final totalscoreItem = totalscoreItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      '${totalscoreItem.extrasLabel} : ${totalscoreItem.extrasValue} ${totalscoreItem.extrasDetails}'),
                  Text(
                      '${totalscoreItem.totalLabel} : ${totalscoreItem.totalValue} ${totalscoreItem.totalDetails}'),
                  Text(
                      '${totalscoreItem.yettobatLabel} : ${totalscoreItem.yettobatPlayers}'),
                  Text(
                      '${totalscoreItem.fallofwicketsLabel} : ${totalscoreItem.fallofWickets}'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: bowlerHeaderItems.length,
            itemBuilder: (context, index) {
              final bowlerHeaderItem = bowlerHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Header: ${bowlerHeaderItem.bowlerHeader}'),
                  Text('Overs Header: ${bowlerHeaderItem.oversHeader}'),
                  Text('Maidens Header: ${bowlerHeaderItem.maidensHeader}'),
                  Text('Runs Header: ${bowlerHeaderItem.runsHeader}'),
                  Text('Wickets Header: ${bowlerHeaderItem.wicketsHeader}'),
                  Text('No Ball Header: ${bowlerHeaderItem.noballsHeader}'),
                  Text('Wides Header: ${bowlerHeaderItem.widesHeader}'),
                  Text('Economy Header: ${bowlerHeaderItem.economyHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: bowlerDataItems.length,
            itemBuilder: (context, index) {
              final bowlerDataItem = bowlerDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Name: ${bowlerDataItem.bowlerName}'),
                  Text('Overs: ${bowlerDataItem.overs}'),
                  Text('Maidens: ${bowlerDataItem.maidens}'),
                  Text('Runs: ${bowlerDataItem.runs}'),
                  Text('Wickets: ${bowlerDataItem.wickets}'),
                  Text('No Ball: ${bowlerDataItem.noballs}'),
                  Text('Wides: ${bowlerDataItem.wides}'),
                  Text('Economy: ${bowlerDataItem.economy}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: powerplayItems.length,
            itemBuilder: (context, index) {
              final powerplayItem = powerplayItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('PowerPlay Label: ${powerplayItem.powerplaysLabel}'),
                  Text('Overs Label: ${powerplayItem.oversLabel}'),
                  Text('Runs Label: ${powerplayItem.runsLabel}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: powerplayDataItems.length,
            itemBuilder: (context, index) {
              final powerplayDataItem = powerplayDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('PowerPlay Value: ${powerplayDataItem.powerplaysValue}'),
                  Text('Overs Value: ${powerplayDataItem.oversValue}'),
                  Text('Runs Value: ${powerplayDataItem.runsValue}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstscoreHeaderItems.length,
            itemBuilder: (context, index) {
              final firstscoreHeaderItem = firstscoreHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Innings Title : ${firstscoreHeaderItem.inningsTitle}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Innings Info : ${firstscoreHeaderItem.inningsInfo}'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Batter Header: ${firstscoreHeaderItem.batterHeader}'),
                  Text('Runs Header: ${firstscoreHeaderItem.runsHeader}'),
                  Text('Balls Header: ${firstscoreHeaderItem.ballsHeader}'),
                  Text('Fours Header: ${firstscoreHeaderItem.foursHeader}'),
                  Text('Sixes Header: ${firstscoreHeaderItem.sixesHeader}'),
                  Text(
                      'Strike Rate Header: ${firstscoreHeaderItem.strikeRateHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstscorecardItems.length,
            itemBuilder: (context, index) {
              final firstscorecardItem = firstscorecardItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Batter Name: ${firstscorecardItem.batterName}'),
                  Text('Dissmisal: ${firstscorecardItem.dismissal}'),
                  Text('Runs: ${firstscorecardItem.runs}'),
                  Text('Balls: ${firstscorecardItem.balls}'),
                  Text('Fours: ${firstscorecardItem.fours}'),
                  Text('Sixes: ${firstscorecardItem.sixes}'),
                  Text('Strike Rate: ${firstscorecardItem.strikeRate}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firsttotalscoreItems.length,
            itemBuilder: (context, index) {
              final firsttotalscoreItem = firsttotalscoreItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      '${firsttotalscoreItem.extrasLabel} : ${firsttotalscoreItem.extrasValue} ${firsttotalscoreItem.extrasDetails}'),
                  Text(
                      '${firsttotalscoreItem.totalLabel} : ${firsttotalscoreItem.totalValue} ${firsttotalscoreItem.totalDetails}'),
                  Text(
                      '${firsttotalscoreItem.yettobatLabel} : ${firsttotalscoreItem.yettobatPlayers}'),
                  Text(
                      '${firsttotalscoreItem.fallofwicketsLabel} : ${firsttotalscoreItem.fallofWickets}'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstbowlerHeaderItems.length,
            itemBuilder: (context, index) {
              final firstbowlerHeaderItem = firstbowlerHeaderItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Header: ${firstbowlerHeaderItem.bowlerHeader}'),
                  Text('Overs Header: ${firstbowlerHeaderItem.oversHeader}'),
                  Text(
                      'Maidens Header: ${firstbowlerHeaderItem.maidensHeader}'),
                  Text('Runs Header: ${firstbowlerHeaderItem.runsHeader}'),
                  Text(
                      'Wickets Header: ${firstbowlerHeaderItem.wicketsHeader}'),
                  Text(
                      'No Ball Header: ${firstbowlerHeaderItem.noballsHeader}'),
                  Text('Wides Header: ${firstbowlerHeaderItem.widesHeader}'),
                  Text(
                      'Economy Header: ${firstbowlerHeaderItem.economyHeader}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstbowlerDataItems.length,
            itemBuilder: (context, index) {
              final firstbowlerDataItem = firstbowlerDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Bowler Name: ${firstbowlerDataItem.bowlerName}'),
                  Text('Overs: ${firstbowlerDataItem.overs}'),
                  Text('Maidens: ${firstbowlerDataItem.maidens}'),
                  Text('Runs: ${firstbowlerDataItem.runs}'),
                  Text('Wickets: ${firstbowlerDataItem.wickets}'),
                  Text('No Ball: ${firstbowlerDataItem.noballs}'),
                  Text('Wides: ${firstbowlerDataItem.wides}'),
                  Text('Economy: ${firstbowlerDataItem.economy}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstpowerplayItems.length,
            itemBuilder: (context, index) {
              final firstpowerplayItem = firstpowerplayItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      'PowerPlay Label: ${firstpowerplayItem.powerplaysLabel}'),
                  Text('Overs Label: ${firstpowerplayItem.oversLabel}'),
                  Text('Runs Label: ${firstpowerplayItem.runsLabel}'),
                ],
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: firstpowerplayDataItems.length,
            itemBuilder: (context, index) {
              final firstpowerplayDataItem = firstpowerplayDataItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      'PowerPlay Value: ${firstpowerplayDataItem.powerplaysValue}'),
                  Text('Overs Value: ${firstpowerplayDataItem.oversValue}'),
                  Text('Runs Value: ${firstpowerplayDataItem.runsValue}'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
