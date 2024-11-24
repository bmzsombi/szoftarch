import 'package:flutter/material.dart';

class PlantDetails extends StatefulWidget {
  /*final Plant plant;*/

  const PlantDetails({super.key/*, required this.plant*/});

  @override
  _PlantDetailsState createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: const Center (
        child: const SizedBox(
          child: const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Plant Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text('Scientific name: asd'),
                Text('Common name: asd'),
                Text('Category: asd'),
                Text('Light: asd'),
                Text('Soil Moisture: asd'),
                Text('Pump State: asd'),
                Text('Temperature: asd')
              ],
            ),
          ),
        ),
      )
    );
  }
}
