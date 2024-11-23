import 'package:flutter/material.dart';
import '../popup/add_plantpopup.dart';
import '../../utils/plant.dart';
import '../popup/plantdetails_popup.dart';
import '../screen/device_list_screen.dart';
import '../screen/login_screen.dart';

class PlantListScreen extends StatelessWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Little Plants',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Little Plants'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> plantList = [];
  double screenWidth = 0;
  double screenHeight = 0;

  double plantButtonWidth = 150;
  double plantButtonHeight = 150;

  void showAddPlantPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPlantPopup(
        onAdd: (plantName, plantType) => addPlant(plantName, plantType),
      ),
    );
  }

  void _showPlantDetails(Plant plant) {
    showDialog(
      context: context,
      builder: (context) => PlantDetailsPopup(plant: plant, screenHeight: screenHeight, screenWidth: screenWidth),
    );
  }

  void addPlant(String plantName, String plantType) {
    setState(() {
      plantList.add(
        SizedBox(
          width: plantButtonWidth,
          height: plantButtonHeight,
          child: ElevatedButton(
            onPressed: () {
              // A növény részleteinek megjelenítése a gombra kattintva
              final plant = Plant(
                name: plantName,
                type: plantType,
                humidity: '60%',
                light: 'Medium',
                soilMoisture: 'High',
                pumpState: 'On',
                temperature: '22°C',
              );
              _showPlantDetails(plant);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              plantName,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      plantList.add(
        const SizedBox(
          width: 20,
        ),
      );
    });
  }

  void exitPressed(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const Loginscreen(),
    ));
  }

  void loadDeviceListScreen(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const DeviceListScreen(),
    ));
  }

  void loadPlantListScreen(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const PlantListScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    plantButtonHeight = screenHeight * 0.15;
    plantButtonWidth = screenWidth * 0.15;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
              child: Text('My Little Plants'),
            ),
            ListTile(
              title: const Text('My Plants'),
              onTap: () {
                // Update the state of the app.
                // ...
                //loadPlantListScreen();
              },
            ),
            ListTile(
              title: const Text('Sensors'),
              onTap: () {
                // Update the state of the app.
                // ...
                loadDeviceListScreen();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  //Navigator.pop(context); // Kilépés a képernyőről
                  exitPressed();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50), // Gomb szélesség kitöltése
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(52, 158, 158, 158), width: 2.0), // Szürke színű, 2 pixel vastag keret
            borderRadius: BorderRadius.circular(10.0), // Opcionális: kerekített sarkok
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [ 
                Row(
                  children: [
                    SizedBox(
                      width: plantButtonWidth,
                      height: plantButtonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showAddPlantPopup(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add new"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          maximumSize: const Size(300, 150),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
                const Divider(
                  color: Colors.grey, // Elválasztó vonal színe
                  thickness: 1.0, // Elválasztó vonal vastagsága
                  height: 32.0, // Térköz a vonal körül
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0, // Vízszintes távolság az elemek között
                      runSpacing: 10.0, // Függőleges távolság az elemek között
                      children: plantList,
                    ),
                  ),
                ),
              ]
            ),
          )
        )
      ),
    );
  }
}
