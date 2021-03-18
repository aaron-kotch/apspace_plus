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
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      currPage = tabController.index;
      print("tab = " + currPage.toString());
      TTList.getDate = getCurrDate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
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
                        color: Theme.of(context).canvasColor,
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
                  padding: EdgeInsets.only(top: 0.5.w, left: 8.0.w, right: 8.0.w),
                  height: 400,
                  child: TabBarView(
                    controller: tabController,
                      children: [
                        Container(
                          child: FutureBuilder<List<Album>>(
                              future: Home.fetch,
                              builder: (context, snapshot){
                                return snapshot.hasData
                                    ? TTList()
                                    : Padding(
                                        padding: EdgeInsets.only(top: 24, bottom: 24),
                                        child: Center(child: CircularProgressIndicator()));

                              }),
                        ),
                        Container(
                          child: FutureBuilder<List<Album>>(
                              future: Home.fetch,
                              builder: (context, snapshot){
                                return snapshot.hasData
                                    ? TTList()
                                    : Padding(
                                    padding: EdgeInsets.only(top: 24, bottom: 24),
                                    child: Center(child: CircularProgressIndicator()));

                              }),
                        ),
                        Container(
                          child: FutureBuilder<List<Album>>(
                              future: Home.fetch,
                              builder: (context, snapshot){
                                return snapshot.hasData
                                    ? TTList()
                                    : Padding(
                                    padding: EdgeInsets.only(top: 24, bottom: 24),
                                    child: Center(child: CircularProgressIndicator()));

                              }),
                        ),
                        Container(
                          child: FutureBuilder<List<Album>>(
                              future: Home.fetch,
                              builder: (context, snapshot){
                                return snapshot.hasData
                                    ? TTList()
                                    : Padding(
                                    padding: EdgeInsets.only(top: 24, bottom: 24),
                                    child: Center(child: CircularProgressIndicator()));

                              }),
                        ),
                        Container(
                          child: FutureBuilder<List<Album>>(
                              future: Home.fetch,
                              builder: (context, snapshot){
                                return snapshot.hasData
                                    ? TTList()
                                    : Padding(
                                    padding: EdgeInsets.only(top: 24, bottom: 24),
                                    child: Center(child: CircularProgressIndicator()));

                              }),
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class CustomTabIndicator extends Decoration {

  @override
  _CustomPainter createBoxPainter([onChanged]) {
    return new _CustomPainter(this, onChanged);
  }

}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {

    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = Offset(offset.dx, (configuration.size.height / 2) - indicatorHeight / 2) & Size(configuration.size.width, indicatorHeight);
    final Paint paint = Paint();
    paint.color = Colors.blueAccent;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10.0)), paint);
  }

}
