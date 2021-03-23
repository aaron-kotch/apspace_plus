import 'package:apspace_plus/page/main.dart';
import 'package:apspace_plus/page/ttlist.dart';
import 'package:apspace_plus/process/Album.dart';
import 'AlbumsList.dart';
import 'package:apspace_plus/process/Course.dart';
import 'package:apspace_plus/process/Intake.dart';
import 'package:apspace_plus/process/getCourse.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:apspace_plus/process/getIntake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


List<Course> courseList;
List<Intake> intakeDetailsList;
List<String> intakeList = [];
int intakeLengthList;
List<String> dateList = [];
List<String> oldDateList = [];
List<List<Album>> timetableList = [];
List<int> semList = [];

int currPage = 0;
String cDate;
double totalPercent;

var tick;

class Home extends StatefulWidget {
  List<Album> infoData;

  static Future fetch;
  static Future ttGet;

  Home({Key key, this.infoData}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  int _selectedIndex = 2;

  @override
  void initState() {
    Home.fetch = fetchAlbum(http.Client());
    cDate = checkDateSchedule();
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
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                      Future f = futCourse;

                      f.then((value) => print(value));
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
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.15,
                    color: Colors.grey[800]
                ),
              ),
            ),
            Container(
              width: 100.0.w,
              padding: EdgeInsets.only(left: 6.5.w, right: 6.5.w, bottom: 4.0.h),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.35),
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
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                      AlbumsList(albums: widget.infoData,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ), //pfp
      ),
    );
  }
}

Future<List<Album>> login() async {

  List<Album> nList = [];

  var tick1;
  var tick2;

  var link = Uri.https('cas.apiit.edu.my', '/cas/v1/tickets');

  var queryParamCourse = {
    'service': 'https://api.apiit.edu.my/student/attendance',
  };

  var queryParamIntake = {
    'service': 'https://api.apiit.edu.my/student/courses',
  };

  //login to apspace using http POST
  List<Album> loginReq = await http.post(
      link,
      headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
      body: {'username': 'tp051733', 'password': 'kokotch12'}).then((http.Response response) {

    print(response.headers['location'].split('/').reversed.first);
    tick = response.headers['location'].split('/').reversed.first;

  }).then((http.Response att) async { //retrieve ticket

    var attTicket = Uri.https('cas.apiit.edu.my', '/cas/v1/tickets/' + tick, queryParamCourse);
    var intakeTicket = Uri.https('cas.apiit.edu.my', '/cas/v1/tickets/' + tick, queryParamIntake);

    var yep = await http.post( //retrieve inner ticket
      attTicket,
      headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
    );

    var yepIntake = await http.post( //retrieve inner ticket
      intakeTicket,
      headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
    );

    List<String> yepList = [yep.body, yepIntake.body];

    print("coursetable = " + yepList[0]);
    print("intake = " + yepList[1]);

    return yepList;

  }).then((value) {

    futCourse = fetchCourse(http.Client(), value[0]).then((courseRes) {

      courseList = courseRes;
      totalPercent = getPercentage();
      print("ho");

      return courseList;

    }).then((value) {

      int currSem = 0;
      semList.clear();

      value.forEach((element) {

        if (currSem == element.semester) {
          print("identical");
        }
        else {
          semList.add(element.semester);
          print(element.semester);
        }

        currSem = element.semester;

      });

      return value;
    });

    fetchIntake(http.Client(), value[1]).then((intakeRes) {

      intakeDetailsList = intakeRes;
      print("yo");
      intakeList.clear();

      return intakeDetailsList;

    }).then((value) {

      value.forEach((element) {
        intakeList.add(element.intakeCode);
        print(intakeList.toString());
      });

    });

    getCurrDate();

    return futCourse;

  }).then((course) async {

    print("courselist = " + course.toString());
    print(intakeList.toString());

    print(course[0].module);

    var yes = fetchAlbum(http.Client()).then((album) {

      print(album[0].intake);

      return album;

    });

    return yes;

  }).then((theList) {

    var currIndex;
    var count;

    theList.forEach((element) {

      if (element.intake == intakeList.first && element.date == DateFormat('dd-MMM-yy').format(DateTime.now()).toUpperCase()) {

        print("hi");

        //TODO: check saturday sunday

        currIndex = theList.indexOf(element);
        nList.add(theList[currIndex]);

        if (nList.length == 0) {
          count = 0;
        }
        if(nList.length > 0 ) {
          count = nList.length - 1;
        }
        //get simplified module code
        if (element.moduleId.split(" ")[0].split("-").length == 6) {

          nList[count].shortModule =
              element.moduleId.split(" ")[0].split("-")[0] + "-" +
                  element.moduleId.split(" ")[0].split("-")[1] + "-" +
                  element.moduleId.split(" ")[0].split("-")[2] + "-" +
                  element.moduleId.split(" ")[0].split("-")[3];

        }
        else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {

          nList[count].shortModule =
              element.moduleId.split(" ")[0].split("-")[0] + "-" +
                  element.moduleId.split(" ")[0].split("-")[1];
        }


        //get class type
        if (element.moduleId.split(" ")[0].split("-").length == 6) {

          if (element.moduleId.split("-")[4] == 'T' || element.moduleId.split("-")[4] == 'LAB') {
            nList[count].classType = "T";
          }
          else {
            nList[count].classType = "L";
          }

        }

        else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
          nList[count].classType = "L";
        }

        bool found = false;

        //get module name
        courseList.forEach((e) {
          if (nList[count].shortModule == e.subjectCode) {
            found = true;
            nList[count].moduleName = e.module;

          }

        });

        if (found == false) {

          if (element.moduleId.split(" ")[0].split("-").length == 6) {
            nList[count].moduleName = element.moduleId.split(" ").toString().split("-")[3];
          }

          else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
            nList[count].moduleName = element.shortModule.split("-")[1];
          }
        }

      }

    });

    return nList;

  });

  return loginReq;

}

