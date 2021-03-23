import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/page/main.dart';
import 'package:apspace_plus/process/Album.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AlbumsList extends StatefulWidget {
  List<Album> albums;

  AlbumsList({Key key, this.albums}) : super(key: key);

  @override
  _AlbumsListState createState() => _AlbumsListState();
}

class _AlbumsListState extends State<AlbumsList> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.albums.length == 0) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange[100],
                radius: 20,
                backgroundImage: AssetImage('lib/images/check.png'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You're all caught up",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "No upcoming events this week",
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[700],
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.albums.length,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(bottom: 2.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Container(
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.albums[index].startTime.split(" ")[0],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.albums[index].startTime.split(" ")[1],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30.0.w,
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    widget.albums[index].moduleName,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.0.sp,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          widget.albums[index].shortModule,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 8.0.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 14.0.w),
                              child: Material(
                                  color: widget.albums[index].classType.contains("T")
                                      ? Colors.pink[500]
                                      : Colors.deepPurple[400],
                                  shape: CircleBorder(),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    child: Text(
                                      widget.albums[index].classType,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        color: Colors.white,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                );
                //TODO: fetch data using obtained ticket in apspace
              }),
        ));
  }
}
