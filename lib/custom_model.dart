import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomModel extends StatefulWidget {
  const CustomModel({Key? key}) : super(key: key);

  @override
  State<CustomModel> createState() => _CustomModelState();
}

class _CustomModelState extends State<CustomModel> {
  List<Photos> photoList = [];
  Future<List<Photos>> getPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        Photos photos = Photos(title: i['title'], id: i['id'], url: i['url']);
        data.add(photos);
      }
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: getPhotos(),
              builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
                return ListView.builder(
                    itemCount: photoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data![index].url.toString()),
                        ),
                        title: Text(snapshot.data![index].id.toString()),
                        subtitle: Text(snapshot.data![index].title.toString()),
                      );
                    });
              }),
        ),
      ],
    );
  }
}

class Photos {
  int id;
  String title, url;
  Photos({required this.title, required this.id, required this.url});
}
