import 'package:flutter/material.dart';

class LoginScreenText extends StatelessWidget {
  const LoginScreenText({
    super.key,
    required this.text,
    required this.fontSize
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.green,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
        wordSpacing: 2.0,
        fontStyle: FontStyle.normal,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
            blurRadius: 0.2
          )
        ]
      ),
    );
  }
}

class LoginScreenButton extends StatelessWidget {

  const LoginScreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.fontSize
  });

  final String text;
  final VoidCallback onPressed;
  final double fontSize;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.black,
            width: 1.0
          )
        )
      ),
      child: LoginScreenText(text: text, fontSize: fontSize),
    );
  }
}

class LoginScreenInputField extends StatelessWidget {
  const LoginScreenInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isPasswordField
  });

  final String labelText;
  final String hintText;
  final bool isPasswordField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 8.0),
      child: TextField(
        obscureText: isPasswordField,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          )
        ),
      ),
    );
  }
}