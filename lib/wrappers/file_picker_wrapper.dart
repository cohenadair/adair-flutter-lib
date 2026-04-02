import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerWrapper {
  static var _instance = FilePickerWrapper._();

  static FilePickerWrapper get get => _instance;

  @visibleForTesting
  static void set(FilePickerWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = FilePickerWrapper._();

  FilePickerWrapper._();

  Future<FilePickerResult?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
    bool withData = false,
  }) {
    return FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
      withData: withData,
    );
  }
}
