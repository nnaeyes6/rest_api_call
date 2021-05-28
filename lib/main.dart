import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API CALL',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('REST API '),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            // builder: (context, snapshot) {
            //   // if (snapshot.hasData) {
            //   //   return ListView.builder(
            //   //       itemCount: snapshot.data.number,
            //   //       itemBuilder: (context, index) {
            //   //         return ListTile(
            //   //             title: Text(snapshot.data.people[index]['name']),
            //   //             subtitle: Text(
            //   //               snapshot.data.people[index]['craft'],
            //   //             ));
            //   //       });
            //   // } else if (snapshot.hasError) {
            //   //   return Text("${snapshot.error}");
            //   // }

            builder: (context, abc) {
              if (abc.hasData) {
                return Text(abc.data.author);
              } else if (abc.hasError) {
                return Text("${abc.error}");
              }
// By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class Post {
  final int number;
  final String id;
  final String name;
  final String author;

  Post({this.number, this.name, this.id, this.author});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      number: json["number"],
      id: json['id'],
      name: json['name'],
      author: json['people'],
    );
  }
}

Future<Post> fetchPost() async {
  final response =
  await http.get(Uri.parse('https://gnews.io/api/v4/search?q=example&token=API-Token'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
