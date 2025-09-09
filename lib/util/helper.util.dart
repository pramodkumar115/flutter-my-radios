import 'dart:io';

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
    if (true == file.exists()) {
      // Read the file content as a string
      String contents = await file.readAsString();
      return contents;
    }
    return "";
  } catch (e) {
    print("Error reading file: $e");
    return "";
  }
}
