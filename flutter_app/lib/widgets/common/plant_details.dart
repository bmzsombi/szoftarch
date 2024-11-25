import 'package:flutter/material.dart';
import 'package:flutter_app/utils/actuator.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/sensor.dart';
import 'package:flutter_app/widgets/screen/user_add_device_screen.dart';
import 'package:flutter_app/utils/toastutils.dart';
import 'package:flutter_app/widgets/screen/add_device_to_plant_screen.dart';
import 'package:flutter_app/widgets/common/sensors_list.dart';
import 'package:flutter_app/widgets/common/better_custom_widgets.dart';

class PlantDetails extends StatefulWidget {
  /*final Plant plant;*/
  final String plantScName;
  final int id;
  final VoidCallback onRefresh;

  const PlantDetails({
    super.key,
    required this.plantScName,
    required this.id,
    required this.onRefresh
    /*, required this.plant*/
  });

  @override
  _PlantDetailsState createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  bool shouldFetch = true;
  List<Sensor> sensorList = [];

  void refreshPressed() {
    setState(() {
      shouldFetch = true;
    });
  }

  void deletePlant(){
    userDeletePlantRequest(widget.id);
    Navigator.pop(context);
    ToastUtils toastUtils = ToastUtils(toastText: "Plant deleted.", context: context);
    toastUtils.showToast();
    widget.onRefresh();
  }

  Future<List<Sensor>> fetchSensorList(String deviceid) async {
    await Future.delayed(const Duration(seconds: 2));
    return userGetSensorRequest(deviceid);
  }

  Future<List<Actuator>> fetchActuatorList(String deviceid) async {
    await Future.delayed(const Duration(seconds: 2));
    return userGetActuatorRequest(deviceid);
  }

  void addDeviceToPlant(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAddDeviceScreen(
          /*plantId: widget.id,
          onDeviceAdded: () {
            // Itt frissítheted az adatokat, ha szükséges
            widget.onRefresh();
          },*/
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Details'),
      ),
      body: FutureBuilder(
        future: shouldFetch ? fetchSensorList() : null,
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
              sensorList = snapshot.data!;
              return SensorListView(
                devices: sensorList,
                padding: 4.0,
                fontSize: 24.0,
                onReturn: refreshPressed,
              );
            }
            return const Center(child: Text("No devices available"));
          }
          else {
            return SensorListView(
              devices: sensorList,//searchedDeviceList,
              padding: 4.0,
              fontSize: 24.0,
              onReturn: () => {},
            );
          }
        }
      ),
/*
      Center(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Plant Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text('Scientific name: ${widget.plantScName}'),
                const Text('Common name: Common Name Example'),
                const Text('Category: Example Category'),
                const Text('Light: High'),
                const Text('Soil Moisture: Medium'),
                const Text('Pump State: Off'),
                const Text('Temperature: 22°C'),
              ],
            ),
          ),
        ),
      ),*/
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'adddevicetoplant',
            onPressed: addDeviceToPlant, // Eszköz hozzáadás funkció
            backgroundColor: Colors.blue, // Kék szín
            tooltip: 'Add Device',
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 10), // Távolság a gombok között
          FloatingActionButton(
            heroTag: 'deleteplant',
            onPressed: deletePlant, // Törlés gomb funkció
            backgroundColor: Colors.red, // Piros szín
            tooltip: 'Delete Plant',
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Jobb alsó sarok
    );
  }
}
