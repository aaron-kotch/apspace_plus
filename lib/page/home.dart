import 'package:apspace_plus/page/main.dart';
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


List<Course> courseList;
var date;
int currPage = 0;

class Home extends StatefulWidget {
  static Future fetch;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  int _selectedIndex = 2;

  @override
  void initState() {
    Home.fetch = fetchAlbum(http.Client());

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var cData;

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
                          checkDate();
                        },
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.only(top: 2.5.h, bottom: 1.0.h, left: 7.5.w, right: 6.5.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0.sp,
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
                      padding: EdgeInsets.only(top: 3.0.h, bottom: 4.0.h, left: 3.0.h, right: 3.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.0.h),
                            child: Text(DateFormat('EEEE, dd MMMM').format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0.sp,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ),
                          FutureBuilder<List<Album>>(
                              future: Home.fetch,
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
                          //check();
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

  Future check() async {

    print("hello");

    Album gList;
    List<Album> nList = [];
    var currIndex;
    var count;

    var bData = await fetchAlbum(http.Client()).then((value) {

      for (var element in value) {
        if (element.intake == "UC2F2008CS" && element.date == "15-MAR-21") {

          currIndex = value.indexOf(element);
          print(element.dateIso);
          gList = element;
          nList.add(value[currIndex]);

          if (nList.length == 0) {
            count = 0;
          }
          if(nList.length > 0 ) {
            count = nList.length - 1;
          }

          print("mod" + nList[count].moduleId);
          print(count);
          print("length = " + nList.length.toString());

          //get simplified module code
          if (element.moduleId.split(" ")[0].split("-").length == 6) {
            gList.shortModule = element.shortModule.replaceAll(
                "-",
                element.moduleId.split(" ")[0].split("-")[0] + "-" +
                    element.moduleId.split(" ")[0].split("-")[1] + "-" +
                    element.moduleId.split(" ")[0].split("-")[2] + "-" +
                    element.moduleId.split(" ")[0].split("-")[3]);

            nList[count].shortModule =
                element.moduleId.split(" ")[0].split("-")[0] + "-" +
                element.moduleId.split(" ")[0].split("-")[1] + "-" +
                element.moduleId.split(" ")[0].split("-")[2] + "-" +
                element.moduleId.split(" ")[0].split("-")[3];

          }
          else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
            gList.shortModule = element.shortModule.replaceAll(
                "-",
                element.moduleId.split(" ")[0].split("-")[0] + "-" +
                element.moduleId.split(" ")[0].split("-")[1]);

            nList[count].shortModule =
                element.moduleId.split(" ")[0].split("-")[0] + "-" +
                element.moduleId.split(" ")[0].split("-")[1];
          }

          print(nList[count].shortModule);

          //get class type
          if (element.moduleId.split(" ")[0].split("-").length == 6) {

            if (element.moduleId.split("-")[4] == 'T' || element.moduleId.split("-")[4] == 'LAB') {
              gList.classType = element.classType.replaceAll("-", "T");
              nList[count].classType = "T";
            }
            else {
              gList.classType = element.classType.replaceAll("-", "L");
              nList[count].classType = "L";
            }

          }

          else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
            gList.classType = element.classType.replaceAll("-", "L");
            nList[count].classType = "L";
          }

          bool found = false;
          //get module name
          for (var e in courseList) {

            if (nList[count].shortModule == e.subjectCode) {
              found = true;
              gList.moduleName = element.moduleName.replaceAll("-", e.module);
              nList[count].moduleName = e.module;
              break;

            }
          }

          if (found == false) {

            if (element.moduleId.split(" ")[0].split("-").length == 6) {
              gList.moduleName = element.moduleName.replaceAll("-", element.shortModule.split("-").last);
              nList[count].moduleName = element.shortModule.split("-").last;
            }

            else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
              gList.moduleName = element.moduleName.replaceAll("-", element.shortModule.split("-")[1]);
              nList[count].moduleName = element.shortModule.split("-")[1];
            }
          }

          print("3 = " + nList[count].moduleName);

        }

        // map.add({'code': gList.shortModule, 'name': gList.moduleName, 'time': gList.startTime, 'type': gList.classType, 'location': gList.location});

      }
    });

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

String getCurrDate() {

  var theDate;

  if (currPage == 0) {
    theDate = checkDate();
  }
  else if (currPage == 1) {
    theDate = checkDate().add(Duration(days: 1));
  }
  else if (currPage == 2) {
    theDate = checkDate().add(Duration(days: 2));
  }
  else if (currPage == 3) {
    theDate = checkDate().add(Duration(days: 3));
  }
  else if (currPage == 4) {
    theDate = checkDate().add(Duration(days: 4));
  }
  return DateFormat('dd-MMM-yy').format(theDate).toUpperCase();
}

DateTime checkDate() {

  if (DateTime.now().weekday == 6) {

    date = DateTime.now().add(Duration(days: 2));

  }
  else if (DateTime.now().weekday == 7) {
    //add days by 1
    date = DateTime.now().add(Duration(days: 1));
  }
  else {

    date = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 1));
  }

  print(
      DateFormat('dd-MMM-yy')
          .format(DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday))
          .add(Duration(days: 1))).toUpperCase()
  );

  return date;

}

//TODO: Navbar (partially done), timetable (partially done), attendance, apcard.