getCurrDate() async {

  DateTime theDate;
  DateTime oldDate;

  dateList.clear();
  oldDateList.clear();

  if (DateTime.now().weekday == 6) {

    theDate = DateTime.now().add(Duration(days: 2));
    oldDate = DateTime.now().subtract(Duration(days: 5));

  }
  else if (DateTime.now().weekday == 7) {
    //add days by 1
    theDate = DateTime.now().add(Duration(days: 1));
    oldDate = DateTime.now().subtract(Duration(days: 6));

  }
  else {

    theDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 1));
    oldDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 1));

  }

  for (int i = 0; i < 5; i++) {

    dateList.add(DateFormat('dd-MMM-yy').format(theDate.add(Duration(days: i))).toUpperCase());
    oldDateList.add(DateFormat('dd-MMM-yy').format(oldDate.add(Duration(days: i))).toUpperCase());
  }

  print("new date = " + dateList.toString());
  print("old date = " + oldDateList.toString());

  int count = 0;

  if (futCourse != null) {
    await futCourse;
  }

  if (dateList.length == 5 ) {
    Home.ttGet = processTTData();
    count++;
  }
}

DateTime checkDate() {
  var date;

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

String checkDateSchedule() {
  var date;

  if (DateTime.now().weekday == 6) {

    date = DateFormat('dd-MMM-yy').format(DateTime.now().subtract(Duration(days: 5))).toUpperCase();

  }
  else if (DateTime.now().weekday == 7) {
    //add days by 1
    date = DateFormat('dd-MMM-yy').format(DateTime.now().subtract(Duration(days: 6))).toUpperCase();

  }
  else {

    date = DateFormat('dd-MMM-yy').format(DateTime.now()).toUpperCase();
  }

  print(
      DateFormat('dd-MMM-yy')
          .format(DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday))
          .add(Duration(days: 1))).toUpperCase()
  );

  return date;

}

double getPercentage() {

  double sumClass = 0;
  double sumAbsent = 0;
  double average;

  courseList.forEach((element) {
    sumClass = sumClass + element.totalClass;
    sumAbsent = sumAbsent + element.totalAbsent;
  });

  print("absent" + sumAbsent.toString());
  print("total" + sumClass.toString());

  average = ((sumClass - sumAbsent) / sumClass) * 100;

  return average;
}

//TODO: attendance, apcard.