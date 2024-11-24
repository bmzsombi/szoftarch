import 'package:flutter/material.dart';

class AddPlantPopup extends StatefulWidget {
  final void Function(String plantScName, String plantCName, String plantCat, String plantMaxL,
  String plantMinL, String plantMaxEnvHum, String plantMinEnvHum, String plantMaxSoM, String plantMinSoM,
  String plantMaxTemp, String plantMintemp) onAdd;

  final VoidCallback onRefresh;

  const AddPlantPopup({
    super.key, 
    required this.onAdd,
    required this.onRefresh
  });

  @override
  State<AddPlantPopup> createState() => _AddPlantPopupState();
}

class _AddPlantPopupState extends State<AddPlantPopup> {
  final TextEditingController _plantScNameController = TextEditingController();
  final TextEditingController _plantCNameController = TextEditingController();
  final TextEditingController _plantCatController = TextEditingController();
  final TextEditingController _plantMaxLController = TextEditingController();
  final TextEditingController _plantMinLController = TextEditingController();
  final TextEditingController _plantMaxEnvHumController = TextEditingController();
  final TextEditingController _plantMinEnvHumController = TextEditingController();
  final TextEditingController _plantMaxSoMController = TextEditingController();
  final TextEditingController _plantMinSoMController = TextEditingController();
  final TextEditingController _plantMaxTempController = TextEditingController();
  final TextEditingController _plantMinTempController = TextEditingController();

  String? _errorMessage;

  void _addPlant() {
    final plantScName = _plantScNameController.text.trim();
    final plantCName = _plantCNameController.text.trim();
    final plantCat = _plantCatController.text.trim();
    final plantMaxL = _plantMaxLController.text.trim();
    final plantMinL = _plantMinLController.text.trim();
    final plantMaxEnvHum = _plantMaxEnvHumController.text.trim();
    final plantMinEnvHum = _plantMinEnvHumController.text.trim();
    final plantMaxSoM = _plantMaxSoMController.text.trim();
    final plantMinSoM = _plantMinSoMController.text.trim();
    final plantMaxTemp = _plantMaxTempController.text.trim();
    final plantMinTemp = _plantMinTempController.text.trim();

    if (plantScName.isEmpty || plantCName.isEmpty || plantCat.isEmpty || plantMaxL.isEmpty || plantMinL.isEmpty || plantMaxEnvHum.isEmpty ||
    plantMinEnvHum.isEmpty || plantMaxSoM.isEmpty || plantMinSoM.isEmpty || plantMaxTemp.isEmpty || plantMinTemp.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required!';
      });
      return;
    }
    widget.onAdd(
      plantScName, plantCName, plantCat, plantMaxL, plantMinL, plantMaxEnvHum, 
      plantMinEnvHum, plantMaxSoM, plantMinSoM, plantMaxTemp, plantMinTemp
    );
    
    widget.onRefresh();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Plant'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_errorMessage != null) // Hibaüzenet megjelenítése, ha van
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _plantScNameController,
              decoration: const InputDecoration(
                labelText: 'Plant scientific name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantCNameController,
              decoration: const InputDecoration(
                labelText: 'Plant common name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantCatController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMaxLController,
              decoration: const InputDecoration(
                labelText: 'Maximum light',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMinLController,
              decoration: const InputDecoration(
                labelText: 'Minimum light',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMaxEnvHumController,
              decoration: const InputDecoration(
                labelText: 'Maximum environment humidity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMinEnvHumController,
              decoration: const InputDecoration(
                labelText: 'Minimum envornment humidity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMaxSoMController,
              decoration: const InputDecoration(
                labelText: 'Maximum soil moisture',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMinSoMController,
              decoration: const InputDecoration(
                labelText: 'Minimum soil moisture',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMaxTempController,
              decoration: const InputDecoration(
                labelText: 'Maximum temperature',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _plantMinTempController,
              decoration: const InputDecoration(
                labelText: 'Minimum temperate',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Pop-up bezárása
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addPlant,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
