import 'package:apspace_plus/process/Album.dart';
import 'package:apspace_plus/process/AlbumsList.dart';
import 'package:apspace_plus/process/Course.dart';
import 'package:apspace_plus/process/getCourse.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


List<Course> courseList = [];
// ignore: must_be_immutable
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future startGet;
  var cData;

  @override
  void initState() {
    startGet = login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<http.Response>(
        future: startGet,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 12.0.h, bottom: 3.0.h),
                  width: 100.0.h,
                  child: Center(
                      child: CircleAvatar(
                        radius: 15.0.w,
                        backgroundColor: Colors.orange[100],
                        child: CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          radius: 12.0.w,
                          backgroundImage: AssetImage('lib/images/coffee.png'),
                        ),
                      )
                  ),
                ),
                Container(
                  child: Text(
                    "Welcome, Aaron",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 0, bottom: 3.0.h),
                  child: Text(
                    "Stay up-to-date",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w200,
                      fontSize: 18,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                Container(
                    height: 10.0.h,
                    width: 100.0.w,
                    child: Container(
                      padding: EdgeInsets.only(left: 6.5.w, top: 8, right: 6.5.w, bottom: 20),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent[400],
                        ),
                        child: Text("Sign Attendance",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.25,
                          ),),
                        onPressed: () {

                        },
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.only(top: 2.5.h, bottom: 0.5.h, left: 7.0.w, right: 6.5.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Schedule",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 6.5.w, right: 6.5.w, bottom: 4.0.h),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.0.h, bottom: 4.0.h, left: 3.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.0.h),
                            child: Text(DateFormat('EEEE, dd MMMM').format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ),
                          FutureBuilder<List<Album>>(
                              future: fetchAlbum(http.Client()),
                              builder: (context, snapshot){
                                return snapshot.hasData
                                    ? AlbumsList()
                                    : Padding(
                                    padding: EdgeInsets.only(top: 24, bottom: 24),
                                    child: Center(child: CircularProgressIndicator()));

                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 10.0.h,
                    width: 100.0.w,
                    child: Container(
                      padding: EdgeInsets.only(left: 6.5.w, top: 8, right: 6.5.w, bottom: 20),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent[400],
                        ),
                        child: Text("Check",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.25,
                          ),),
                        onPressed: () {
                          checkDate();
                          check();
                        },
                      ),
                    )
                ),
              ],
            ), //pfp
          );
        },
      ),
    );
  }

  check() {

    print(DateTime.now().day + 2);

  }
}

Future<http.Response> login() async {

  var tick;
  var tick1;

  var link = Uri.https('cas.apiit.edu.my', '/cas/v1/tickets');

  var queryParam = {
    'service': 'https://api.apiit.edu.my/student/attendance',
  };

  //login to apspace using http POST
  var loginReq = await http.post(
      link,
      headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
      body: {'username': 'tp051733', 'password': 'kokotch12'}).then((http.Response response) {

    print(response.headers['location'].split('/').reversed.first);
    tick = response.headers['location'].split('/').reversed.first;

  }).then((http.Response att) async { //retrieve ticket

    var attTicket = Uri.https('cas.apiit.edu.my', '/cas/v1/tickets/' + tick, queryParam);

    var att = await http.post( //retrieve inner ticket
      attTicket,
      headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
    );

    tick1 = att.body;
    print(att.body);

  });

  fetchCourse(http.Client(), tick1).then((value) {

    courseList = value;
    print(courseList);

  });

  return loginReq;

}

checkDate() {

  if (DateFormat('EEEE').format(DateTime.now()).toUpperCase() == "SATURDAY") {
    print(DateTime.now().day + 2);
  }
  else if (DateFormat('EEEE').format(DateTime.now()).toUpperCase() == "SUNDAY") {
    print(DateTime.now().day + 1);
  }
  else {
    print(DateTime.now().day);
    print("its weekday");
  }

  print(DateFormat('MMM-yy').format(DateTime.now()).toUpperCase());

}

//TODO: Navbar, timetable, attendance, apcard.