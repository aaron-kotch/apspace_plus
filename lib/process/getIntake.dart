import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'Intake.dart';
import 'package:http/http.dart' as http;


Future<List<Intake>> fetchIntake(http.Client client, var ticket) async {

  var queryParam = {
    'ticket': ticket,
  };

  var uri = Uri.https('api.apiit.edu.my', '/student/courses', queryParam);

  final response = await client.get(uri);
  //print(parseList(response.body));

  return compute(parseIntake, response.body);

  //task: loop to find correct course
}

List<Intake> parseIntake(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Intake>((json) => Intake.fromJson(json)).toList();
}