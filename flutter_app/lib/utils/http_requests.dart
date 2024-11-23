import 'dart:ffi';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return jsonDecode(response.body);
  }
}
void manufacturerModifyDeviceRequest() {}

void userGetPlantsRequest() {}
void userGetPlantDetailsRequest() {}
void userGetPlantSensorsRequest() {}
void userGetSensorDetailsRequest() {}
void userAddPlantRequest() {}
void userAddSensorRequest() {}
