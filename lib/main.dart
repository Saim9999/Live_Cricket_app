import 'package:cricket_worldcup_app/screens/live_score_rough.dart';
import 'package:cricket_worldcup_app/screens/main_home_screen.dart';
import 'package:cricket_worldcup_app/screens/newscreen.dart';
import 'package:cricket_worldcup_app/screens/scorecard_rough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: LiveScoreRough());
        });
  }
}
