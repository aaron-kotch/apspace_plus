import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/Album.dart';
import 'package:apspace_plus/process/Course.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class TTList extends StatefulWidget {
  static var getDate = DateFormat('dd-MMM-yy').format(DateTime.now()).toUpperCase();
  int page;

 TTList({Key key, this.page}) : super(key: key);

  @override
  _TTListState createState() => _TTListState();
}

class _TTListState extends State<TTList> with AutomaticKeepAliveClientMixin {
  Future pData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitcher(
        duration: Duration(seconds: 1),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:  timetableList[widget.page].length,
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
                                  text: timetableList[widget.page][index].startTime.toString().split(" ")[0],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: timetableList[widget.page][index].startTime.toString().split(" ")[1],
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
                                    timetableList[widget.page][index].moduleName,
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
                                          timetableList[widget.page][index].shortModule,
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
                                  color: timetableList[widget.page][index].classType.toString().contains("T")
                                      ? Colors.pink[500]
                                      : Colors.deepPurple[400],
                                  shape: CircleBorder(),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    child: Text(
                                      timetableList[widget.page][index].classType,
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
              }),
        ));
  }
}

Future<List<List<Album>>> processTTData() async {

  var currIndex;
  var count;

  await fetchAlbum(http.Client()).then((value) {

    for (int i = 0; i < 5; i ++) {

      List<Album> nList = [];


      value.forEach((element) {

        if (DateTime.now().weekday == 6 || DateTime.now().weekday == 7) {

          if (DateFormat('dd-MMM-yy').parse(
              element.date[0] + element.date[1] + element.date[2] + element.date[3] + element.date[4].toLowerCase() + element.date[5].toLowerCase() + element.date[6] + element.date[7] + element.date[8])
              .add(Duration(days: 2)) != null) {

            if (element.intake == "UC2F2008CS" && element.date == dateList[i]) {

              //TODO: check saturday sunday

              currIndex = value.indexOf(element);
              nList.add(value[currIndex]);

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

          }

        }

        else {

          if (element.intake == "UC2F2008CS" && element.date == oldDateList[i]) {

            //TODO: check saturday sunday

            currIndex = value.indexOf(element);
            nList.add(value[currIndex]);

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

            courseList.forEach((e) {
              if (nList[count].shortModule == e.subjectCode) {
                found = true;
                nList[count].moduleName = e.module;

              }

            });
            //get module name
            if (found == false) {

              if (element.moduleId.split(" ")[0].split("-").length == 6) {
                nList[count].moduleName = element.moduleId.split(" ").toString().split("-")[3];
              }

              else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
                nList[count].moduleName = element.shortModule.split("-")[1];
              }
            }
          }

        }

      });

      timetableList.add(nList);
    }

  });

  return timetableList;

}