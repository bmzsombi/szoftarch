import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  bool switchOn = false;
  String errorText = '';
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void backButtonPressed() {
    Navigator.pop(context);
  }

  void createAccountButtonPressed() {
    setState(() {
      errorText = "Example error text";
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      switchOn = value;
    });
  }

  void setErrorText(String e) {
    setState(() {
      errorText = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 3.0),
              child: TextField(
                onChanged: (text) { setErrorText(''); },
                obscureText: true,
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm password",
                  hintText: "Enter your password again",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  const LoginScreenText(text: 'Manufacturer', fontSize: 24.0),
                  const Spacer(),
                  Switch(
                    value: switchOn,
                    onChanged: (value) { toggleSwitch(value); setErrorText(''); },
                  )
                ],
              ),
            ),
            const Spacer(),
            LoginScreenButton(text: 'Create account', onPressed: createAccountButtonPressed, fontSize: 24.0),
            const Spacer(),
            ErrorText(errorText: errorText, fontSize: 24.0),
            const Spacer()
          ],
        ),
      ),
    );
  }
}