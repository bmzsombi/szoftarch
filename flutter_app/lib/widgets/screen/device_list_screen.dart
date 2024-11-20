import 'package:flutter/material.dart';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/widgets/screen/add_new_device_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {

  final TextEditingController searchTextController = TextEditingController();

  List<Device> deviceList = [];
  List<Device> searchedDeviceList = [];
  bool shouldFetch = true;

  Future<List<Device>> fetchDeviceList() async {
    await Future.delayed(const Duration(seconds: 2));
    return getDeviceList();
  }

  void refreshPressed() {
    setState(() {
      shouldFetch = true;
    });
  }

  void addPressed() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const AddNewDeviceScreen()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.logout)
        ),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('Your devices'),
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
      body: FutureBuilder(
        future: shouldFetch ? fetchDeviceList() : null,
        builder: (context, snapshot) {
          if (shouldFetch) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            shouldFetch = false;
            if (snapshot.hasError) {
              return Center(child: ErrorText(errorText: snapshot.error.toString(), fontSize: 24.0));
            }
            if (snapshot.hasData) {
              deviceList = snapshot.data!;
              return DeviceListView(
                devices: deviceList,
                padding: 4.0,
                fontSize: 24.0,
              );
            }
            return const Center(child: Text("No devices available"));
          }
          else {
            return DeviceListView(
              devices: searchedDeviceList,
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
                            searchedDeviceList = searchDevices(searchTextController.text, deviceList);
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