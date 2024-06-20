import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:my_home_stair/my_home_stair.dart';

class FileRepository {
  Future<void> downloadFile(
    String accessToken,
    String contractId,
    String historyId,
    String directory,
  ) async {
    final url ='http://$serverHost/v1/contract/$contractId/history/$historyId/downloadFile';
    print(url);
    print(directory);
    try {
      await FlutterDownloader.enqueue(
        url: url,
        headers: {
          'Authorization': accessToken,
        },
        savedDir: directory,
        saveInPublicStorage: true
      );
      print('download success');
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }
}
