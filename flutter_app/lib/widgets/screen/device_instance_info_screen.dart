import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/better_custom_widgets.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/chart_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_app/utils/toastutils.dart';

class DeviceInstanceInfoScreen extends StatefulWidget {
  const DeviceInstanceInfoScreen({
    super.key,
    required this.deviceType,
    required this.deviceInstanceId,
    required this.sensorId,
    required this.actuatorId,
    required this.name,
    required this.chartTitle,
    required this.valueAxisTitle,
    required this.onUpEndpoint,
    required this.offDownEndpoint
});

  final int? deviceInstanceId;
  final int sensorId;
  final int actuatorId;
  final String name;
  final int deviceType;
  final String chartTitle;
  final String valueAxisTitle;

  final String offDownEndpoint;
  final String onUpEndpoint;

  @override
  State<DeviceInstanceInfoScreen> createState() => _DeviceInstanceInfoScreenState();
}

class _DeviceInstanceInfoScreenState extends State<DeviceInstanceInfoScreen> {

  bool actuatorState = false;
  bool shouldFetch = true;
  String errorText = '';
  List<ChartData> chartData = [];

  void refreshPressed() {
    setState(() {
      shouldFetch = true;
    });
  }

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastUtils toastUtilsActuatorDown = ToastUtils(toastText: "Turn off request sent. Please wait!", context: context);
    ToastUtils toastUtilsActuatorUp = ToastUtils(toastText: "Turn on request sent. Please wait!", context: context);
    Widget content;

    switch (widget.deviceType) {
      case 1:
        content = FutureBuilder(
          future: shouldFetch ? getSensorMeasurement(widget.deviceInstanceId, widget.sensorId) : null,
          builder: (context, snapshot) {
            if (shouldFetch) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              shouldFetch = false;
              if (snapshot.hasError) {
                return Center(child: ErrorText(errorText: snapshot.error.toString(), fontSize: 24.0));
              }
              if (snapshot.hasData) {
                chartData = snapshot.data!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(text: widget.name, fontSize: 32.0, textColor: Colors.black),
                      //AppText(text: widget.location, fontSize: 24.0, textColor: Colors.black),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: const DateTimeAxis(
                            title: AxisTitle(text: 'Date'),
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: widget.valueAxisTitle),
                          ),
                          title: ChartTitle(text: widget.chartTitle),
                          legend: const Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries<ChartData, DateTime>>[
                            LineSeries<ChartData, DateTime>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.value,
                              name: 'Values',
                              markerSettings: const MarkerSettings(isVisible: true),
                              dataLabelSettings: const DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                );
              }
              return const Center(child: ErrorText(errorText: "No sensor data available"));
            }
            else {
              return const Center(child: ErrorText(errorText: "No sensor data available"));
            }
          }
        );
        break;
      case 2:
        content = FutureBuilder(
          future: shouldFetch ? getActuatorState(widget.deviceInstanceId, widget.sensorId) : null,
          builder: (context, snapshot) {
            if (shouldFetch) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              shouldFetch = false;
              if (snapshot.hasError) {
                return Center(child: ErrorText(errorText: snapshot.error.toString(), fontSize: 24.0));
              }
              if (snapshot.hasData) {
                actuatorState = snapshot.data!;
                if (actuatorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(text: widget.name, fontSize: 32.0, textColor: Colors.black),
                        const Spacer(),
                        const AppText(text: 'Current state: on', fontSize: 24.0, textColor: Colors.black),
                        const Spacer(),
                        AppButton(text: 'Turn off', onPressed: () => {
                          turnOffActuatorRequest(widget.deviceInstanceId, widget.actuatorId), 
                          refreshPressed(),
                          toastUtilsActuatorDown.showToast()
                        }, 
                        fontSize: 32.0, textColor: Colors.black, backgroundColor: Colors.red),
                        const Spacer()
                      ],
                     ),
                    );
                  }
                else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(text: widget.name, fontSize: 32.0, textColor: Colors.black),
                        const Spacer(),
                        const AppText(text: 'Current state: off', fontSize: 24.0, textColor: Colors.black),
                        const Spacer(),
                        AppButton(text: 'Turn on', onPressed: () => {
                          turnOnActuatorRequest(widget.deviceInstanceId, widget.actuatorId),
                          refreshPressed(),
                          toastUtilsActuatorUp.showToast()
                        },
                        fontSize: 32.0, textColor: Colors.black, backgroundColor: Colors.green),
                        const Spacer()
                      ],
                     ),
                    );
                }
              }
              return const ErrorText(errorText: 'No data from actuator!');
            }
            else {
              return const ErrorText(errorText: 'No data from actuator!');
            }
          }
        );
        break;
      default:
        content = const ErrorText(
          errorText: 'Unknown sensor type',
        );
    }

    return Scaffold(
      appBar: AppBar(
          actions: [
          IconButton(
            onPressed: refreshPressed,
            icon: const Icon(Icons.refresh),
            iconSize: 32.0,
          ),
        ]
      ),
      body: Center(
        child: content,
      ),
    );
  }
}