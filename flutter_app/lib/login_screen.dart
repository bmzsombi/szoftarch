import 'package:flutter/material.dart';
import 'package:flutter_app/login_widgets.dart';
import 'package:flutter_app/login_methods.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key, required this.appName});

  final String appName;

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
            const LoginScreenInputField(labelText: 'Username', hintText: 'Enter your username', isPasswordField: false),
            const LoginScreenInputField(labelText: 'Password', hintText: 'Enter your password', isPasswordField: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  const LoginScreenText(text: 'Manufacturer', fontSize: 24.0),
                  const Spacer(),
                  Switch(
                    value: false,
                    onChanged: (value) {
                    },
                  )
                ],
              ),
            ),
            const LoginScreenButton(text: 'Login', onPressed: loginButtonPressed, fontSize: 24.0),
            const Spacer(),
            const LoginScreenText(text: "Don't have an account yet?", fontSize: 18.0),
            const LoginScreenButton(text: 'Create account', onPressed: createAccountButtonPressed, fontSize: 24.0),
            const Spacer()
          ],
        ),
      ),
    );
  }
}