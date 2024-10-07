import 'package:belajarflutter1/Componen/button-register.dart';
import 'package:belajarflutter1/Componen/text-login.dart';
import 'package:belajarflutter1/Api/AuthService.dart';
import 'package:belajarflutter1/halaman/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  
  final AuthService apiService = AuthService();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiPasswordController = TextEditingController();
  final bool obscureText = false;
  final String hintText = "Enter text";

  void register() async{
    if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password harus memiliki minimal 8 karakter'),
          backgroundColor: Color.fromARGB(255, 194, 23, 23),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    if (passwordController.text != konfirmasiPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Konfirmasi Password Dengan Benar!'),
          backgroundColor: Color.fromARGB(255, 194, 23, 23),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    try {
      final result = await apiService.register(
        namaLengkapController.text,
        emailController.text,
        teleponController.text,
        passwordController.text,
      );
      if (result['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil! Silahkan Login!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pastikan email yang anda masukkan benar!'),
          backgroundColor: Color.fromARGB(255, 194, 23, 23),
          duration: Duration(seconds: 3),
        ),
      );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pastikan email yang anda masukkan benar!'),
          backgroundColor: Color.fromARGB(255, 194, 23, 23),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void textlogin(){}

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
              // Logo
              Image(
                image: AssetImage("asset/btj.png"), 
                width: 200,
                height: 200,
              ),

              // Text
              Text(
                "Silahkan isi Form untuk Registrasi Akun!",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 30),
              
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Masukan Nama Lengkap Anda!*",
                  style: TextStyle(
                    color:
                     Color.fromARGB(255, 194, 23, 23),
                     fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),
              
              // Text Field Nama Lengkap
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: namaLengkapController,
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
                    hintText: 'Nama Lengkap'
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Masukan Nomer Telepon!*",
                  style: TextStyle(
                    color:
                     Color.fromARGB(255, 194, 23, 23),
                     fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),

              const SizedBox(height: 12),

              // Text Field No Telfon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: teleponController,
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
                    hintText: 'No Telepon'
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Masukan Email!*",
                  style: TextStyle(
                    color:
                     Color.fromARGB(255, 194, 23, 23),
                     fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),

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

              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Buat Password!*",
                  style: TextStyle(
                    color:
                     Color.fromARGB(255, 194, 23, 23),
                     fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),

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

              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Konfirmasi Password!*",
                  style: TextStyle(
                    color:
                     Color.fromARGB(255, 194, 23, 23),
                     fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),

              // Text Field Konfirmasi Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: konfirmasiPasswordController,
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
                    hintText: 'Konfirmasi Password'
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // Button Registrasi
              MyButtonRegister(
                onTap: register,
              ),

              // Text Sudah Punya Akun
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: 
                  [
                    Text(
                      "Sudah Punya Akun?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 5),

                  // Text Login
                    MyTextLinkLogin(
                      onTap: textlogin
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}