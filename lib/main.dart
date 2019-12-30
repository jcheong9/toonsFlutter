import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost() async {
  final response =
  await http.get('http://data.vncvr.ca/api/people');

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // If the call to the server was successful, parse the JSON.
    return (data as List).map((p) => Post.fromJson(p)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int id;
  final String lastName;
  final String firstName;
  final String occupation;
  final String gender;
  final String pictureUrl;

  Post({this.id, this.lastName, this.firstName, this.occupation, this.gender, this.pictureUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      occupation: json['occupation'],
      gender: json['gender'],
      pictureUrl: json['pictureUrl'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Post>> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: FutureBuilder<List<Post>>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data[index];
                      return  ListTile(
                          title: Text(item.occupation),
                      );
                    },
                );
//                return Text(snapshot.data[0].occupation);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
        ),
      ),
    );
  }
}
