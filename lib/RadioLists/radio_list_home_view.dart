import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_radios/RadioLists/playlist.dart';
import 'package:my_radios/RadioLists/radio_item.dart';
import 'package:my_radios/RadioLists/radio_item_view.dart';
import 'package:my_radios/RadioLists/radio_list_view.dart';
import 'package:my_radios/util/helper.util.dart';

class RadioListHomeView extends StatefulWidget {
  final String tabType;

  const RadioListHomeView({super.key, required this.tabType});

  @override
  State<RadioListHomeView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListHomeView> {
  List<Playlist> playListData = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    loadData();
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
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("error - ${snapshot.error}");
            return const Center(child: Text("Error getting Radio List"));
          } else if (snapshot.hasData) {
            return RadioListView(tabType: widget.tabType, radioItems:  snapshot.data!);
          } else {
            return const Text("Please check your internet");
          }
        });
  }
}
