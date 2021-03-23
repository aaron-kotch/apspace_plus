import 'dart:convert';

import 'package:apspace_plus/page/attendanceSuccess.dart';
import 'package:apspace_plus/process/UpdateAttendance.dart';
import 'package:apspace_plus/process/signAttendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'attendance.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class NewAttendance extends StatefulWidget {
  @override
  _NewAttendanceState createState() => _NewAttendanceState();
}

class _NewAttendanceState extends State<NewAttendance> {

  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();

  final node1 = new FocusNode();
  final node2 = new FocusNode();
  final node3 = new FocusNode();

  @override
  void dispose() {
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    signAtt(String otp1, String otp2, String otp3) async {

      String otp = otp1 + otp2 + otp3;

      print(otp);

      String hey() {

        //graphql query
        return """
          mutation updateAttendance(\$otp: String!) {  
            updateAttendance(otp: \$otp) {
              id
              attendance
              classcode
              date
              startTime
              endTime
              classType
              __typename
           }
         }
        """;
      }

      var queryParamAttendance = {
        'service': 'https://api.apiit.edu.my/attendix',
      };

      var signTick = Uri.https('cas.apiit.edu.my', '/cas/v1/tickets/' + tick, queryParamAttendance);
      var attendixUri = Uri.https('attendix.apu.edu.my', '/graphql');

      var yes = await http.post( //retrieve inner ticket
        signTick,
        headers: <String, String>{'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'},
      );

      print(yes.body);


      await http.post(
          attendixUri,
          headers: <String, String>{'content-type': 'application/json; charset=UTF-8', 'ticket': yes.body, 'x-amz-user-agent': 'aws-amplify/1.0.1', 'x-api-key': 'da2-dv5bqitepbd2pmbmwt7keykfg4'},
          body: jsonEncode({"operationName": "updateAttendance",  "query": hey(), "variables": {"otp": otp}})
      ).then((http.Response resp) {

        print(resp.body);

        if (jsonDecode(resp.body)['data'] == null) {
          print(jsonDecode(resp.body)['errors'][0]['message']);
        }
        else if (jsonDecode(resp.body)['data'] != null) {

          String id = jsonDecode(resp.body)['data']['message']['id'];
          String classCode = jsonDecode(resp.body)['data']['message']['classcode'];
          String startTime = jsonDecode(resp.body)['data']['message']['startTime'];
          String endTime = jsonDecode(resp.body)['data']['message']['endTime'];
          String date = jsonDecode(resp.body)['data']['message']['date'];
          String classType = jsonDecode(resp.body)['data']['message']['classType'];

          print("Attendance updated");
          print("Id: " + id);
          print("Class code: " + classCode);
          print("Class type: " + classType);
          print("Start time: " + startTime);
          print("End time: " + endTime);
          print("EDate: " + date);

          Navigator.of(context).push(updateSuccess(classType, classCode, startTime, endTime, date));
        }
      });
    }

    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.only(top: 24, left: 6.5.w, right: 6.5.w),
            width: 100.0.w,
            height: 100.0.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.grey[900],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center,
                        height: 80,
                        width: 60,
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.6),
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: otp1,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor: Colors.grey[200],
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                            ),
                            focusNode: node1,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => FocusScope.of(context).requestFocus(node2),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center,
                        height: 80,
                        width: 60,
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.6),
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: otp2,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor: Colors.grey[200],
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                            ),
                            focusNode: node2,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => FocusScope.of(context).requestFocus(node3),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center,
                        height: 80,
                        width: 60,
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.6),
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: otp3,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor: Colors.grey[200],
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                            ),
                            focusNode: node3,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) {
                              FocusScope.of(context).unfocus();

                              signAtt(otp1.text, otp2.text, otp3.text);
                              otp1.clear();
                              otp2.clear();
                              otp3.clear();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 120),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          onSurface: Colors.yellow[400],
                          backgroundColor: Colors.blueAccent[400],
                          shape: CircleBorder(),
                          minimumSize: Size(80, 80),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.5),
                        ),
                        child: ImageIcon(
                          AssetImage('lib/images/qrcode.png'),
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print("hie");
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'SCAN QR CODE',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent[200],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.0.h),
                  height: 20.0.h,
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('lib/images/scanqr50.png'),
                  ),
                )
              ],
            ),
          ),
        )
    );

  }

  Route updateSuccess(String type, String code, String start, String end, String classDate) {

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AttendanceSuccess(classType: type, moduleCode: code, startTime: start, endTime: end, date: classDate),
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
}
