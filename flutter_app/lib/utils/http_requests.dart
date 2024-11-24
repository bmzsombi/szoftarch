import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:flutter_app/utils/plant.dart';

const String backend_url = 'localhost:5000';
const String validator_url = 'localhost:5001';
const String instance_url = 'localhost:5002';
const String instance_path = 'api/instances';
const String validatorPath = 'api/validate';
const String devicesPath= 'device/all';
const String usersPath = 'api/users';
const String plantsPath = 'plants/all';
const String addPlantPath = 'plants/addType';
const String url = 'localhost:5000';
const String createAccountPath = 'users/addType';
const String loginPath = 'users/loginFull';
const String deviceTypesPath = 'device/all';
const String deletePlantPath = 'plants/delete';

Future<int> createAccountRequest(String username_, String email_, String password_, bool manufacturer_) async {
  var uri = Uri.http(url, createAccountPath);
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
  if (response.statusCode == 201) {
    return 1;
  }
  else {
    return -1;
  }
}

Future<int> loginRequest(String username_, String password_) async {
  var uri = Uri.http(url, loginPath);
    var response = await http.post(
    uri,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "username": username_,
      "password": password_,
    })
  );

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse["role"] == "user") {   // user found
      return 1;
    }
    else if (decodedResponse["role"] == "manufacturer") { // manufacturer found
      return 2;
    }
    else {
      return 0;   // "role" attribute is incorrect
    }
  }
  else {
    return -1; // user/manufacturer not found
  }
}

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

void userDeletePlantRequest(int id) async {
  var uri = Uri.http(backend_url, '$deletePlantPath/$id');
  await http.delete(uri);
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
      "scientificName": scname,
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



Future<List<DropdownDeviceItem>> userGetDeviceTypesRequest() async{
  var uri = Uri.http(url, deviceTypesPath);
  var response = await http.get(uri, headers: {
      "Content-Type": "application/json",
  });
  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => DropdownDeviceItem.fromJson(json)).toList();
  }
  else {
    return [];
  }
}

Future<int> createInstanceRequest(int deviceId, String location, String user, String name) async {
  var uri = Uri.http(instance_url, instance_path);
  var response = await http.post(
    uri,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "device_id": deviceId,
      "location": location,
      "user": user,
      "name": name
    })
  );
  if (response.statusCode == 201) {
    return 1;
  } else {
    return -1;
  }
}

Future<int> deleteInstanceRequest(int instanceId) async {
  var uri = Uri.http(instance_url, '$instance_path/$instanceId');
  var response = await http.delete(
    uri,
    headers: {
      "Content-Type": "application/json"
    }
  );
  if (response.statusCode == 200) {
    return 1;
  } else {
    return -1;
  }
}