import 'dart:convert';

import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/Album.dart';
import 'package:apspace_plus/process/Polished.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';

List<Album> list = [];
List modCode = [];
List modName = [];
List modType = [];

// ignore: must_be_immutable
class AlbumsList extends StatelessWidget {
  List<Album> albums;
  int count;

  AlbumsList({Key key, this.albums}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    list.clear();

    for (int i = 0; i < albums.length; i++) {

      if (albums[i].intake == "UC2F2008CS" && albums[i].date == "15-MAR-21") {
        list.add(albums[i]);
      }
      count = i + 1;
    }

    if(count == albums.length) {
      print("nice");
      processData();
    }

    print('albums = ' + albums.length.toString());
    print('count = ' + count.toString());

    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index){

              return Container(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Container(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: list[index].startTime.split(" ")[0],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                text: list[index].startTime.split(" ")[1],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.0.w,
                          padding: EdgeInsets.only(left: 24, right: 24, bottom: 4),
                          child: Text(
                            modName[index],
                            //TODO: future builder to place modName
                            maxLines: 3,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          width: 60.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  modCode[index],
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Material(
                                  color: modType[index].toString().contains("LAB")
                                            ? Colors.pink[500]
                                            : Colors.deepPurple[400],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    child: Text(
                                      modType[index],
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        color: Colors.white,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              );
              //TODO: fetch data using obtained ticket in apspace
            }));
  }

}

processData() {
  modCode.clear();
  modName.clear();

  for (int i = 0; i < list.length; i++) {
    modCode.add(
        list[i].moduleId.split(" ")[0].split("-")[0] + "-" +
        list[i].moduleId.split(" ")[0].split("-")[1] + "-" +
        list[i].moduleId.split(" ")[0].split("-")[2] + "-" +
        list[i].moduleId.split(" ")[0].split("-")[3]
    );
    if (list[i].moduleId.split("-")[4] == 'T' || list[i].moduleId.split("-")[4] == 'LAB') {
      modType.add("LAB");
    }

    else if (list[i].moduleId.split("-")[4] == 'L') {
      modType.add("LECTURE");
    }
  }

  for (int i = 0; i < modCode.length; i++) {
    for (int j = 0; j < courseList.length; j++) {
      if (modCode[i] == courseList[j].subjectCode) {
        modName.add(courseList[j].module);
        break;
      }
      else if (j == courseList.length - 1 && modCode[i] != courseList[j].subjectCode) {
        modName.add(modCode[i].toString().split("-").last);
      }
    }
  }

  print(list[0].moduleId.split("-")[4]);

}