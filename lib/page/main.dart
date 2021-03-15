import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/getCourse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              initialRoute: '/start',
              routes: {
                '/start': (context) => FrontPage(),
                '/home': (context) => Home(),
              },
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class FrontPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width / 10;
    double height = MediaQuery.of(context).size.height / 10;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: height * 9,
                width: width * 10,
                child: Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image(image: AssetImage('lib/images/stars.png')),
                              Image(
                                  image: AssetImage('lib/images/flat apu.png'),
                                  width: 220,
                                  height: 220
                              ),
                            ],
                          ),
                          Text("APSPACE 2.0",
                            style: TextStyle(
                              letterSpacing: 0.25,
                              fontFamily: 'OCR',
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              //fontStyle: 'regular',
                              //fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ),
              Container(
                  height: height * 1,
                  width: width * 10,
                  child: Container(
                    padding: EdgeInsets.only(left: 24, top: 8, right: 24, bottom: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blueAccent[400],
                      ),
                      child: Text("Get started",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),),
                      onPressed: () {
                        Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeft,
                            curve: Curves.easeInOut,
                            child: Home()),
                        );
                      },
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}


