import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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

  void addPlant(){
    setState(() {
      plantList.add(
        SizedBox(
          width: plantButtonWidth,
          height: plantButtonHeight,
          child: ElevatedButton.icon(
            onPressed: () {
              // Add new plant action
            },
            icon: const Icon(Icons.add),
            label: const Text(" "),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50),
              maximumSize: const Size(300, 150),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        )
      );
      plantList.add(
        const SizedBox(
          width: 20,
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight*0.15<=150) {
      plantButtonHeight = 150;
    } else if (screenHeight*0.15 >= 250) {
      plantButtonHeight = 250;
    }
    else {
      plantButtonHeight = screenHeight * 0.15;
    }

    if (screenWidth*0.15<=150) {
      plantButtonWidth = 150;
    } else if (screenWidth*0.15 >= 250) {
      plantButtonWidth = 250;
    }
    else {
      plantButtonWidth = screenWidth * 0.15;
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('My Little Plants'),
            ),
            ListTile(
              title: const Text('My Plants'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Sensors'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
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
                          addPlant();
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
                Row(
                  children: plantList,
                )
              ]
            ),
          )
        )
      ),
    );
  }
}