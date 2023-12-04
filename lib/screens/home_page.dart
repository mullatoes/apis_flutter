import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:workingwithapis/model/post.dart';

import '../model/album.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Album> futureAlbum;
  late Future<Post> fetchedAlbumsFromInternet;

  @override
  void initState() {
    super.initState();
    // futureAlbum = fetchAlbum();
    fetchedAlbumsFromInternet = fetchPosts();
  }

  String? name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Apis',
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: fetchedAlbumsFromInternet,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Future<Album> fetchAlbum() async {
    var url = 'https://jsonplaceholder.typicode.com/albums/1';

    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      // successful
      print(response.body);
      var album =
          Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      return album;
    } else {
      print('Error occurred! ${response.statusCode}');
      throw Exception('Failed to load album');
    }
  }

  Future<Post> fetchPosts() async {
    var url = 'https://jsonplaceholder.typicode.com/posts/1';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var post =
          Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      return post;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load a post');
    }
  }

  //http methods
  //get -- retrieves data // success code 200
  //post -- saves data. // 201 - Created Ok
  //update -- update a record.. make a change
  //delete -- remove a record completely 200
}
