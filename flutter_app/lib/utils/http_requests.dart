import 'dart:convert';
import 'package:flutter_app/utils/actuator.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_app/utils/device_utils.dart';
import 'package:flutter_app/utils/plant.dart';
import 'package:flutter_app/utils/chart_utils.dart';
import 'package:flutter_app/utils/sensor.dart';

const String backend_url = 'localhost:5000';
const String validator_url = 'localhost:5001';
const String instance_url = 'localhost:5002';
const String actuator_url = 'localhost:5003';
const String instance_path = 'api/instances';
const String allPlantsPath = 'plants/all';
const String validatorPath = 'api/validate';
const String devicesPath= 'device/all';
const String usersPath = 'api/users';
const String addPlantPath = 'plants/addType';
const String url = 'localhost:5000';
const String createAccountPath = 'users/addType';
const String loginPath = 'users/login';
const String deviceTypesPath = 'device/all';
const String deletePlantPath = 'plants/delete';
const String deviceInstancesPath = 'deviceInstance/all';

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

Future<String> loginRequest(String username_, String password_) async {
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
      return "user";
    }
    else if (decodedResponse["role"] == "manufacturer") { // manufacturer found
      return "manufacturer";
    }
    else {
      return "0";   // "role" attribute is incorrect
    }
  }
  else {
    return "-1"; // user/manufacturer not found
  }
}

Future<List<Sensor>> userGetSensorRequest(int? deviceid) async {
  var uri = Uri.http(url, 'deviceInstance/$deviceid/sensors');
  var response = await http.get(uri);
  if (response.statusCode == 200){
    List<dynamic> jsonresponse = jsonDecode(response.body);
    return jsonresponse.map((data) => Sensor.fromJson(data)).toList();
  }
  else {
    throw Exception('There are no sensors assigned');
  }
}

Future<List<Actuator>> userGetActuatorRequest(int? deviceid) async {
  var uri = Uri.http(url, 'deviceInstance/$deviceid/actuators');
  var response = await http.get(uri);
  if (response.statusCode == 200){
    List<dynamic> jsonresponse = jsonDecode(response.body);
    return jsonresponse.map((data) => Actuator.fromJson(data)).toList();
  }
  else {
    throw Exception('There are no actuators assigned');
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

Future<List<Plant>> userGetPlantsRequest(String? user) async {
  var uri = Uri.http(backend_url, 'users/$user/plantInstances');
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
  var uri = Uri.http(backend_url, 'plantInstances/$id');
  await http.delete(uri);
}

void userGetPlantDetailsRequest() {}
void userGetPlantSensorsRequest() async {
  var uri = Uri.http(backend_url, deviceInstancesPath);
  var response = await http.get(uri);
  
  
}
void userGetSensorDetailsRequest() async {}

Future<int> getDeviceIdByPlant(int plantid) async {
  var uri = Uri.http(url, 'plantInstances/$plantid/deviceInstance');
  var response = await http.get(uri);

  var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  return decodedResponse["id"];
  //int deviceid = jsonDecode(response.body);
}

void userAddPlantRequest(
  String scname, String cname, String cat, String maxl, String minl, String maxenvhum, 
  String minenvhum, String maxsom, String minsom, String maxtemp, String mintemp
  ) async {
  var uri = Uri.http(backend_url, addPlantPath);
  var response = await http.post(
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
void userAddSensorRequest() {

}

void createUserPlantInstanceRequest(String? username, int plantid, String nick) async {
  var uri = Uri.http(url, 'plantInstances/addType');
  var response = await http.post(
    uri,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "username": username,
      "plantId": plantid,
      "nickname": nick
    })
  );
}

Future<List<ChartData>> getSensorMeasurement(int? deviceInstanceId, int sensorId) async {
  var uri = Uri.http(url, 'deviceInstance/$deviceInstanceId/sensorsMeasurement5/$sensorId');
  var response = await http.get(uri,
    headers: {
      "Content-type": "application/json"
    }
  );
  if (response.statusCode == 200) {
    List<ChartData> data = convertToChartData(List<Map<String, dynamic>>.from(jsonDecode(response.body)));
    return data;
  } else {
    return [];
  }
}

Future<List<Plant>> userGetPlantTypesRequest() async {
  var uri = Uri.http(url, allPlantsPath);
  var response = await http.get(uri, headers: {
      "Content-Type": "application/json",
  });
  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Plant.fromJson(json)).toList();
  }
  else {
    return [];
  }
}


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

