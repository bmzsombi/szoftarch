import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common/custom_widgets.dart';
import 'package:flutter_app/utils/http_requests.dart';
import 'package:flutter_app/utils/toastutils.dart';

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
  final TextEditingController emailController = TextEditingController();

  void backButtonPressed() {
    Navigator.pop(context);
  }

  void createAccountButtonPressed() async {
    if (
      userNameController.text.trim().isNotEmpty &&
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty &&
      confirmPasswordController.text.trim().isNotEmpty &&
      passwordController.text.trim() == confirmPasswordController.text.trim()
    ) {
      String username_ = userNameController.text.trim();
      String email_ = userNameController.text.trim();
      String password_ = passwordController.text.trim();
      bool manufacturer_ = switchOn;
      int createResult = await createAccountRequest(username_, email_, password_, manufacturer_);

      if (createResult == 1) {
        ToastUtils toastUtils = ToastUtils(toastText: "Account created!", context: context);
        toastUtils.showToast();
        Navigator.pop(context);
      }
      else if (createResult == -1) {
        setErrorText("Account couldn't be created! Username already exists.");
      }
    }
    else if (userNameController.text.trim().isEmpty) {
      setErrorText("Username can't be empty!");
    }
    else if (emailController.text.trim().isEmpty) {
      setErrorText("Email address can't be empty!");
    }
    else if (passwordController.text.trim().isEmpty && confirmPasswordController.text.trim().isEmpty) {
      setErrorText("Password can't be empty!");
    }
    else if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      setErrorText("Passwords don't match!");
    }
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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email address",
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