import 'package:apspace_plus/page/home.dart';
import 'package:apspace_plus/process/Album.dart';
import 'package:apspace_plus/process/getData.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

List<Album> list = [];
List modCode = [];
List modName = [];
List modType = [];
List modTime = [];
List modId = [];

// ignore: must_be_immutable
class AlbumsList extends StatefulWidget {
  List<Album> albums;

  AlbumsList({Key key, this.albums}) : super(key: key);

  @override
  _AlbumsListState createState() => _AlbumsListState();
}

class _AlbumsListState extends State<AlbumsList> {
  Future pData;

  @override
  void initState() {
    pData = processData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Map<String, List>>(
      future: pData,
      builder: (context, snapshot) {

        print("sdata = " + snapshot.data.toString());

        return snapshot.hasData
            ? AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:  snapshot.data['time'].length,
                      itemBuilder: (context, index){

                        return Container(
                          padding: EdgeInsets.only(bottom: 3.0.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: snapshot.data['time'][index].toString().split(" ")[0],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.w200,
                                            fontSize: 20,
                                          ),
                                        ),
                                        TextSpan(
                                          text: snapshot.data['time'][index].toString().split(" ")[1],
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
                                      snapshot.data['name'][index],
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
                                            snapshot.data['code'][index],
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Material(
                                            color: snapshot.data['type'][index].toString().contains("LAB")
                                                ? Colors.pink[500]
                                                : Colors.deepPurple[400],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                              child: Text(
                                                snapshot.data['type'][index],
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
                      }),
            ))
            : Padding(
                padding: EdgeInsets.only(top: 24, bottom: 24),
                child: Center(child: CircularProgressIndicator()));
      }
    );
  }
}

Future<Map<String, List>> processData() async{

  list.clear();
  modCode.clear();
  modName.clear();
  modTime.clear();
  var mMap;

  var bData = await fetchAlbum(http.Client()).then((value) {
    print("val = " + value[0].intake);

    for (int i = 0; i < value.length; i++) {

      if (value[i].intake == "UC2F2008CS" && value[i].date == "16-MAR-21") {
        list.add(value[i]);
      }

    }

    for (int i = 0; i < list.length; i++) {

      modCode.add(
          list[i].moduleId.split(" ")[0].split("-")[0] + "-" +
          list[i].moduleId.split(" ")[0].split("-")[1] + "-" +
          list[i].moduleId.split(" ")[0].split("-")[2] + "-" +
          list[i].moduleId.split(" ")[0].split("-")[3]

      );

      print(modCode);
      print(list.length);

      modTime.add(list[i].startTime);

      print(modTime);

      if (list[i].moduleId.split("-")[4] == 'T' || list[i].moduleId.split("-")[4] == 'LAB') {
        modType.add("LAB");
      }

      else {
        modType.add("LECTURE");
      }

      print(modType);
    }

    for (int i = 0; i < modCode.length; i++) {
      for (int j = 0; j < courseList.length; j++) {
        if (modCode[i] == courseList[j].subjectCode) {
          modName.add(courseList[j].module);
          break;
        }
        if (j == courseList.length - 1 && modCode[i] != courseList[j].subjectCode) {
          modName.add(modCode[i].toString().split("-").last);
        }
      }
    }

    Map<String, List> map = {
      'code': modCode,
      'name': modName,
      'type': modType,
      'list': list,
      'time': modTime,
    };

    return map;

  }).then((value) {

    print("ok = " + value['name'][0]);
    mMap = value;

  });

  return mMap;

}