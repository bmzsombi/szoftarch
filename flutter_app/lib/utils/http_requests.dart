import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:flutter_app/utils/plant.dart';

const String backend_url = 'localhost:5000';
const String validator_url = 'localhost:5001';
const String validatorPath = 'api/validate';
const String devicesPath= 'device/all';
const String usersPath = 'api/users';
const String plantsPath = 'plants/all';
const String addPlantPath = 'plants/addType';

void createAccountRequest(String username_,  String password_, String email_, bool manufacturer_) async {
  var uri = Uri.http(backend_url, usersPath);
  await http.post(
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
}
void userLoginRequest() {}
void manufacturerLoginRequest() {}

Future<List<Device>> manufacturerGetDevicesRequest() async {
  var uri = Uri.http(backend_url, devicesPath);
  var response = await http.get(uri);
  if (response.statusCode == 200){
    List<dynamic> jsonresponse = jsonDecode(response.body);
    return jsonresponse.map((data) => Device.fromJson(data)).toList();
  }
  else {
    throw Exception('Failed to load devices');
  }
}

Future<Map<String, dynamic>> manufacturerAddDeviceRequest(File configFile) async {
  var uri = Uri.http(validator_url, validatorPath);
  var request = http.MultipartRequest('POST', uri);

  // Fájl hozzáadása
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    configFile.path,
  ));

  var streamedResponse = await request.send();

  var response = await http.Response.fromStream(streamedResponse);

  return jsonDecode(response.body);
}
void manufacturerModifyDeviceRequest() {}

Future<List<Plant>> userGetPlantsRequest() async {
  var uri = Uri.http(backend_url, plantsPath);
  var response = await http.get(uri);

  if (response.statusCode == 200){
    List<dynamic> jsonresponse = jsonDecode(response.body);
    return jsonresponse.map((data) => Plant.fromJson(data)).toList();
  }
  else {
    throw Exception('Failed to load devices');
  }
}
void userGetPlantDetailsRequest() {}
void userGetPlantSensorsRequest() {}
void userGetSensorDetailsRequest() async {}
void userAddPlantRequest(
  String scname, String cname, String cat, String maxl, String minl, String maxenvhum, 
  String minenvhum, String maxsom, String minsom, String maxtemp, String mintemp
  ) 
async {
  var uri = Uri.http(backend_url, addPlantPath);
  await http.post(
    uri,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "scientific_name": scname,
      "common_name": cname,
      "category": cat,
      "max_light": maxl,
      "min_light": minl,
      "max_env_humid": maxenvhum,
      "min_env_humid": minenvhum,
      "max_soil_moist": maxsom,
      "min_soil_moist": minsom,
      "max_temp": maxtemp,
      "min_temp": mintemp
    })
  );
}
void userAddSensorRequest() {}
