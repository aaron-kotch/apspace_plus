import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'Course.dart';
import 'package:http/http.dart' as http;


Future<List<Course>> fetchCourse(http.Client client, var ticket) async {

  var queryParam = {
    'intake': 'UC2F2008CS',
    'ticket': ticket,
  };

  var uri = Uri.https('api.apiit.edu.my', '/student/attendance', queryParam);
  
  final response = await client.get(uri);
  //print(parseList(response.body));

  return compute(parseCourse, response.body);

  //task: loop to find correct course
}

List<Course> parseCourse(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Course>((json) => Course.fromJson(json)).toList();
}