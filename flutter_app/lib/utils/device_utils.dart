import 'dart:io';
import 'package:file_picker/file_picker.dart';

class Device {
  final int id;
  final String name;

  Device(this.id, this.name);
}

List<Device> getDeviceList() {
  final deviceList = <Device>[];

  deviceList.add(Device(1, 'a'));
  deviceList.add(Device(2, 'aa'));
  deviceList.add(Device(3, 'aaa'));
  deviceList.add(Device(4, 'aaaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(5, 'aaeaa'));
  deviceList.add(Device(1, 'aaa'));
  deviceList.add(Device(2, 'aa'));
  deviceList.add(Device(3, 'a'));

  return deviceList; 
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