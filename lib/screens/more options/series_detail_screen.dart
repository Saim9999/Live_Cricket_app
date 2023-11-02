import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class SeriesDetail extends StatefulWidget {
  final String seriesurl;

  const SeriesDetail({super.key, required this.seriesurl});

  @override
  State<SeriesDetail> createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    seriesDetail();
  }

  Future<void> seriesDetail() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(widget.seriesurl),
    );
    if (response.statusCode == 200) {
      final document = html.parse(response.body);

      final mainelements = document.querySelectorAll('.cb-col.cb-nav-main');

      for (var element in mainelements) {
        final title = element.querySelector('.cb-nav-hdr')?.text ?? '';
        final detail = element.querySelector('.text-gray')?.text ?? '';

        print('Title : $title');
        print('Detail : ${detail.replaceAll('  ', ' ')}');
      }

      final subelements = document.querySelectorAll('.cb-srs-gray-strip');

      for (var element in subelements) {
        final title = element.querySelector('.cb-col-25.cb-col')?.text ?? '';
        final detail = element.querySelector('.cb-col-40.cb-col')?.text ?? '';
        final time = element.querySelector('.cb-col-33.cb-col')?.text ?? '';

        print('Title : $title');
        print('Detail : $detail');
        print('Detail1 : $time');
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
          child: ListView(
            children: [
              // Text(
              //   widget.seriesurl,
              //   style: TextStyle(color: Colors.white),
              // )
            ],
          ),
        ));
  }
}
