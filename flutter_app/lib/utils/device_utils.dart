import 'dart:io';
import 'package:file_picker/file_picker.dart';

class Device {
  final int id;
  final String name;

  Device({
    required this.id,
    required this.name
  });

  factory Device.fromJson(Map<String, dynamic> json){
    return Device(
      id: json['id'],
      name: json['model']
    );
  }
}

Future<File?> pickConfigFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
  );
  if (result != null) {
    PlatformFile f = result.files.first;
    if (f.extension == 'yaml') {
      File file = File(result.files.single.path!);
      return file;
    }
    else {
      return null;
    }
  } else {
    return null;
  }
}

List<Device> searchDevices(String term, List<Device> allDevices) {

  if (term.isEmpty) {
    return allDevices;
  } 

  List<Device> searchedDevices = [];
  for (Device d in allDevices) {
    if (d.name.contains(term)) {
      searchedDevices.add(d);
    }
  }
  return searchedDevices;
}

class DropdownDeviceItem {
  final String manufacturer;
  final String model;
  final String firmwareVersion;

  DropdownDeviceItem({
    required this.manufacturer,
    required this.model,
    required this.firmwareVersion,
  });

  @override
  String toString() {
    return '$manufacturer $model ($firmwareVersion)';
  }

  factory DropdownDeviceItem.fromJson(Map<String, dynamic> json) {
    return DropdownDeviceItem(
      manufacturer: json['manufacturer'],
      model: json['model'],
      firmwareVersion: json['firmwareVersion'],
    );
  }
}