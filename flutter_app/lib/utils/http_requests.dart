import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/utils/device_utils.dart';

const String url = 'localhost:5000';
const String createAccountPath = 'users/addType';
const String loginPath = 'users/loginFull';
const String deviceTypesPath = 'device/all';

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

void manufacturerGetDevicesRequest() {}
void manufacturerAddDeviceRequest() {}
void manufacturerModifyDeviceRequest() {}

void userGetPlantsRequest() {}
void userGetPlantDetailsRequest() {}
void userGetPlantSensorsRequest() {}
void userGetSensorDetailsRequest() {}
void userAddPlantRequest() {}
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