import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/better_custom_widgets.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/plant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserAddPlantInstanceScreen extends StatefulWidget {
  const UserAddPlantInstanceScreen({super.key});

  @override
  State<UserAddPlantInstanceScreen> createState() => _UserAddPlantInstanceScreenState();
}

class _UserAddPlantInstanceScreenState extends State<UserAddPlantInstanceScreen> {
  String errorText = '';
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController deviceLocationController = TextEditingController();

  List<Plant> deviceList = [];
  bool shouldFetch = true;
  Plant? selectedDevice;

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('username');
    return action;
  }


  void addDevicePressed() async {
    if (selectedDevice != null &&
        deviceNameController.text.trim().isNotEmpty
    )
    {
      createUserPlantInstanceRequest(await getUsername(), selectedDevice!.id, deviceNameController.text.trim());

      // if (result == 1) {
      //   ToastUtils toastUtils = ToastUtils(toastText: "Device added to plant.", context: context);
      //   toastUtils.showToast();
      // }

      // else if (result == -1) {
      //   setErrorText("Device couldn't be added!");
      // }

      Navigator.pop(context);
    }
    else if (selectedDevice == null) {
      setErrorText("Select a plant type!");
    }
    else if (deviceNameController.text.trim().isEmpty) {
      setErrorText("Plant name can't be empty!");
    }
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
        future: shouldFetch ? userGetPlantTypesRequest() : null,
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
                    const AppText(text: "Add plant", fontSize: 32.0, textColor: Colors.black),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
                      child: TextField(
                        onChanged: (text) { setErrorText(''); },
                        controller: deviceNameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          hintText: "Enter plant nickname",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                        ),
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<Plant>(
                      value: selectedDevice,
                      hint: const Text('Select a Plant'),
                      items: deviceList.map((device) {
                          return DropdownMenuItem<Plant>(
                            value: device,
                            child: Text(device.toString()), // Customize display here
                          );
                        }).toList(),
                      onChanged: (Plant? newValue) {
                        setState(() {
                          selectedDevice = newValue;
                        });
                      },
                    ),
                    const Spacer(),
                    AppButton(text: 'Add Plant', onPressed: () => {}, fontSize: 24.0, textColor: Colors.black, backgroundColor: Colors.white),
                    const Spacer()
                  ],
                ),
              );
            }
            return const Center(child: ErrorText(errorText: "No plants available"));
          }
          else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  const AppText(text: "Add plant", fontSize: 32.0, textColor: Colors.black),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
                    child: TextField(
                      controller: deviceNameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "Enter plant name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<Plant>(
                    value: selectedDevice,
                    hint: const Text('Select a Plant'),
                    items: deviceList.map((device) {
                        return DropdownMenuItem<Plant>(
                          value: device,
                          child: Text(device.toString()), // Customize display here
                        );
                      }).toList(),
                    onChanged: (Plant? newValue) {
                      setState(() {
                        selectedDevice = newValue;
                      });
                    },
                  ),
                  const Spacer(),
                  AppButton(text: 'Add plant', onPressed: addDevicePressed, fontSize: 24.0, textColor: Colors.black, backgroundColor: Colors.white),
                  const Spacer(),
                  ErrorText(errorText: errorText),
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