Future<int> createInstanceRequest(int plantid, int deviceId, String location, String? user, String name) async {
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
  print ("ASDASDASDASD");
  print(response.body);

  if (response.statusCode == 201) {
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var uri2 = Uri.http(url, 'plantInstances/addDevice');
    await http.post(uri2,
      headers: {
        "Content-type": "application/json"
      },
      body: jsonEncode({
        "plantInstanceId": plantid,
        "deviceInstanceId": decodedResponse["instance_id"]
      })
    );
    return 1;
  } else {
    return -1;
  }
}

Future<int> deleteInstanceRequest(int instanceId) async {
  var uri = Uri.http(instance_url, 'plantInstances/$instanceId');
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

Future<int?> getDeviceInstanceId(String apiUrl, int plantInstanceId) async {
  try {
    var uri = Uri.http(url, 'users/all');
    // Make the HTTP GET request
    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
    });
    //final response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the response body
      final List<dynamic> data = json.decode(response.body);

      // Search for the plantInstance with the given ID
      for (var user in data) {
        final plantInstances = user['plantInstances'] as List<dynamic>;
        for (var plantInstance in plantInstances) {
          if (plantInstance['id'] == plantInstanceId) {
            // Check if a deviceInstance is associated with the plantInstance
            final deviceInstance = plantInstance['deviceInstance'];
            print('ASDASDASDASDASDASDAS');
            print(deviceInstance['id']);
            return deviceInstance != null ? deviceInstance['id'] as int : null;
          }
        }
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
  return null; // Return null if no match is found or an error occurs
}

void deleteDeviceInstance(int? deviceInstanceId) async {
  var uri = Uri.http(instance_url, 'api/instances/$deviceInstanceId');
  var response = await http.delete(
      uri,
      headers: {
        "Content-Type": "application/json"
      }
  ); 
}

void turnOffActuatorRequest(int? deviceInstanceId, int actuatorId) async {
  var uri = Uri.http(actuator_url, 'api/instances/$deviceInstanceId/actuators/$actuatorId');
  var response = await http.put(
      uri,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "action": "off"
    }) 
  );
}

void turnOnActuatorRequest(int? deviceInstanceId, int actuatorId) async {
  var uri = Uri.http(actuator_url, 'api/instances/$deviceInstanceId/actuators/$actuatorId');
    var response = await http.put(
      uri,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "action": "on"
    }) 
  );
}

Future<bool?> getActuatorState(int? deviceInstanceId, int actuatorId) async {
  var uri = Uri.http(url, 'deviceInstance/$deviceInstanceId/actuatorStateHistory/$actuatorId');
  var response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (decodedResponse is List && decodedResponse.isNotEmpty) {
      var lastStateHistory = decodedResponse.last;
      if (lastStateHistory is Map && lastStateHistory.containsKey('state')) {
        return lastStateHistory['state'] as bool;
      }
    }
  }
  return null;
}

Future<List<PlantInstance>> userGetPlantInstancesRequest(String? username) async {
  var uri = Uri.http('localhost:5000', 'users/all');
  var response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    // Decode JSON response
    List<dynamic> users = json.decode(response.body);

    // Find the user with the matching username
    var user = users.firstWhere(
      (user) => user['username'] == username,
      orElse: () => null,
    );

    if (user != null) {
      // Extract plant instances for the user
      List<dynamic> plantInstancesJson = user['plantInstances'];
      return plantInstancesJson.map((json) => PlantInstance.fromJson(json)).toList();
    } else {
      // No matching user found
      return [];
    }
  } else {
    // Handle HTTP errors
    throw Exception('Failed to load users');
  }
}