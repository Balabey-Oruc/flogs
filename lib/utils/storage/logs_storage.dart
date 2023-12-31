import 'dart:developer';
import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LogsStorage {
  static final LogsStorage _singleton = LogsStorage._();

  /// Singleton accessor
  static LogsStorage get instance => _singleton;

  // A private constructor. Allows us to create instances of LogsStorage
  // only from within the LogsStorage class itself.
  LogsStorage._();

  // Filing methods:------------------------------------------------------------
  Future<String?> get _localPath async {
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getAppPath();
    }

    return directory.path;
  }

  Directory getAppPath() {
    if (Platform.isWindows) {
      return Directory(path.dirname(Platform.resolvedExecutable));
    }
    return Directory.current;
  }

  Future<File> get _localFile async {
    final path = "${await _localPath}/${Constants.DIRECTORY_NAME}";

    //creating directory
    Directory(path)
        .create()
        // The created directory is returned as a Future.
        .then((Directory directory) {
      print(directory.path);
    });

    //opening file
    var file = File("$path/flog.txt");
    var isExist = await file.exists();

    //check to see if file exist
    if (isExist) {
      print('File exists------------------>_getLocalFile()');
    } else {
      print('file does not exist---------->_getLocalFile()');
    }
    final parentPath = await file.parent.create(recursive: true);
    log('parentPath => $parentPath');
    return file;
  }

  /// Read the Log-String from file
  Future<String> readLogsToFile() async {
    try {
      final file = await _localFile;

      // Read the file
      var contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return error message
      return "Unable to read file";
    }
  }

  /// Writes the `log`-String to file
  Future<File> writeLogsToFile(String log) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$log');
  }
}
