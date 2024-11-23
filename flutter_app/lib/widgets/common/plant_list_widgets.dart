import 'package:flutter/material.dart';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:flutter_app/widgets/screen/modify_device_config_screen.dart';

class DeviceListView extends StatelessWidget {
  const DeviceListView({
    super.key,
    required this.devices,
    required this.padding,
    required this.fontSize,
    this.crossAxisCount = 2, // Default to 2 columns
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.borderRadius = 8.0, // Default border radius for rounded squares
    this.backgroundColor = Colors.lightGreen, // Default background color for buttons
  });

  final List<Device> devices;
  final double padding;
  final double fontSize;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceButton(
            deviceId: devices[index].id,
            deviceName: devices[index].name,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

class DeviceButton extends StatelessWidget {
  const DeviceButton({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.fontSize,
    this.backgroundColor = Colors.blueAccent, // Default background color
    this.borderRadius = 8.0, // Default border radius for rounded squares
  });

  final int deviceId;
  final String deviceName;
  final double fontSize;
  final Color backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        padding: EdgeInsets.zero, // Remove default padding for custom sizing
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModifyDeviceConfigScreen(
              deviceId: deviceId,
              deviceName: deviceName,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: DeviceButtonText(
          text: deviceName,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class DeviceButtonText extends StatelessWidget {
  const DeviceButtonText({
    super.key,
    required this.text,
    required this.fontSize
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
    );
  }
}