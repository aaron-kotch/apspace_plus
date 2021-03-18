import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/Album.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:flutter/material.dart';
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
  Future pData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pData = processData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Album>>(
      future: pData,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
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
                                          text: snapshot.data[index].startTime.split(" ")[0],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.0.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: snapshot.data[index].startTime.split(" ")[1],
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
                                            snapshot.data[index].moduleName,
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
                                                  snapshot.data[index].shortModule,
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
                                          color: snapshot.data[index].classType.contains("T")
                                              ? Colors.pink[500]
                                              : Colors.deepPurple[400],
                                          shape: CircleBorder(),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            child: Text(
                                              snapshot.data[index].classType,
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
            ))
            : Padding(
                padding: EdgeInsets.only(top: 24, bottom: 24),
                child: Center(child: CircularProgressIndicator()));
      }
    );
  }
}

Future<List<Album>> processData() async{

  print("hello");

  List<Album> nList = [];
  var currIndex;
  var count;

  bool found = false;

  var bData = await fetchAlbum(http.Client()).then((value) {

    for (var element in value) {
      if (element.intake == "UC2F2008CS" && element.date == "18-MAR-21") {

        currIndex = value.indexOf(element);
        print(element.dateIso);
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

        print(nList[count].shortModule);

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

        //get module name
        for (var e in courseList) {

          if (nList[count].shortModule == e.subjectCode) {
            found = true;
            nList[count].moduleName = e.module;
            break;

          }
        }

        if (found = false) {

          if (element.moduleId.split(" ")[0].split("-").length == 6) {
            nList[count].moduleName = element.shortModule.split("-").last;
          }

          else if (element.moduleId.split(" ")[0].split("-").length == 4 || element.moduleId.split(" ")[0].split("-").length == 3) {
            nList[count].moduleName = element.shortModule.split("-")[1];
          }
        }

        print("3 = " + nList[count].moduleName);

      }
    }
    return nList;
  });

  return bData;

}