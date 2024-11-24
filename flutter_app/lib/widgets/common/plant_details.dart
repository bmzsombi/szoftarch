import 'package:flutter/material.dart';
import 'package:flutter_app/utils/http_requests.dart';

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
    /*, required this.plant*/});

  @override
  _PlantDetailsState createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  void deletePlant(){
    userDeletePlantRequest(widget.id);
    Navigator.pop(context);
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Details'),
      ),
      body: Center(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deletePlant, // Törlés gomb funkció
        backgroundColor: Colors.red, // Piros szín
        tooltip: 'Delete Plant',
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Jobb alsó sarok
    );
  }
}
