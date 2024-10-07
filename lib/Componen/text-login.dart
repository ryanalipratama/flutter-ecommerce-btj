import 'package:belajarflutter1/halaman/login.dart';
import 'package:flutter/material.dart';

class MyTextLinkLogin extends StatelessWidget {
  final Function()? onTap;

  const MyTextLinkLogin({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => Login())
        );
      },
      child: Text(
        'Login Disini!',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
