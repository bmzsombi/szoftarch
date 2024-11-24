import 'dart:io';
import 'package:flutter/material.dart';
import '../common/custom_widgets.dart';
import '/utils/device_utils.dart';

class ModifyDeviceConfigScreen extends StatefulWidget {
  const ModifyDeviceConfigScreen({
    super.key,
    required this.deviceId,
    required this.deviceName
  });

  final int deviceId;
  final String deviceName;

  @override
  State<ModifyDeviceConfigScreen> createState() => _ModifyDeviceConfigScreenState();
}

class _ModifyDeviceConfigScreenState extends State<ModifyDeviceConfigScreen> {
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

  void modifyDevicePressed() {
    // TODO: manufacturerModifyDeviceRequest();
  }

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const AppText(text: 'Modify device', fontSize: 32.0, textColor: Colors.black),
            AppText(text: widget.deviceName, fontSize: 24.0, textColor: Colors.black),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(text: 'New configuration file', fontSize: 24.0, textColor: Colors.black)
                    ],
                  ),
                  ConfigUploadRow(text: 'Browse', onPressed: browseFilePressed, fontSize: 12.0, textColor: Colors.white, backgroundColor: Colors.black, fileText: configFileName)
                ],
              ),
            ),
            const Spacer(),
            AppButton(text: 'Modify device', onPressed: modifyDevicePressed, fontSize: 24.0, textColor: Colors.black, backgroundColor: Colors.white),
            const Spacer(),
            ErrorText(errorText: errorText, fontSize: 24),
            const Spacer()
          ],
        ),
      )
    );
  }
}