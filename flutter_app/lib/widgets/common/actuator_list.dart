import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screen/modify_device_config_screen.dart';
import 'package:flutter_app/utils/actuator.dart';

class ActuatorButtonText extends StatelessWidget {
  const ActuatorButtonText({
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

class ActuatorButton extends StatelessWidget {
  const ActuatorButton({
    super.key,
    required this.actuatorId,
    required this.actuatorName,
    required this.fontSize,
    this.backgroundColor = Colors.blueAccent, // Default background color
    this.borderRadius = 8.0, // Default border radius for rounded squares
    required this.onReturn
  });

  final int actuatorId;
  final String actuatorName;
  final double fontSize;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback onReturn;

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
              deviceId: actuatorId,
              deviceName: actuatorName,
            ),
          ),
        ).then((_) => { onReturn });
      },
      child: Container(
        alignment: Alignment.center,
        child: ActuatorButtonText(
          text: actuatorName,
          fontSize: fontSize,
        ),
      ),
    );
  }
}


class ActuatorListView extends StatelessWidget {
  const ActuatorListView({
    super.key,
    required this.devices,
    required this.padding,
    required this.fontSize,
    this.crossAxisCount = 2, // Default to 2 columns
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.borderRadius = 8.0, // Default border radius for rounded squares
    this.backgroundColor = Colors.lightGreen,
    required this.onReturn
  });

  final List<Actuator> devices;
  final double padding;
  final double fontSize;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double borderRadius;
  final Color backgroundColor;
  final VoidCallback onReturn;

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
          return ActuatorButton(
            actuatorId: devices[index].id,
            actuatorName: devices[index].name,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            onReturn: onReturn,
          );
        },
      ),
    );
  }
}