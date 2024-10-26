import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/widgets/screen/add_new_device_screen.dart';
import 'package:flutter_app/widgets/screen/modify_device_config_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            AppButton(text: 'Add device', onPressed: () => {
                                                                                                          Navigator.push(context, MaterialPageRoute(
                                                                                                            builder: (context) => const AddNewDeviceScreen(),
                                                                                                          ))
            }, fontSize: 32.0, textColor: Colors.cyan, backgroundColor: Colors.white),
            AppButton(text: 'Modify test device', onPressed: () => {
                                                                                                          Navigator.push(context, MaterialPageRoute(
                                                                                                            builder: (context) => const ModifyDeviceConfigScreen(deviceName: 'test device'),
                                                                                                          ))
            }, fontSize: 32.0, textColor: Colors.greenAccent, backgroundColor: Colors.white),
            const Spacer()
          ],
        ),
      ),
    );
  }
}