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

  late List<Device> deviceList;

  Future<List<Device>> fetchDeviceList() async {
    await Future.delayed(const Duration(seconds: 2));
    return getDeviceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your devices'),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchDeviceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: ErrorText(errorText: snapshot.error.toString(), fontSize: 24.0));
          }
          if (snapshot.hasData) {
            deviceList = snapshot.data!;
            return ListView.builder(
              itemCount: deviceList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DeviceButton(
                    deviceId: deviceList[index].id,
                    deviceName: deviceList[index].name,
                    fontSize: 24.0
                  ),
                );
              }
            );
          }
          return const Center(child: Text("No devices available"));
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AddNewDeviceScreen()
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}