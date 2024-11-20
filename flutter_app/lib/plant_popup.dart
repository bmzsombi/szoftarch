import 'package:flutter/material.dart';
import 'plant.dart'; // A növény modell importálása

class PlantDetailsPopup extends StatefulWidget {
  final Plant plant;
  final double screenWidth, screenHeight;

  const PlantDetailsPopup({super.key, required this.plant, required this.screenHeight, required this.screenWidth});

  @override
  _PlantDetailsPopupState createState() => _PlantDetailsPopupState();
}

class _PlantDetailsPopupState extends State<PlantDetailsPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: widget.screenWidth * 0.7, // Az ablak szélessége a fő képernyőhöz viszonyítva
        height: widget.screenHeight * 0.6, // Az ablak magassága a fő képernyőhöz viszonyítva
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
              Text('Name: ${widget.plant.name}'),
              Text('Type: ${widget.plant.type}'),
              Text('Humidity: ${widget.plant.humidity}'),
              Text('Light: ${widget.plant.light}'),
              Text('Soil Moisture: ${widget.plant.soilMoisture}'),
              Text('Pump State: ${widget.plant.pumpState}'),
              Text('Temperature: ${widget.plant.temperature}'),
            ],
          ),
        ),
      ),
    );
  }
}
