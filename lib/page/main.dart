import 'package:apspace_plus/page/NewAttendance.dart';
import 'package:apspace_plus/page/attendance.dart';
import 'package:apspace_plus/page/Menu.dart';
import 'package:apspace_plus/page/Wallet.dart';
import 'package:apspace_plus/page/attendanceSuccess.dart';
import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/page/timetable.dart';
import 'package:apspace_plus/process/Course.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

Future startGet;
Future<List<Course>> futCourse;
Future<List<Course>> cFuture;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white
    ));
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);
            return MaterialApp(
              color: Colors.white,
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
class FrontPage extends StatefulWidget {

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width / 10;
    double height = MediaQuery.of(context).size.height / 10;

    return Scaffold(
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
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.of(context).push(_toHome());
                      });
                    },
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Route _toHome() {

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Nav(),
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeOutCirc;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
            position:animation.drive(tween),
            child: child,
        );
      }
    );
  }
}

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {

  int _selectedIndex = 2;

  Widget _body;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    startGet = login();
    checkDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          startGet,
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {

          if (!snapshot.hasData) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 80, right: 80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LinearProgressIndicator(),
                ),
              ),
            );
          }

          return Scaffold(
            body: IndexedStack(
              children: <Widget>[
                Timetable(),
                Attendance(),
                Home(infoData: snapshot.data[0],),
                Wallet(),
                Menu(),
              ],
              index: _selectedIndex,
            ),
            bottomNavigationBar: BottomNavigationBar(

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon:  Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      children: [
                        ImageIcon(AssetImage('lib/images/calendar.png')),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Timetable",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: 'Timetable',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      children: [
                        ImageIcon(AssetImage('lib/images/pie.png')),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Attendance",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: CircleAvatar(
                      radius: 20,
                      child: ImageIcon(
                        AssetImage('lib/images/flat apu.png'),
                        size: 20,
                      ),
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      children: [
                        ImageIcon(AssetImage('lib/images/wallet.png')),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Wallet",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage('lib/images/list.png')),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Menu",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: 'Menu',
                ),
              ],
              currentIndex: _selectedIndex,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blueAccent[400],
              selectedFontSize: 8.0.sp,
              unselectedFontSize: 8.0.sp,
              unselectedItemColor: Colors.grey[600],
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
            ),
          );

        }
    );
  }
}


