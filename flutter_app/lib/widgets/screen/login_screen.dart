import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/screen/create_account_screen.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/widgets/screen/plant_list_screen.dart';
import 'package:flutter_app/widgets/screen/device_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  bool switchOn = false;
  String errorText = '';
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void saveLoginInfo(String username) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  void toggleSwitch(bool value) {
    setState(() {
      switchOn = value;
    });
  }

  void loginButtonPressed() async {
    if (userNameController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
      String username = userNameController.text.trim();
      String password = passwordController.text.trim();
      int loginResult = await loginRequest(username, password);
      switch (loginResult) {
        case 0:
        case 1: Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const PlantListScreen(),
                )); 
                saveLoginInfo(username);
                break;
        case 2: Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const DeviceListScreen(),
                ));
                saveLoginInfo(username);
                break;
        case -1: setErrorText('User not found!');
        default: setErrorText('default'); break;
      }
    }
    else if (userNameController.text.trim().isEmpty) {
      setErrorText("Username can't be empty!");
    }
    else if (passwordController.text.trim().isEmpty) {
      setErrorText("Password can't be empty!");
    }
  }

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  void createAccountButtonPressed() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const CreateAccountScreen(),
    ));

    setErrorText('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/app_logo.jpeg',
                scale: 5,
              ),
            ),
            const LoginScreenText(text: 'App name', fontSize: 32.0),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
              child: TextField(
                onChanged: (text) { setErrorText(''); },
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  hintText: "Enter your username",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
              child: TextField(
                onChanged: (text) { setErrorText(''); },
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  //LoginScreenText(text: 'Manufacturer', fontSize: 24.0),
                  Spacer(),
                  // Switch(
                  //   value: switchOn,
                  //   onChanged: (value) { toggleSwitch(value); setErrorText(''); },
                  // )
                ],
              ),
            ),
            LoginScreenButton(text: 'Login', onPressed: loginButtonPressed, fontSize: 24.0),
            const Spacer(),
            ErrorText(errorText: errorText, fontSize: 24.0),
            const Spacer(),
            const LoginScreenText(text: "Don't have an account yet?", fontSize: 18.0),
            LoginScreenButton(text: 'Create account', onPressed: createAccountButtonPressed, fontSize: 24.0),
            const Spacer()
          ],
        ),
      ),
    );
  }
}