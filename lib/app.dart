import 'package:flutter/material.dart';
import 'package:my_radios/RadioLists/radio_list_home_view.dart';
import 'package:my_radios/RadioLists/radio_list_view.dart';
import 'package:my_radios/util/helper.util.dart';


class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late TabController tabController;

  String searchText = '';
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        searchText = _controller.text;
      });
    });
    writeData('my_data.txt', 'Hello World!');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          title: const Text("My Radios"),
        ),
        body: Form(
          child: Column(children: [
            TabBar(controller: tabController, tabs: const [
              Tab(text: "Radio List"),
              Tab(text: "My Favorites"),
              Tab(text: "Playlist")
            ]),
            Expanded(
              child: TabBarView(controller: tabController, children: const [
                RadioListHomeView(tabType: "radioList"),
                RadioListHomeView(tabType: "fav"),
                RadioListHomeView(tabType: "playList")
              ]),
            )
          ]),
        ));
  }
}
