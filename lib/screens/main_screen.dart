// import 'package:cricket_worldcup_app/screens/fixtures_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Color.fromARGB(255, 15, 19, 1),
//         appBar: AppBar(
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: Image.asset(
//                 'assets/images/2023_CWC_Logo.png',
//                 width: 60.w,
//               ),
//             ),
//           ],
//           toolbarHeight: 90.h,
//           bottom: TabBar(
//             indicatorColor: Color.fromARGB(255, 114, 255, 48),
//             tabs: [
//               Tab(
//                 child: Text(
//                   'FIXTURES',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: 'SpaceGrotesk-Regular',
//                   ),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'RESULTS',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: 'SpaceGrotesk-Regular',
//                   ),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'STANDINGS',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontFamily: 'SpaceGrotesk-Regular',
//                   ),
//                 ),
//               ),
//             ],
//           ), // TabBar
//           title: Text(
//             'Matches',
//             style: TextStyle(fontSize: 34.sp, fontFamily: 'Mulish-ExtraBold'),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//         ), // AppBar
//         body: Stack(
//           children: [
//             Image.asset('assets/images/blur backgroung.png'),
//             TabBarView(
//               children: [
//                 FixtureScreen(),
//                 // Icon(Icons.music_note),
//                 Icon(Icons.music_video),
//                 Icon(Icons.camera_alt),
//               ],
//             ),
//           ],
//         ),
//         // bottomNavigationBar: ,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassmorphicSample extends StatefulWidget {
  const GlassmorphicSample({super.key});

  @override
  State<GlassmorphicSample> createState() => GlassmorphicSampleState();
}

class GlassmorphicSampleState extends State<GlassmorphicSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 19, 1),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/backgroung_cricket_image.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            SafeArea(
              child: Center(
                child: GlassmorphicContainer(
                    width: 350,
                    height: 750,
                    borderRadius: 20,
                    blur: 10,
                    alignment: Alignment.bottomCenter,
                    border: 2,
                    linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.1),
                          Color(0xFFFFFFFF).withOpacity(0.05),
                        ],
                        stops: [
                          0.1,
                          1,
                        ]),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFffffff).withOpacity(0.5),
                        Color((0xFFFFFFFF)).withOpacity(0.5),
                      ],
                    ),
                    child: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
