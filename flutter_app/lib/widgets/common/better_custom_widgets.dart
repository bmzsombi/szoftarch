import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screen/modify_device_config_screen.dart';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_app/utils/chart_utils.dart';

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
    this.fontSize = 16.0,
    this.backgroundColor = const Color(0xFFFFE5E5),
    this.textColor = const Color(0xFFB00020),
  });

  final String errorText;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {

    if (errorText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: textColor.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: textColor,
            size: fontSize + 6,
          ),
          const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              errorText,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.4,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
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
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        wordSpacing: 2.0,
        shadows: const [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 0.2,
            color: Colors.black26,
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 18.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8.0,
        shadowColor: backgroundColor.withOpacity(0.5),
        side: BorderSide(color: textColor.withOpacity(0.7), width: 2.0),
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    required this.backgroundColor,
  });

  final String text;
  final String fileText;
  final VoidCallback onPressed;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 32,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade600, width: 1.5),
              ),
              child: Text(
                fileText,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: AppButton(
                text: text,
                onPressed: onPressed,
                fontSize: fontSize,
                textColor: textColor,
                backgroundColor: backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceButtonText extends StatelessWidget {
  const DeviceButtonText({
    super.key,
    required this.text,
    required this.fontSize,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white, // White text color for contrast
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.5),
            offset: Offset(2, 2),
          ),
        ],
        letterSpacing: 1.5,
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
    this.backgroundColor = Colors.blueAccent,
    this.borderRadius = 16.0,
    required this.onReturn,
    this.icon, // Optional icon for the button
  });

  final int deviceId;
  final String deviceName;
  final double fontSize;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback onReturn;
  final Widget? icon; // Optional icon

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 109, 231, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.zero,
        elevation: 8.0,
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
        ).then((_) => onReturn());
      },
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor.withOpacity(0.000001), backgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0), // More padding for better appearance
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8.0), // Space between icon and text
              ],
              DeviceButtonText(
                text: deviceName,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DeviceListView extends StatelessWidget {
  const DeviceListView({
    super.key,
    required this.devices,
    required this.padding,
    required this.fontSize,
    this.crossAxisCount = 3, // Default to 2 columns
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.borderRadius = 8.0, // Default border radius for rounded squares
    required this.backgroundColor,
    required this.onReturn
  });

  final List<Device> devices;
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
            onReturn: onReturn,
          );
        },
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<DateTime> dates;
  final List<double> values;
  final String chartTitle;

  LineChartWidget({required this.chartTitle ,required this.dates, required this.values, Key? key})
      : assert(dates.length == values.length,
            'Dates and values lists must have the same length.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Prepare the data
    final List<ChartData> chartData = List.generate(
      dates.length,
      (index) => ChartData(dates[index], values[index]),
    );

    return SfCartesianChart(
      primaryXAxis: const DateTimeAxis(), // Date-time axis for X
      primaryYAxis: const NumericAxis(), // Numeric axis for Y
      title: ChartTitle(text: chartTitle),
      tooltipBehavior: TooltipBehavior(enable: true),
      // Explicitly define the type for the series
      series: <CartesianSeries<ChartData, DateTime>>[
        LineSeries<ChartData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.value,
          name: 'Value',
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}