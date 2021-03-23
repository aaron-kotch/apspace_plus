import 'dart:convert';

import 'package:apspace_plus/page/NewAttendance.dart';
import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/Course.dart';
import 'package:apspace_plus/process/UpdateAttendance.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String dropText = "UC2F2008CS";

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:  Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(left: 8.0.w, top: 8.0.w, right: 6.5.w),
                  child: Material(
                    color: Colors.grey[200],
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: PopupMenuButton(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onSelected: (index) {
                          setState(() {
                            if (dropText != null) {
                              dropText = index;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
                          child: Text(
                            dropText != null
                            ? dropText
                            : "null",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        itemBuilder: (context) {
                          return intakeList.map((e) => PopupMenuItem(
                              value: e,
                              textStyle: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: Colors.grey[800],
                              ),
                              child: Container(
                                child: Text('$e'),
                              ))).toList();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0.w, top: 4.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Attendance",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.start,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            courseList != null
                                ? totalPercent.toStringAsFixed(1)
                                : "null",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 24.0.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                              letterSpacing: 0.25,
                            ),
                          ),
                          Text(
                            courseList != null
                                ? "%"
                                : " ",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                              letterSpacing: 0.25,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0.w, top: 1.0.h, bottom: 4.0.h),
                  alignment: Alignment.topCenter,
                  width: 40.0.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 0.8.h,
                      backgroundColor: Colors.grey[300],
                      valueColor: new AlwaysStoppedAnimation<Color>(HexColor("AED581")),
                      value: courseList != null
                        ? (totalPercent / 100)
                        : 0
                    ),
                  ),
                ),
                Container(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 6.5.w, top: 8, right: 6.5.w, bottom: 8),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(90.0.w, 7.0.h),
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
                        onPressed: () async {
                          print(tick);
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Navigator.of(context).push(toSignAttendance());
                          });
                        },
                      ),
                    )
                ),
                Container(
                  width: 100.0.w,
                  padding: EdgeInsets.only(top: 2.0.h),
                  child: FutureBuilder<List<Course>>(
                    future: futCourse,
                    builder: (context, snapshot) {
                      return snapshot.data != null && semList != null
                          ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: semList.length,
                          itemBuilder: (context, semIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 8.0.w, bottom: 0.0.h),
                                  child: Text(
                                    semList != null
                                        ? "Semester " + semList[semIndex].toString()
                                        : "null",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5.0.w, top: 1.0.h, right: 5.0.w, bottom: 3.0.h),
                                  width: 100.0.w,
                                  child: Card(
                                      color: HexColor("#2D364E"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8, left: 24, bottom: 24),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return snapshot.data != null && snapshot.data[index].semester == semList[semIndex]
                                                  ? Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 6.0.w,
                                                      child: Material(
                                                        shape: CircleBorder(
                                                          side: BorderSide(width: 1, color: Colors.grey[600]),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(1.2.w),
                                                          child: Center(
                                                            child: Text(
                                                              '$index',
                                                              style: TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontSize: 8,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 74.0.w,
                                                      padding: EdgeInsets.only(left: 24, right: 24),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 40.0.w,
                                                            child: Text(
                                                              snapshot.data[index].module,
                                                              style: TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.white,
                                                              ),
                                                              maxLines: 3,
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  (snapshot.data[index].totalClass - snapshot.data[index].totalAbsent).toString() + " out of " + courseList[index].totalClass.toString(),
                                                                  style: TextStyle(
                                                                    fontFamily: 'Montserrat',
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Colors.white,
                                                                  ),
                                                                  maxLines: 2,
                                                                ),
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  width: 12.0.w,
                                                                  height: 20,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: LinearProgressIndicator(
                                                                      backgroundColor: Colors.white,
                                                                      valueColor: new AlwaysStoppedAnimation<Color>(HexColor("AED581")),
                                                                      value: (snapshot.data[index].totalClass - snapshot.data[index].totalAbsent) / snapshot.data[index].totalClass,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ((snapshot.data[index].totalClass - snapshot.data[index].totalAbsent) / snapshot.data[index].totalClass * 100).toInt().toString() + "%",
                                                                  style: TextStyle(
                                                                    fontFamily: 'Montserrat',
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Colors.white,
                                                                  ),
                                                                  maxLines: 2,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],

                                                ),
                                              )
                                                  : Container();
                                            }),
                                      )
                                  ),
                                )
                              ],
                            );
                          })
                          : Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                //TODO: attendance for other intakes
              ],
            ),
          ),
        )
    );
  }
}

Route toSignAttendance() {

  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewAttendance(),
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position:animation.drive(tween),
          child: child,
        );
      }
  );
}