import 'dart:io';
import 'package:flutter/material.dart';
import '../common/custom_widgets.dart';
import '/utils/device_utils.dart';
import 'package:flutter_app/utils/http_requests.dart';


class AddNewDeviceScreen extends StatefulWidget {
  const AddNewDeviceScreen({
    super.key
  });

  @override
  State<AddNewDeviceScreen> createState() => _AddNewDeviceScreenState();
}

class _AddNewDeviceScreenState extends State<AddNewDeviceScreen> {
  final TextEditingController deviceNameController = TextEditingController();
  String errorText = '';
  File? configFile;
  String configFileName = '';

  void browseFilePressed() async {
    File? f = await pickConfigFile();
    if (f != null) {
      setState(() {
        configFile = f;
        configFileName = f.path;
      });
    }
  }

  void uploadDevicePressed() {
    if (deviceNameController.text.trim().isNotEmpty) {
      // TODO: manufacturerAddDeviceRequest();
    }
    else {
      setErrorText("Device name can't be empty!");
    }
  }

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const AppText(text: 'Add new device', fontSize: 32.0, textColor: Colors.black),
            const Spacer(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
              child: TextField(
                onChanged: (text) { setErrorText(''); },
                controller: deviceNameController,
                decoration: const InputDecoration(
                  labelText: "Device name",
                  hintText: "Enter the device name",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(text: 'Configuration file', fontSize: 24.0, textColor: Colors.black)
                    ],
                  ),
                  ConfigUploadRow(text: 'Browse', onPressed: browseFilePressed, fontSize: 12.0, textColor: Colors.white, backgroundColor: Colors.black, fileText: configFileName)
                ],
              ),
            ),
            const Spacer(),
            AppButton(text: 'Upload device', onPressed: uploadDevicePressed, fontSize: 24.0, textColor: Colors.black, backgroundColor: Colors.white),
            const Spacer(),
            ErrorText(errorText: errorText, fontSize: 24.0),
            const Spacer()
          ],
        ),
      ),
    );
  }
}