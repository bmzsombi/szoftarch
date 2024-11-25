import 'package:flutter/material.dart';

class AddDeviceToPlantScreen extends StatelessWidget {
  final int plantId;
  final VoidCallback onDeviceAdded;

  const AddDeviceToPlantScreen({
    super.key,
    required this.plantId,
    required this.onDeviceAdded,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController deviceNameController = TextEditingController();
    final TextEditingController deviceTypeController = TextEditingController();

    void addDevice() {
      // Példa: az eszköz adatainak mentése vagy API-hívás
      print('Adding device to plant ID: $plantId');
      print('Device Name: ${deviceNameController.text}');
      print('Device Type: ${deviceTypeController.text}');

      // Itt végezhetsz API-hívást az eszköz hozzáadásához
      // Ha sikerült, értesítjük a szülő képernyőt
      onDeviceAdded();
      Navigator.pop(context); // Visszatérés az előző képernyőre
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: deviceNameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter the device name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deviceTypeController,
              decoration: const InputDecoration(
                labelText: 'Device Type',
                hintText: 'Enter the device type',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addDevice,
              child: const Text('Add Device'),
            ),
          ],
        ),
      ),
    );
  }
}