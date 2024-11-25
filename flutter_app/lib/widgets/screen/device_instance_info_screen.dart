import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/better_custom_widgets.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/chart_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceInstanceInfoScreen extends StatefulWidget {
  const DeviceInstanceInfoScreen({
    super.key,
    required this.deviceType,
    required this.deviceInstanceId,
    required this.sensorId,
    required this.actuatorId,
    required this.name,
    required this.location,
    required this.chartTitle,
    required this.valueAxisTitle
});

  final int deviceInstanceId;
  final int sensorId;
  final int actuatorId;
  final String name;
  final String location;
  final int deviceType;
  final String chartTitle;
  final String valueAxisTitle;

  @override
  State<DeviceInstanceInfoScreen> createState() => _DeviceInstanceInfoScreenState();
}

class _DeviceInstanceInfoScreenState extends State<DeviceInstanceInfoScreen> {

  bool shouldFetch = true;
  String errorText = '';
  List<ChartData> chartData = [];

  Future<List<ChartData>> getSensorMeasurement(int deviceInstanceId, int sensorId) async {
    var uri = Uri.http(url, 'deviceInstance/$deviceInstanceId/sensorsMeasurement5/$sensorId');
    var response = await http.get(uri,
      headers: {
        "Content-type": "application/json"
      }
    );
    if (response.statusCode == 200) {
      List<ChartData> data = convertToChartData(jsonDecode(response.body));
      return data;
    }
    else {
      return [];
    }
  }


  // Future<List<ChartData>> fetchSensorData() async {   //TODO: http
  //   await Future.delayed(Duration(seconds: 2));
  //   return [
  //     ChartData(DateTime(2023, 1, 1), 10),
  //     ChartData(DateTime(2023, 2, 1), 20),
  //     ChartData(DateTime(2023, 3, 1), 15),
  //     ChartData(DateTime(2023, 4, 1), 30),
  //   ];
  // }

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
                      AppText(text: widget.location, fontSize: 24.0, textColor: Colors.black),
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
        content = const ErrorText(errorText: 'nem szenzor');
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