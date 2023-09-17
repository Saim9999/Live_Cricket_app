import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/fixture_date_screen.dart';

class FixtureScreen extends StatefulWidget {
  const FixtureScreen({super.key});

  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {
  late Timer timer;
  final DateTime targetDateTime = DateTime(2023, 10, 05, 13, 30, 00);
  Duration _calculateRemainingTime() {
    final now = DateTime.now();
    final remainingTime = targetDateTime.difference(now);
    return remainingTime.isNegative ? Duration.zero : remainingTime;
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _calculateRemainingTime();
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 19, 1),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/blur backgroung.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.red,
                    highlightColor: Colors.amber,
                    period: Duration(seconds: 3),
                    child: Text(
                      'CWC OCT 05 - NOV 19',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Mulish-ExtraBold',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'CWC Starts in..',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'SpaceGrotesk-Regular',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClockItem(
                          label: 'Months',
                          value: '${remainingTime.inDays ~/ 30}'),
                      SizedBox(
                        width: 5.w,
                      ),
                      ClockItem(
                          label: 'Days', value: '${remainingTime.inDays % 30}'),
                      SizedBox(
                        width: 5.w,
                      ),
                      ClockItem(
                          label: 'Hrs', value: '${remainingTime.inHours % 24}'),
                      SizedBox(
                        width: 5.w,
                      ),
                      ClockItem(
                          label: 'Mins',
                          value: '${remainingTime.inMinutes % 60}'),
                      SizedBox(
                        width: 5.w,
                      ),
                      ClockItem(
                          label: 'Secs',
                          value: '${remainingTime.inSeconds % 60}'),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'Thursday 05 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 1',
                      timeText: '1:30 PM',
                      stadiumText: 'Narendra Modi Stadium, Ahmedabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENGLAND',
                      secondTeamFlag: 'assets/images/new-zealand.png',
                      secondTeamName: 'NEW ZEALAND'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'Friday 06 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 2',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Rajiv Gandhi International Stadium, Hyderabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/pakistan.png',
                      firstTeamName: 'PAKISTAN',
                      secondTeamFlag: 'assets/images/netherlands.png',
                      secondTeamName: 'NETHERLANDS'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'Saturday 07 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 3',
                      timeText: '10:00 AM',
                      stadiumText:
                          'Himachal Pradesh Cricket Association Stadium, Dharamsala',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/bangladesh.png',
                      firstTeamName: 'BANGLADESH',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 5.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 4',
                      timeText: '1:30 PM',
                      stadiumText: 'Arun Jaitley Stadium, Delhi',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/south_africa.png',
                      firstTeamName: 'SOUTH AFRICA',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 08 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 5',
                      timeText: '1:30 PM',
                      stadiumText: 'MA Chidambaram Stadium, Chennai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/australia.png',
                      secondTeamName: 'AUSTRALIA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'MONDAY 09 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 6',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Rajiv Gandhi International Stadium, Hyderabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/new-zealand.png',
                      firstTeamName: 'NEW ZEALAND',
                      secondTeamFlag: 'assets/images/netherlands.png',
                      secondTeamName: 'NETHERLANDS'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'TUESDAY 10 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 7',
                      timeText: '10:00 AM',
                      stadiumText:
                          'Himachal Pradesh Cricket Association Stadium, Dharamsala',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH '),
                  SizedBox(
                    height: 5.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 8',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Rajiv Gandhi International Stadium, Hyderabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/pakistan.png',
                      firstTeamName: 'PAKISTAN',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA '),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'WEDNESDAY 11 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 9',
                      timeText: '1:30 PM',
                      stadiumText: 'Arun Jaitley Stadium, Delhi',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'THURSDAY 12 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 10',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium, Lucknow',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/south_africa.png',
                      secondTeamName: 'SOUTH AFRICA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'FRIDAY 13 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 11',
                      timeText: '1:30 PM',
                      stadiumText: 'MA Chidambaram Stadium, Chennai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/new-zealand.png',
                      firstTeamName: 'NEW ZEALAND',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SATURDAY 14 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 12',
                      timeText: '1:30 PM',
                      stadiumText: 'Narendra Modi Stadium, Ahmedabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/pakistan.png',
                      secondTeamName: 'PAKISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 15 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 13',
                      timeText: '1:30 PM',
                      stadiumText: 'Arun Jaitley Stadium, Delhi',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'MONDAY 16 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 14',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium, Lucknow',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'TUESDAY 17 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 15',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Himachal Pradesh Cricket Association Stadium, Dharamsala',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/south_africa.png',
                      firstTeamName: 'SOUTH AFRICA',
                      secondTeamFlag: 'assets/images/netherlands.png',
                      secondTeamName: 'NETHERLANDS'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'WEDNESDAY 18 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 16',
                      timeText: '1:30 PM',
                      stadiumText: 'MA Chidambaram Stadium, Chennai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/new-zealand.png',
                      firstTeamName: 'NEW ZEALAND',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'THURSDAY 19 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 17',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Maharashtra Cricket Association Stadium, Pune',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'FRIDAY 20 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 18',
                      timeText: '1:30 PM',
                      stadiumText: 'M.Chinnaswamy Stadium, Bengaluru',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/pakistan.png',
                      secondTeamName: 'PAKISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SATURDAY 21 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 19',
                      timeText: '10:00 AM',
                      stadiumText:
                          'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium, Lucknow',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/netherlands.png',
                      firstTeamName: 'NETHERLANDS',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 5.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 20',
                      timeText: '1:30 PM',
                      stadiumText: 'Wankhede Stadium, Mumbai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/south_africa.png',
                      secondTeamName: 'SOUTH AFRICA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 22 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 21',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Himachal Pradesh Cricket Association Stadium, Dharamsala',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/new-zealand.png',
                      secondTeamName: 'NEW ZEALAND'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'MONDAY 23 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 22',
                      timeText: '1:30 PM',
                      stadiumText: 'MA Chidambaram Stadium, Chennai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/pakistan.png',
                      firstTeamName: 'PAKISTAN',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'TUESDAY 24 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 23',
                      timeText: '1:30 PM',
                      stadiumText: 'Wankhede Stadium, Mumbai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/south_africa.png',
                      firstTeamName: 'SOUTH AFRICA',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'WEDNESDAY 25 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 24',
                      timeText: '1:30 PM',
                      stadiumText: 'Arun Jaitley Stadium, Delhi',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/netherlands.png',
                      secondTeamName: 'NETHERLANDS'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'THURSDAY 26 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 25',
                      timeText: '1:30 PM',
                      stadiumText: 'M.Chinnaswamy Stadium, Bengaluru',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'FRIDAY 27 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 26',
                      timeText: '1:30 PM',
                      stadiumText: 'MA Chidambaram Stadium, Chennai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/pakistan.png',
                      firstTeamName: 'PAKISTAN',
                      secondTeamFlag: 'assets/images/south_africa.png',
                      secondTeamName: 'SOUTH AFRICA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SATURDAY 28 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 27',
                      timeText: '10:00 AM',
                      stadiumText:
                          'Himachal Pradesh Cricket Association Stadium, Dharamsala',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/new-zealand.png',
                      secondTeamName: 'NEW ZEALAND'),
                  SizedBox(
                    height: 5.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 28',
                      timeText: '1:30 PM',
                      stadiumText: 'Eden Gardens, Kolkata',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/netherlands.png',
                      firstTeamName: 'NETHERLANDS',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 29 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 29',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium, Lucknow',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/england.png',
                      secondTeamName: 'ENDLAND'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'MONDAY 30 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 30',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Maharashtra Cricket Association Stadium, Pune',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/afghanistan.png',
                      firstTeamName: 'AFGHANISTAN',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'TUESDAY 31 October, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 31',
                      timeText: '1:30 PM',
                      stadiumText: 'Eden Gardens, Kolkata',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/pakistan.png',
                      firstTeamName: 'PAKISTAN',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'WEDNESDAY 01 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 32',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Maharashtra Cricket Association Stadium, Pune',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/new-zealand.png',
                      firstTeamName: 'NEW ZEALAND',
                      secondTeamFlag: 'assets/images/south_africa.png',
                      secondTeamName: 'SOUTH AFRICA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'THURSDAY 02 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 33',
                      timeText: '1:30 PM',
                      stadiumText: 'Wankhede Stadium, Mumbai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'FRIDAY 03 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 34',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium, Lucknow',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/netherlands.png',
                      firstTeamName: 'NETHERLANDS',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SATURDAY 04 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 35',
                      timeText: '10:00 AM',
                      stadiumText: 'M.Chinnaswamy Stadium, Bengaluru',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/new-zealand.png',
                      firstTeamName: 'NEW ZEALAND',
                      secondTeamFlag: 'assets/images/pakistan.png',
                      secondTeamName: 'PAKISTAN'),
                  SizedBox(
                    height: 5.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 36',
                      timeText: '1:30 PM',
                      stadiumText: 'Narendra Modi Stadium, Ahmedabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/australia.png',
                      secondTeamName: 'AUSTRALIA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 05 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 37',
                      timeText: '1:30 PM',
                      stadiumText: 'Eden Gardens, Kolkata',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/south_africa.png',
                      secondTeamName: 'SOUTH AFRICA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'MONDAY 06 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 38',
                      timeText: '1:30 PM',
                      stadiumText: 'Arun Jaitley Stadium, Delhi',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/bangladesh.png',
                      firstTeamName: 'BANGLADESH',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'TUESDAY 07 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 39',
                      timeText: '1:30 PM',
                      stadiumText: 'Wankhede Stadium, Mumbai',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'WEDNESDAY 08 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 40',
                      timeText: '1:30 PM',
                      stadiumText:
                          'Maharashtra Cricket Association Stadium, Pune',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/netherlands.png',
                      secondTeamName: 'NETHERLANDS'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'THURSDAY 09 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 41',
                      timeText: '1:30 PM',
                      stadiumText: 'M.Chinnaswamy Stadium, Bengaluru',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/new-zealand.png',
                      firstTeamName: 'NEW ZEALAND',
                      secondTeamFlag: 'assets/images/sri_lanka.png',
                      secondTeamName: 'SRI LANKA'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'FRIDAY 10 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 42',
                      timeText: '1:30 PM',
                      stadiumText: 'Narendra Modi Stadium, Ahmedabad',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/south_africa.png',
                      firstTeamName: 'SOUTH AFRICA',
                      secondTeamFlag: 'assets/images/afghanistan.png',
                      secondTeamName: 'AFGHANISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SATURDAY 11 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 43',
                      timeText: '10:00 AM',
                      stadiumText:
                          'Maharashtra Cricket Association Stadium, Pune',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/australia.png',
                      firstTeamName: 'AUSTRALIA',
                      secondTeamFlag: 'assets/images/bangladesh.png',
                      secondTeamName: 'BANGLADESH'),
                  SizedBox(
                    height: 5.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 44',
                      timeText: '1:30 PM',
                      stadiumText: 'Eden Gardens, Kolkata',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/england.png',
                      firstTeamName: 'ENDLAND',
                      secondTeamFlag: 'assets/images/pakistan.png',
                      secondTeamName: 'PAKISTAN'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 12 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'Match 45',
                      timeText: '1:30 PM',
                      stadiumText: 'Eden Gardens, Kolkata',
                      roundStageText: 'Group Stage',
                      firstTeamFlag: 'assets/images/india.png',
                      firstTeamName: 'INDIA',
                      secondTeamFlag: 'assets/images/netherlands.png',
                      secondTeamName: 'NETHERLANDS'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const Center(
                      child: FixtureDateWidget(text: 'KNOCKOUT STAGE')),
                  const FixtureDateWidget(text: 'WEDNESDAY 15 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: '1ST SEMI-FINAL',
                      timeText: '1:30 PM',
                      stadiumText: 'Wankhede Stadium, Mumbai',
                      roundStageText: 'KNOCKOUT Stage',
                      firstTeamFlag: 'assets/images/shield 1.png',
                      firstTeamName: '1ST PLACE',
                      secondTeamFlag: 'assets/images/shield 1.png',
                      secondTeamName: '4TH PLACE'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'THURSDAY 16 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: '2ND SEMI-FINAL',
                      timeText: '1:30 PM',
                      stadiumText: 'Eden Gardens, Kolkata',
                      roundStageText: 'KNOCKOUT Stage',
                      firstTeamFlag: 'assets/images/shield 1.png',
                      firstTeamName: '2ND PLACE',
                      secondTeamFlag: 'assets/images/shield 1.png',
                      secondTeamName: '3RD PLACE'),
                  SizedBox(
                    height: 16.h,
                  ),
                  const FixtureDateWidget(text: 'SUNDAY 19 NOVEMBER, 2023'),
                  SizedBox(
                    height: 10.h,
                  ),
                  const FixtureContainer(
                      matchText: 'FINAL',
                      timeText: '1:30 PM',
                      stadiumText: 'Narendra Modi Stadium, Ahmedabad',
                      roundStageText: 'KNOCKOUT Stage',
                      firstTeamFlag: 'assets/images/shield 1.png',
                      firstTeamName: 'WINNER OF 1ST SEMI-FINAL',
                      secondTeamFlag: 'assets/images/shield 1.png',
                      secondTeamName: 'WINNER OF 2ND SEMI-FINAL'),
                ],
              ),
            ),
          ],
        ));
  }
}

class ClockItem extends StatefulWidget {
  final String label;
  final String value;

  ClockItem({required this.label, required this.value});

  @override
  State<ClockItem> createState() => _ClockItemState();
}

class _ClockItemState extends State<ClockItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              widget.value.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SpaceGrotesk-Regular',
                  color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontFamily: 'SpaceGrotesk-Regular',
          ),
        ),
      ],
    );
  }
}
