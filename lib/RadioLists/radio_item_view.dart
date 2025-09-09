import 'package:flutter/material.dart';
import 'package:my_radios/RadioLists/radio_item.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RadioItemView extends StatefulWidget {
  final RadioItem item;
  const RadioItemView({super.key, required this.item});

  @override
  State<RadioItemView> createState() => RadioItemViewState();

}

class RadioItemViewState extends State<RadioItemView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
      Widget build(BuildContext context) {
        _controller.loadRequest(Uri.parse(widget.item.urlLink));
        return Scaffold(
          appBar: AppBar(title: Text('Radio - ${widget.item.nameOfStation}')),
          body: WebViewWidget(controller: _controller),
        );
      }
}