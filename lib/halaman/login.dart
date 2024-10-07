import 'package:belajarflutter1/Componen/button-login.dart';
import 'package:belajarflutter1/Componen/text-register.dart';
import 'package:belajarflutter1/halaman/bottom-navigation.dart';
import 'package:flutter/material.dart';
import 'package:belajarflutter1/Api/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:belajarflutter1/Models/AuthModel.dart';

class Login extends StatefulWidget {
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{

  final AuthService apiService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool obscureText = false;
  final String hintText = "Enter text";


  void login() async{
     try {
      final result = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      if (result['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Berhasil!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
        
        // Simpan Token ke dalam AuthModel
        final authModel = Provider.of<UserModel>(context, listen: false);
        authModel.setToken(result['token']);

        if (result['userId'] != null) {
        authModel.setUserId(result['userId']);
      } else {
        throw Exception('User ID not found in login response');
      }
        
        // Arahkan ke menu navigasi
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => navigasi()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Gagal'),
          backgroundColor: Color.fromARGB(255, 194, 23, 23),
          duration: Duration(seconds: 3),
        ),
      );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Gagal!'),
          backgroundColor: Color.fromARGB(255, 194, 23, 23),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void textregister(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(), 

      body: 
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: 
            [
              //Logo
              Image(
                image: AssetImage("asset/btj.png"), 
                width: 200,
                height: 200,
              ),

              //Text
              Text(
                "Selamat Datang Kembali !",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 30),

              // Text Field Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green) 
                    ),
                    fillColor: Colors.green.shade50,
                    filled: true,
                    hintText: 'Email'
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Text Field Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green) 
                    ),
                    fillColor: Colors.green.shade50,
                    filled: true,
                    hintText: 'Password'
                  ),
                ),
              ),

              // Button Login
              MyButtonLogin(
                onTap: login,
              ),

              // Text Belum Punya Akun
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Belum Punya Akun?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 5),

                    // Text Registrasi
                    MyTextLink(
                      onTap: textregister
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      )
    );
  }
}