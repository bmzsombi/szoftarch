import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Az assets eléréséhez
import 'package:path_provider/path_provider.dart'; // Temp könyvtárhoz
import 'package:open_file/open_file.dart';

class AddNewDeviceScreen extends StatefulWidget {
  const AddNewDeviceScreen({super.key});

  @override
  State<AddNewDeviceScreen> createState() => _AddNewDeviceScreenState();
}

class _AddNewDeviceScreenState extends State<AddNewDeviceScreen> {
  final TextEditingController deviceNameController = TextEditingController();
  String errorText = '';
  File? configFile;
  String configFileName = '';

  void browseFilePressed() async {
    // Böngészés fájlhoz (implementáld a saját függvényedet)
  }

  void uploadDevicePressed(BuildContext context) async {
    // Feltöltési logika (meglévő logikád)
  }

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  Future<void> downloadLocalPdf() async {
    try {
      // Fájl betöltése az assets-ből
      final ByteData data = await rootBundle.load('assets/device-yaml-docs.pdf');
      
      // Temp könyvtár elérése
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/device-yaml-docs.pdf');

      // Fájl mentése a temp könyvtárba
      await tempFile.writeAsBytes(data.buffer.asUint8List());

      // Fájl megnyitása
      await OpenFile.open(tempFile.path);
    } catch (e) {
      setErrorText("Could not open the PDF file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const Text(
              'Add new device',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextField(
              onChanged: (text) {
                setErrorText('');
              },
              controller: deviceNameController,
              decoration: const InputDecoration(
                labelText: "Device name",
                hintText: "Enter the device name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            GestureDetector(
              onTap: downloadLocalPdf,
              child: const Text(
                "Formatting requirements",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                uploadDevicePressed(context);
              },
              child: const Text('Upload device'),
            ),
            const Spacer(),
            if (errorText.isNotEmpty)
              Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 16.0),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
