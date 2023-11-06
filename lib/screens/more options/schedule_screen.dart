import 'package:cricket_worldcup_app/screens/more%20options/series_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/text_style.dart';

class SeriesName {
  final String seriesName;
  final String seriesDate;
  final String seriesUrl;
  SeriesName({
    required this.seriesName,
    required this.seriesDate,
    required this.seriesUrl,
  });
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<SeriesName> seriesName = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scheduleMatches();
  }

  Future<void> scheduleMatches() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse('https://www.cricbuzz.com/cricket-schedule/series'),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final elements = document.querySelectorAll(
          '.cb-col-100[ng-if*="filtered_category == 0 || filtered_category == 9"] .cb-sch-lst-itm');
      for (var element in elements) {
        final text1 = element.querySelector('span')?.text ?? '';
        final text2 =
            element.querySelector('.text-gray.cb-font-12')?.text ?? '';
        final href = element.querySelector('a')!.attributes['href'] ?? '';

        print('Text 1: $text1');
        print('Text 2: $text2');
        print('Href : $href');

        seriesName.add(
            SeriesName(seriesName: text1, seriesDate: text2, seriesUrl: href));
      }

      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    } else {
      print('Failed to fetch matches: ${response.statusCode}');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 19, 1),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Rectangle 6370.png'),
                fit: BoxFit.cover)),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  size: 50,
                  color: Color.fromARGB(255, 114, 255, 48),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  Text('Cricket Schedule',
                      style: textMethod(Colors.white, 20.sp, FontWeight.bold,
                          'Mulish-ExtraBold')),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: seriesName.length,
                    itemBuilder: (context, index) {
                      final item = seriesName[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(item.seriesName,
                                style: textMethod(Colors.white, 16.sp,
                                    FontWeight.normal, 'Mulish-ExtraBold')),
                            subtitle: Text(item.seriesDate,
                                style: textMethod(Colors.white, 14.sp,
                                    FontWeight.normal, 'SpaceGrotesk-Regular')),
                            onTap: () async {
                              Get.to(SeriesDetail(
                                seriesurl:
                                    'https://www.cricbuzz.com/${item.seriesUrl}',
                              ));
                            },
                          ),
                          Divider(
                            color: Colors.white,
                            height: 4.0,
                          )
                        ],
                      );
                    },
                  ),
                ]),
              ),
      ),
    );
  }
}
