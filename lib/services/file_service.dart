import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileService {
  static Future<String?> openFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        return await file.readAsString();
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
    return null;
  }

  static Future<String?> saveFile(String content, {String? currentPath}) async {
    try {
      String? savePath;

      if (currentPath != null) {
        final file = File(currentPath);
        await file.writeAsString(content);
        return currentPath;
      }

      savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save File',
        fileName: 'untitled.dart',
      );

      if (savePath != null) {
        final file = File(savePath);
        await file.writeAsString(content);
        return savePath;
      }
    } catch (e) {
      debugPrint('Error saving file: $e');
    }
    return null;
  }

  static Future<String?> saveFileAs(String content) async {
    return saveFile(content, currentPath: null);
  }
}
