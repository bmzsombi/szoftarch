import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

const String backend_url = 'localhost:5000';
const String validator_url = 'localhost:5001';
const String validatorPath = 'api/validate';
const String usersPath = 'api/users';
const String plantsPath = 'api/plants';

void createAccountRequest(String username_,  String password_, String email_, bool manufacturer_) async {
  var uri = Uri.http(backend_url, usersPath);
  var response = await http.post(
    uri,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "username": username_,
      "password": password_,
      "email": email_,
      "role": manufacturer_ ? "manufacturer" : "user"
    })
  );
  developer.log(response.statusCode.toString());
}
void userLoginRequest() {}
void manufacturerLoginRequest() {}

void manufacturerGetDevicesRequest() {}
void manufacturerAddDeviceRequest(File configFile) async {
  var uri = Uri.http(validator_url, validatorPath);
  // MultipartRequest létrehozása
  var request = http.MultipartRequest('POST', uri);

  // Fájl hozzáadása
  request.files.add(await http.MultipartFile.fromPath(
    'file', // Backend által várt kulcs
    configFile.path,
  ));

  // Kérés küldése
  var streamedResponse = await request.send();

  // Válasz feldolgozása
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    
  } else {

  }
  
}
void manufacturerModifyDeviceRequest() {}

void userGetPlantsRequest() {}
void userGetPlantDetailsRequest() {}
void userGetPlantSensorsRequest() {}
void userGetSensorDetailsRequest() {}
void userAddPlantRequest() {}
void userAddSensorRequest() {}
