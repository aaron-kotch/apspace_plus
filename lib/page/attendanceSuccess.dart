import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

class AttendanceSuccess extends StatefulWidget {

  final String classType;
  final String moduleCode;
  final String startTime;
  final String endTime;
  final String date;

  AttendanceSuccess({Key key, this.classType, this.moduleCode, this.startTime, this.endTime, this.date}): super(key: key);

  @override
  _AttendanceSuccessState createState() => _AttendanceSuccessState();
}

class _AttendanceSuccessState extends State<AttendanceSuccess> {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.lightGreen[100],
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 90, left: 48),
        height: 100.0.h,
        width: 100.0.w,
        color: Colors.lightGreen[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.0.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      radius: 30,
                      backgroundImage: AssetImage('lib/images/check.png'),
                    ),
                  ),
                  Text(
                    "Attendance\nUpdated",
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                      color: Colors.grey[800],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                "Module code: ${widget.moduleCode}",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Class time: ${widget.startTime} ${widget.endTime}",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Date: ${widget.date}",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Class type: ${widget.classType}",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              child: Container(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal[800],
                  ),
                  child: Text(
                    "Back to home",
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
