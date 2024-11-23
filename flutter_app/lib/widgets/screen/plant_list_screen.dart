import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/plant_details.dart';
import '../popup/add_plantpopup.dart';
import '../../utils/plant.dart';
import '../screen/device_list_screen.dart';
import '../screen/login_screen.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/widgets/common/plant_list_widgets.dart';


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
  final TextEditingController searchTextController = TextEditingController();

  List<Plant> plantList = [];
  List<Plant> searchedPlantList = [];
  double screenWidth = 0;
  double screenHeight = 0;

  double plantButtonWidth = 150;
  double plantButtonHeight = 150;

  bool shouldFetch = true;

  void showAddPlantPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPlantPopup(
        onAdd: (plantScName, plantCName, plantCat, plantMaxL, plantMinL, plantMaxEnvHum, 
          plantMinEnvHum, plantMaxSoM, plantMinSoM, plantMaxTemp, plantMinTemp) => 
          userAddPlantRequest(plantScName, plantCName, plantCat, plantMaxL, plantMinL, plantMaxEnvHum, 
          plantMinEnvHum, plantMaxSoM, plantMinSoM, plantMaxTemp, plantMinTemp),
      ),
    );
  }

  void addPressed() {
    showAddPlantPopup(context);
  }

  Future<List<Plant>> fetchPlantList() async {
    await Future.delayed(const Duration(seconds: 2));
    return userGetPlantsRequest();
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

  void refreshPressed() {
    setState(() {
      shouldFetch = true;
    });
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
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('Your plants'),
          ),
        ),
        actions: [
          IconButton(
            onPressed: refreshPressed,
            icon: const Icon(Icons.refresh),
            iconSize: 32.0,
          ),
        ],
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
              onTap: () {},
            ),
            ListTile(
              title: const Text('Sensors'),
              onTap: () {
                loadDeviceListScreen();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
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
      body: 
            FutureBuilder(
              future: shouldFetch ? fetchPlantList() : null,
              builder:(context, snapshot) {
                if (shouldFetch) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  shouldFetch = false;
                  if (snapshot.hasError) {
                    return Center(child: ErrorText(errorText: snapshot.error.toString(), fontSize: 24.0));
                  }
                  if (snapshot.hasData) {
                    plantList = snapshot.data!;
                    return PlantListView(
                      devices: plantList,
                      padding: 4.0,
                      fontSize: 24.0,
                    );
                  }
                  return const Center(child: Text("No plants available"));
                }
                else {
                  return PlantListView(
                    devices: searchedPlantList,
                    padding: 4.0,
                    fontSize: 24.0,
                  );
                }
              }
            ),
      
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 65,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'searchHeroTag',
              child: const Icon(Icons.search),
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: TextField(
                      controller: searchTextController,
                      decoration: const InputDecoration(
                        hintText: 'Search device'
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Exit'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white
                        ),
                        onPressed: () {
                          setState(() {
                            searchedPlantList = searchPlants(searchTextController.text, plantList);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Search'),
                      )
                    ],
                  ); 
                });
              }
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: addPressed,
              heroTag: 'addHeroTag',
              child: const Icon(Icons.add)
            )
          )
        ],
      )
    );
  }
}
