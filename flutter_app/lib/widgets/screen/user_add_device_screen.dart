import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:flutter_app/utils/http_requests.dart';


class UserAddDeviceScreen extends StatefulWidget {
  const UserAddDeviceScreen({super.key});

  @override
  State<UserAddDeviceScreen> createState() => _UserAddDeviceScreenState();
}

class _UserAddDeviceScreenState extends State<UserAddDeviceScreen> {
  String errorText = '';
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController deviceLocationController = TextEditingController();

  List<DropdownDeviceItem> deviceList = [];
  bool shouldFetch = true;
  DropdownDeviceItem? selectedDevice;

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  void refreshPressed() {
    setState(() {
      shouldFetch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: shouldFetch ? userGetDeviceTypesRequest() : null,
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    const AppText(text: "Add device", fontSize: 32.0, textColor: Colors.black),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
                      child: TextField(
                        onChanged: (text) { setErrorText(''); },
                        controller: deviceNameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          hintText: "Enter device name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
                      child: TextField(
                        onChanged: (text) { setErrorText(''); },
                        controller: deviceLocationController,
                        decoration: const InputDecoration(
                          labelText: "Location",
                          hintText: "Enter device location",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                        ),
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<DropdownDeviceItem>(
                      value: selectedDevice,
                      hint: const Text('Select a Device'),
                      items: deviceList.map((device) {
                          return DropdownMenuItem<DropdownDeviceItem>(
                            value: device,
                            child: Text(device.toString()), // Customize display here
                          );
                        }).toList(),
                      onChanged: (DropdownDeviceItem? newValue) {
                        setState(() {
                          selectedDevice = newValue;
                        });
                      },
                    ),
                    const Spacer(),
                    AppButton(text: 'Add device', onPressed: () => {}, fontSize: 24.0, textColor: Colors.black, backgroundColor: Colors.white),
                    const Spacer()
                  ],
                ),
              );
            }
            return const Center(child: Text("No devices available"));
          }
          else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  const AppText(text: "Add device", fontSize: 32.0, textColor: Colors.black),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
                    child: TextField(
                      controller: deviceNameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "Enter device name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
                    child: TextField(
                      controller: deviceLocationController,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        hintText: "Enter device location",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<DropdownDeviceItem>(
                    value: selectedDevice,
                    hint: const Text('Select a Device'),
                    items: deviceList.map((device) {
                        return DropdownMenuItem<DropdownDeviceItem>(
                          value: device,
                          child: Text(device.toString()), // Customize display here
                        );
                      }).toList(),
                    onChanged: (DropdownDeviceItem? newValue) {
                      setState(() {
                        selectedDevice = newValue;
                      });
                    },
                  ),
                  const Spacer(),
                  AppButton(text: 'Add device', onPressed: () => {}, fontSize: 24.0, textColor: Colors.black, backgroundColor: Colors.white),
                  const Spacer()
                ],
              ),
            );
          }
        }
      ),
    );
  }
}