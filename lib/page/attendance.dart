import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/Course.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 8.0.w, top: 5.0.h),
                child: Text(
                  "overall attendance",
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8.0.w, top: 0, bottom: 5.0.h),
                child: Text(
                  courseList != null
                      ? totalPercent.toStringAsFixed(1) + "%"
                      : "null",
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 23.0.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8.0.w, top: 0, right: 8.0.w),
                child: Material(
                  color: Colors.grey[200],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: PopupMenuButton(
                      elevation: 4,
                      offset: Offset(16, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (index) {
                        setState(() {
                          dropText = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                dropText,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded)
                          ],
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
                padding: EdgeInsets.only(left: 6.0.w, top: 3.0.h, right: 6.0.w, bottom: 4.0.h),
                width: 100.0.w,
                child: Card(
                  color: HexColor("#2D364E"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 24, bottom: 24),
                      child: FutureBuilder<List<Course>>(
                          future: Home.futCourse,
                          builder: (context, snapshot) {
                            return snapshot.data != null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                    return snapshot.data != null
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
                                                            fontWeight: FontWeight.w300,
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
                                })
                                : Center(
                                    child: CircularProgressIndicator(),
                            );
                          }
                      ),
                    )
                ),
              )


              //TODO: complete attendance, dropdown index
            ],
          ),
        )
    );
  }
}
