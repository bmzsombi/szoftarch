import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/better_custom_widgets.dart';
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
                LineChartWidget(
                  chartTitle: "example chart",
                  dates: [
                    DateTime(2024, 1, 1),
                    DateTime(2024, 1, 2),
                    DateTime(2024, 1, 3),
                    DateTime(2024, 1, 4),
                  ],
                  values: [10, 20, 15, 25],
                )
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