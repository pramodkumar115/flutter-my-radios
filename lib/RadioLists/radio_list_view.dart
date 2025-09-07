import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_radios/RadioLists/radio_item.dart';
import 'package:my_radios/RadioLists/radio_item_view.dart';

class RadioListView extends StatefulWidget {
  final String tabType;

  const RadioListView({super.key, required this.tabType});

  @override
  State<RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListView> {
  // final Future<List<RadioItem>> radioItemsList = loadData();
  final _controller = TextEditingController();

  String searchText = '';
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        searchText = _controller.text;
      });
    });
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
            print(searchText);
            final List<RadioItem> radioItems = searchText == ''
                ? snapshot.data!
                : snapshot.data!
                    .where((element) => element.nameOfStation
                        .toLowerCase()
                        .contains(searchText.toLowerCase()))
                    .toList();
            print(radioItems);
            return Column(children: [
              Text(widget.tabType),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Search Radio Stations"),
              ),
              Expanded(
                  // child: ListView.builder(
                  //     itemCount: radioItems.length,
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       final item = radioItems[index];
                  //       return ListTile(
                  //           title: Text(item.nameOfStation),
                  //           leading: const CircleAvatar(
                  //             // Display the Flutter Logo image asset.
                  //             foregroundImage:
                  //                 AssetImage('assets/images/music.png'),
                  //           ),
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     RadioItemView(item: item),
                  //               ),
                  //             );
                  //           });
                  //     })
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio:
                      1.0, // Ratio of cross-axis to main-axis extent for each tile
                ),
                itemCount: radioItems.length, // Number of items in the grid
                padding: const EdgeInsets.all(10),

                itemBuilder: (context, index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(
                          16.0), // Apply border radius here
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RadioItemView(item: radioItems[index]),
                              ),
                            );
                          },
                          child: GridTile(
                            footer: GridTileBar(
                              backgroundColor: Colors.black54,
                              //title: Text('Item Title'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // To keep buttons close together
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_outline),
                                    color: Colors.white,
                                    onPressed: () {
                                      // Handle favorite button press
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.playlist_add_circle),
                                    color: Colors.white,
                                    onPressed: () {
                                      // Handle share button press
                                    },
                                  ),
                                ],
                              ),
                            ),
                            child: GridTileBar(
                                backgroundColor: Colors.blueAccent[400],
                                title: Center(
                                    child: Text(radioItems[index].nameOfStation,
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        textAlign: TextAlign.center))),
                          )));
                },
              ))
            ]);
          } else {
            return Container(child: const Text("Please check your internet"));
          }
        });
  }
}
