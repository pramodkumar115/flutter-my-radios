import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_radios/RadioLists/radio_item.dart';
import 'package:my_radios/RadioLists/radio_item_view.dart';
import 'package:my_radios/util/helper.util.dart';

class RadioListView extends StatefulWidget {
  final String tabType;
  final List<RadioItem> radioItems;

  const RadioListView(
      {super.key, required this.tabType, required this.radioItems});

  @override
  State<RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListView> {
  List<String> favoritesFileData = List.empty(growable: true);
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
    loadData();
  }

  loadData() async {
    var favoritesString = await readFile("favorites.json");
    List<String> favData = List.empty(growable: true);

    if (favoritesString != null && favoritesString != "") {
      List<dynamic> favJson = json.decode(favoritesString);
      for (var i = 0; i < favJson.length; i++) {
        favData.add(favJson[i]);
      }
    }

    setState(() {
      favoritesFileData = favData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<RadioItem> items = filterItems(
        getItems(widget.radioItems, widget.tabType, favoritesFileData),
        searchText);
    return Column(children: [
      TextField(
        controller: _controller,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: "Search Radio Stations"),
      ),
      Expanded(
          child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.8,
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: items.length, // Number of items in the grid
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          var item = items[index];
          return ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    trailing: Row(
                      mainAxisSize:
                          MainAxisSize.max, // To keep buttons close together
                      children: [
                        IconButton(
                          icon: Icon(favoritesFileData.contains(item.id)
                              ? Icons.favorite
                              : Icons.favorite_outline),
                          color: Colors.white,
                          onPressed: () {
                            var favData = favoritesFileData;
                            if (favoritesFileData.contains(item.id)) {
                              favData = favoritesFileData
                                  .where((d) => d != item.id)
                                  .toList();
                            } else {
                              favData.add(item.id);
                            }
                            writeData("favorites.json", jsonEncode(favData));
                            loadData();
                            // Handle favorite button press
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.playlist_add_circle),
                          color: Colors.white,
                          onPressed: () {
                            // Handle share button press
                            print("In playlist_add_circle");
                          },
                        ),
                      ],
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RadioItemView(item: item),
                        ),
                      );
                    },
                    child: GridTileBar(
                        backgroundColor: Colors.blueAccent[400],
                        title: Center(
                            child: Text(item.nameOfStation,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                textAlign: TextAlign.center))),
                  )));
        },
      ))
    ]);
  }
}
