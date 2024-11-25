import 'package:flutter/material.dart';
import 'package:flutter_app/utils/actuator.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/sensor.dart';
import 'package:flutter_app/widgets/screen/user_add_device_screen.dart';
import 'package:flutter_app/utils/toastutils.dart';
import 'package:flutter_app/widgets/common/sensors_list.dart';
import 'package:flutter_app/widgets/common/better_custom_widgets.dart';
import 'package:flutter_app/widgets/common/actuator_list.dart';

class PlantDetails extends StatefulWidget {
  /*final Plant plant;*/
  final String plantScName;
  final int id;
  //final int deviceid;
  final VoidCallback onRefresh;

  const PlantDetails({
    super.key,
    required this.plantScName,
    required this.id,
    //required this.deviceid,
    required this.onRefresh
    /*, required this.plant*/
  });

  @override
  _PlantDetailsState createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  bool shouldFetch = true;
  List<Sensor> sensorList = [];
  List<Actuator> actuatorList = [];
  int deviceid = 0;

  void refreshPressed() {
    setState(() {
      shouldFetch = true;
    });
  }

  void getDeviceId() async {
    deviceid = await getDeviceIdByPlant(widget.id);
  }

  void deletePlant(){
    userDeletePlantRequest(widget.id);
    Navigator.pop(context);
    ToastUtils toastUtils = ToastUtils(toastText: "Plant deleted.", context: context);
    toastUtils.showToast();
    widget.onRefresh();
  }

  Future<List<Sensor>> fetchSensorList(int deviceid) async {
    await Future.delayed(const Duration(seconds: 2));
    return userGetSensorRequest(deviceid);
  }

  Future<List<Actuator>> fetchActuatorList(int deviceid) async {
    await Future.delayed(const Duration(seconds: 2));
    return userGetActuatorRequest(deviceid);
  }

  void addDeviceToPlant(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAddDeviceScreen(plantid: widget.id,
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
      body: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Sensor>>(
                future: shouldFetch ? fetchSensorList(1) : Future.value(sensorList),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: ErrorText(
                        errorText: snapshot.error.toString(),
                        fontSize: 24.0,
                      ),
                    );
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    sensorList = snapshot.data!;

                    if (sensorList.isEmpty) {
                      return const Center(child: Text("No sensors available."));
                    }

                    return SensorListView(
                      devices: sensorList,
                      padding: 4.0,
                      fontSize: 24.0,
                      onReturn: refreshPressed,
                      deviceid: deviceid,
                    );
                  }

                  return const Center(child: Text("Failed to load sensors."));
                },
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<List<Actuator>>(
                future: shouldFetch ? fetchActuatorList(1) : Future.value(actuatorList),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: ErrorText(
                        errorText: snapshot.error.toString(),
                        fontSize: 24.0,
                      ),
                    );
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    actuatorList = snapshot.data!;

                    if (actuatorList.isEmpty) {
                      return const Center(child: Text("No actuators available."));
                    }

                    return ActuatorListView(
                      devices: actuatorList,
                      padding: 4.0,
                      fontSize: 24.0,
                      onReturn: refreshPressed,
                    );
                  }

                  return const Center(child: Text("Failed to load actuators."));
                },
              ),
            ],
          ),
        ),
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
