import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [];

  bool isloading = true;

  void fetchItems() async {
    http.Response response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=people"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "563492ad6f91700001000001218cf6c70eec418aa26d55c88409f759"
        });

    var responseData = json.decode(response.body);

    items.clear();
    for (var eachItem in responseData['photos']) {
      items.add(eachItem);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
      ),
      body: isloading
          ? Text("Loading...")
          : Column(
              children: [
                ...List.generate(
                    2,
                    (index) => ItemCard(
                          items: items,
                          index: index,
                        ))
              ],
            ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key, required this.items, required this.index})
      : super(key: key);

  final List items;
  final index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(items[index]['photographer']),

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(items[index]['src']['original'])),
            ),
          )

          // )
        ],
      ),
    );
  }
}
