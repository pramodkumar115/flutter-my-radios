import 'package:flutter/material.dart';
import 'package:my_radios/RadioLists/radio_list_view.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _controller = TextEditingController();
  String searchText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {
        searchText = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller.dispose();
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
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "Search Radio Stations"),
        ),
        RadioListView(searchText: searchText)
      ]),
    );
  }
}
