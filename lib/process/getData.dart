import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'Album.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbum(http.Client client) async {

  final response = await client.get(Uri.parse('https://s3-ap-southeast-1.amazonaws.com/open-ws/weektimetable'));

  //print(parseList(response.body));

  return compute(parseList, response.body);

  //task: loop to find correct course
}

List<Album> parseList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}