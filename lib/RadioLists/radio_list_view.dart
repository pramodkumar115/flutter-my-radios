import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_radios/RadioLists/radio_item.dart';
import 'package:my_radios/RadioLists/radio_item_view.dart';

class RadioListView extends StatefulWidget {
  final String searchText;
  const RadioListView({super.key, required this.searchText});

  @override
  State<RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListView> {
  // final Future<List<RadioItem>> radioItemsList = loadData();

  @override
  void initState() {
    super.initState();
  }

  Future<List<RadioItem>> loadData() async {
    var jsonString = await rootBundle.loadString("assets/radioList.json");
    List<dynamic> data = json.decode(jsonString);
    if (kDebugMode) {
      print(data.length);
    }
    List<RadioItem> radioList = data.map((d) => RadioItem.fromJson(d)).toList();
    if (kDebugMode) {
      print("hello - ${radioList.first}");
    }
    return data.map((d) => RadioItem.fromJson(d)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("error - ${snapshot.error}");
            return const Center(child: Text("Error getting Radio List"));
          } else if (snapshot.hasData) {
            print(widget.searchText);
            final List<RadioItem> radioItems = widget.searchText == ''
                ? snapshot.data!
                : snapshot.data!
                    .where((element) => element.nameOfStation
                        .toLowerCase()
                        .contains(widget.searchText.toLowerCase()))
                    .toList();
            print(radioItems);
            return Expanded(
                child: ListView.builder(
                    itemCount: radioItems.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = radioItems[index];
                      return ListTile(
                          title: Text(item.nameOfStation),
                          leading: const CircleAvatar(
                            // Display the Flutter Logo image asset.
                            foregroundImage:
                                AssetImage('assets/images/music.png'),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RadioItemView(item: item),
                              ),
                            );
                          });
                    }));
          } else {
            return Container(child: const Text("Please check your internet"));
          }
        });
  }
}
