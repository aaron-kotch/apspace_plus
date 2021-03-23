import 'package:apspace_plus/page/ttlist.dart';
import 'package:apspace_plus/process/Album.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:apspace_plus/page/home.dart';

double indicatorHeight = 20.0;

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> with SingleTickerProviderStateMixin {

  TabController tabController;

  var selDate = DateFormat('dd-MMM-yy').format(DateTime.now()).toUpperCase();
  final fetch = Home.fetch;

  @override
  void initState() {

    tabController = TabController(
        initialIndex: DateTime.now().weekday == 6 || DateTime.now().weekday == 7
        ? 0
        : DateTime.now().weekday - 1,
        length: 5,
        vsync: this);

    tabController.addListener(() {
      currPage = tabController.index;
      print("tab = " + currPage.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                padding: EdgeInsets.only(top: 4.0.h, left: 8.0.w, right: 4.0.w),
                child: Text(
                  DateFormat('EEEE, dd MMMM').format(DateTime.now()),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0.sp,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0.5.w, left: 8.0.w, right: 4.0.w),
                child: Text(
                  "Timetable",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0.sp,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 1.5.h, left: 5.0.w, right: 4.0.w),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey[900],
                        tabs: [
                          Tab(
                              child: Text(
                                "Mon",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0.sp,
                                  letterSpacing: 0.25,
                                ),
                              )),
                          Container(
                              child: Tab(text: "Tue",))
                          ,
                          Tab(text: "Wed",),
                          Tab(text: "Thu",),
                          Tab(text: "Fri",)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.topCenter,
                  height: 400,
                  child: FutureBuilder<List<List<Album>>>(
                    future: Home.ttGet,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? TabBarView(
                          controller: tabController,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 8.0.w, left: 8.0.w, right: 8.0.w),
                              alignment: Alignment.topCenter,
                              child: TTList(page: 0),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8.0.w, left: 8.0.w, right: 8.0.w),
                              alignment: Alignment.topCenter,
                              child: TTList(page: 1),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8.0.w, left: 8.0.w, right: 8.0.w),
                              alignment: Alignment.topCenter,
                              child: TTList(page: 2),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8.0.w, left: 8.0.w, right: 8.0.w),
                              alignment: Alignment.topCenter,
                              child: TTList(page: 3),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8.0.w, left: 8.0.w, right: 8.0.w),
                              alignment: Alignment.topCenter,
                              child: TTList(page: 4),
                            ),
                          ]
                        )
                          : Padding(
                              padding: EdgeInsets.only(top: 24, bottom: 24),
                              child: Center(child: CircularProgressIndicator()));
                    },
                  )
              ),
            ],
          ),
        ),
    );
  }
}

//TODO: fix next week timetable
