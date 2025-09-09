import 'dart:io';

import 'package:my_radios/RadioLists/radio_item.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String filename) async {
  final path = await _localPath;
  return File('$path/$filename');
}

Future<bool> _checkIfFileExists(String fileName) async {
  final file = await _localFile(fileName);
  return file.exists();
}

Future<File> writeData(String filename, String data) async {
  final file = await _localFile(filename);
  print("In write file $file");
  return file.writeAsString(data);
}

Future<String> readFile(String fileName) async {
  try {
    final file = await _localFile(fileName);
    // Read the file content as a string
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    print("Error reading file: $e");
    return "";
  }
}

List<RadioItem> getItems(List<RadioItem> items, String tabType, List<String> favoritesFileData) {
    if (tabType == 'radioList') {
      return items;
    }
    if (tabType == 'fav') {
      return items
          .where((item) => favoritesFileData.contains(item.id))
          .toList();
    }
    return items;
  }

  List<RadioItem> filterItems(List<RadioItem> items, String searchText) {
    return searchText == ''
        ? items
        : items
            .where((element) => element.nameOfStation
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
  }