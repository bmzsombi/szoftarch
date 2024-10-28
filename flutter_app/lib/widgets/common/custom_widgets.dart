import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screen/modify_device_config_screen.dart';

class LoginScreenText extends StatelessWidget {
  const LoginScreenText({
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
        color: Colors.green,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
        wordSpacing: 2.0,
        fontStyle: FontStyle.normal,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.grey,
            blurRadius: 0.2
          )
        ]
      ),
    );
  }
}

class LoginScreenButton extends StatelessWidget {

  const LoginScreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize
  });

  final String text;
  final VoidCallback onPressed;
  final double fontSize;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.black,
            width: 1.0
          )
        )
      ),
      child: LoginScreenText(text: text, fontSize: fontSize),
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({
    super.key,
    required this.errorText,
    required this.fontSize
  });

  final String errorText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: TextStyle(
        color: Colors.red,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
        wordSpacing: 2.0,
        fontStyle: FontStyle.normal,
      ),
    );
  }
}

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
  });

  final String text;
  final double fontSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
        wordSpacing: 2.0,
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    required this.textColor,
    required this.backgroundColor,
  });

  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.black,
            width: 1.0
          )
        )
      ),
      child: AppText(text: text, fontSize: fontSize, textColor: textColor),
    );
  }
}

class ConfigUploadRow extends StatelessWidget {
  const ConfigUploadRow({
    super.key,
    required this.text,
    required this.fileText,
    required this.onPressed,
    required this.fontSize,
    required this.textColor,
    required this.backgroundColor
  });

  final String text;
  final String fileText;
  final VoidCallback onPressed;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 32,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
            ),
            child: AppText(text: fileText, fontSize: 18.0, textColor: Colors.grey),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 12,
          child: AppButton(text: text, onPressed: onPressed, fontSize: fontSize, textColor: textColor, backgroundColor: backgroundColor),
        )
      ],
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
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DeviceButton extends StatelessWidget {
  const DeviceButton({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.fontSize
  });

  final int deviceId;
  final String deviceName;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ModifyDeviceConfigScreen(deviceId: deviceId, deviceName: deviceName)
        ))
      },
      child: DeviceButtonText(
        text: deviceName,
        fontSize: fontSize
      )
    );
  }
}
