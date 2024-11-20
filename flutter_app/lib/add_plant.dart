import 'package:flutter/material.dart';

class AddPlantPopup extends StatefulWidget {
  final void Function(String plantName, String plantType) onAdd;

  const AddPlantPopup({super.key, required this.onAdd});

  @override
  State<AddPlantPopup> createState() => _AddPlantPopupState();
}

class _AddPlantPopupState extends State<AddPlantPopup> {
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();
  String? _errorMessage;

  void _addPlant() {
    final plantName = _plantNameController.text.trim();
    final plantType = _plantTypeController.text.trim();

    if (plantName.isEmpty || plantType.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required!';
      });
      return;
    }

    widget.onAdd(plantName, plantType); // Továbbítjuk a nevet és típust
    Navigator.of(context).pop(); // Pop-up bezárása
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Plant'),
      content: Column(
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
            controller: _plantNameController,
            decoration: const InputDecoration(
              labelText: 'Plant Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _plantTypeController,
            decoration: const InputDecoration(
              labelText: 'Plant Type',
              border: OutlineInputBorder(),
            ),
          ),
        ],
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
