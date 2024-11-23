import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

const String url = '127.0.0.1:5000';
const String usersPath = 'api/users';
const String plantsPath = 'api/plants';

void createAccountRequest(String username_,  String password_, String email_, bool manufacturer_) async {
  var uri = Uri.http(url, usersPath);
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
void manufacturerAddDeviceRequest() {}
void manufacturerModifyDeviceRequest() {}

void userGetPlantsRequest() {}
void userGetPlantDetailsRequest() {}
void userGetPlantSensorsRequest() {}
void userGetSensorDetailsRequest() {}
void userAddPlantRequest() {}
void userAddSensorRequest() {}
