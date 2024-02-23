import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    Directory directory;

    if (Platform.isAndroid) {
      // Uprawnienia i zapis w folderze pobrania dla Androida
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      directory = Directory("/storage/emulated/0/Download");
    } else {
      // iOS używa katalogu dokumentów aplikacji
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file= File('$path/$name');

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }
}
