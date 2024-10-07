import 'package:flutter/material.dart';

class MyButtonLogout extends StatelessWidget {
  final Function()? onTap;

  const MyButtonLogout({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 360,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 194, 23, 23),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Text(
          "Log out",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      )
    );
  }
}