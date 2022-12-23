import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/Photo.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Photos'),
        ),
        body: Center(
          child: FutureBuilder <List<Photo>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Photo>? data = snapshot.data;
                return
                /*
                  ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 75,
                          color: Colors.white,
                          child: Center(child: Text(data![index].title),
                          ),);
                      }
                  );
                */
                ListView(
                  children: get_list_tiles(data!),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  List<ListTile> get_list_tiles(List<Photo> photos){
    List<ListTile> list_tile = [];
    for (var i = 0; i < photos.length; i++) {
      list_tile.add(ListTile(
        onTap: (){
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => PhotoDetail(photo: photos[i]),
      ),
      );
      },
        leading: Image.network(photos[i].thumbnailUrl),
        title: Text(
          photos[i].title,
          textScaleFactor: 1.5,
        ),
      ));
    }

    return list_tile;
  }

  Future <List<Photo>> fetchData() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
    final response =
    await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Photo.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}

class PhotoDetail extends StatelessWidget {
  // In the constructor, require a Todo.
  const PhotoDetail({super.key, required this.photo});

  // Declare a field that holds the Todo.
  final Photo photo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Details"),
      ),
      body: Column(

        children: [
          Image.network(photo.thumbnailUrl),
          Text(
           photo.title,
            style: TextStyle(fontSize: 20.0),
          )
        ],
      )
    );
  }
}