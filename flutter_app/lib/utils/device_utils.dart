import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future<File?> pickConfigFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['jpg']
  );
  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    return null;
  }
}