import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/toastutils.dart';

class DeviceInstanceInfoScreen extends StatefulWidget {
  const DeviceInstanceInfoScreen({
    super.key,
    required this.deviceType,
    required this.instanceId,
    required this.name,
    required this.location
  });

  final String name;
  final String location;
  final int deviceType;
  final int instanceId;

  @override
  State<DeviceInstanceInfoScreen> createState() => _DeviceInstanceInfoScreenState();
}

class _DeviceInstanceInfoScreenState extends State<DeviceInstanceInfoScreen> {

  String errorText = '';

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  void deleteInstancePressed(BuildContext context) async {
    int result = await deleteInstanceRequest(widget.instanceId);

    if (result == 1 && context.mounted) {
      Navigator.pop(context);
      ToastUtils toastUtils = ToastUtils(toastText: "Sensor removed.", context: context);
      toastUtils.showToast();
    } 
    else if (result == -1) {
      setErrorText("Couldn't delete device!");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    // Use switch to determine the content based on deviceType
    switch (widget.deviceType) {
      case 1:
        content = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AppText(text: widget.name, fontSize: 32.0, textColor: Colors.black),
              const Spacer(),
              AppText(text: widget.location, fontSize: 24.0, textColor: Colors.black),
              const AppText(text: 'ide mi kell még? xddd', fontSize: 16.0, textColor: Colors.black),
              const Spacer(),
              AppButton(text: 'Remove device', onPressed: () => {deleteInstancePressed(context)}, fontSize: 32.0, textColor: Colors.black, backgroundColor: Colors.white),
              const Spacer(),
            ],
          ),
        );
        break;
      default:
        content = Text(
          'Unknown Device Type',
          style: TextStyle(fontSize: 24, color: Colors.red),
        );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: content,
      ),
    );
  }
}