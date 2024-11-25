import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screen/device_instance_info_screen.dart';
import 'package:flutter_app/utils/sensor.dart';

class SensorButtonText extends StatelessWidget {
  const SensorButtonText({
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

class SensorButton extends StatelessWidget {
  const SensorButton({
    super.key,
    required this.sensorId,
    required this.sensorName,
    required this.fontSize,
    this.backgroundColor = Colors.blueAccent, // Default background color
    this.borderRadius = 8.0, // Default border radius for rounded squares
    required this.onReturn,
    required this.deviceid,
    required this.chartTitle,
    required this.valueAxisTitle
  });

  final int sensorId;
  final String sensorName;
  final double fontSize;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback onReturn;
  final int deviceid;
  final String chartTitle;
  final String valueAxisTitle;

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
            builder: (context) => DeviceInstanceInfoScreen(
              deviceType: 1,
              deviceInstanceId: deviceid,
              sensorId: sensorId,
              actuatorId: 0,
              name: sensorName,
              chartTitle: chartTitle,
              valueAxisTitle: valueAxisTitle,          
            ),
          ),
        ).then((_) => { onReturn });
      },
      child: Container(
        alignment: Alignment.center,
        child: SensorButtonText(
          text: sensorName,
          fontSize: fontSize,
        ),
      ),
    );
  }
}


class SensorListView extends StatelessWidget {
  const SensorListView({
    super.key,
    required this.devices,
    required this.padding,
    required this.fontSize,
    this.crossAxisCount = 2, // Default to 2 columns
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.borderRadius = 8.0, // Default border radius for rounded squares
    this.backgroundColor = Colors.lightGreen,
    required this.onReturn,
    required this.deviceid,
  });

  final List<Sensor> devices;
  final double padding;
  final double fontSize;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double borderRadius;
  final Color backgroundColor;
  final VoidCallback onReturn;
  final int deviceid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return SensorButton(
            sensorId: devices[index].id,
            sensorName: devices[index].name,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            onReturn: onReturn,
            deviceid: deviceid,
            chartTitle: devices[index].chartTitle,
            valueAxisTitle: devices[index].valueAxisTitle,
          );
        },
      ),
    );
  }
}