import 'dart:convert';

import 'package:api_project/Models/UsersModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplexJson extends StatefulWidget {
  const ComplexJson({Key? key}) : super(key: key);

  @override
  State<ComplexJson> createState() => _ComplexJsonState();
}

class _ComplexJsonState extends State<ComplexJson> {
  List<UsersModel> userList = [];

  Future<List<UsersModel>> getUserApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        userList.add(UsersModel.fromJson(i));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: getUserApi(),
              builder: (context, AsyncSnapshot<List<UsersModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading");
                } else {
                  return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              ReusableRow(
                                  title: 'name',
                                  value: snapshot.data![index].name.toString()),
                              SizedBox(height: 10),
                              ReusableRow(
                                  title: 'id',
                                  value: snapshot.data![index].id.toString()),
                              SizedBox(height: 10),
                              ReusableRow(
                                  title: 'adress',
                                  value: snapshot.data![index].address!.street
                                      .toString()),
                              SizedBox(height: 10),
                              ReusableRow(
                                  title: 'geo',
                                  value: snapshot.data![index].address!.geo!.lat
                                      .toString()),
                            ]),
                          ),
                        );
                      });
                }
              }),
        ),
      ],
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Text(value),
      ],
    );
  }
}
