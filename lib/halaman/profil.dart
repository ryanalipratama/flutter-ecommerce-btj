import 'package:belajarflutter1/Componen/button-logout.dart';
import 'package:belajarflutter1/halaman/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:belajarflutter1/Models/AuthModel.dart';
import 'package:belajarflutter1/Api/AuthService.dart';
import 'package:belajarflutter1/Componen/button-edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profil extends StatefulWidget {

  final String? token;
  Profil({Key? key, this.token}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  
  final AuthService authService = AuthService();
  late Map<String, dynamic> userData;
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final String hintText = "Enter text";
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? profileImageUrl;
  final String baseUrl = 'http://10.0.2.2:8000/';


  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() async {
    final authToken = Provider.of<UserModel>(context, listen: false).token;
    if (authToken == null) return;
    try {
      final result = await authService.getProfile(authToken);
      setState(() {
        userData = result['data'];
        namaLengkapController.text = userData['name'];
        emailController.text = userData['email'];
        teleponController.text = userData['telepon'];
        alamatController.text = userData['alamat'] ?? '';
        profileImageUrl = userData['foto_profil'] != null ? baseUrl + userData['foto_profil'] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _pickImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  

  void edit() async{
    final authToken = Provider.of<UserModel>(context, listen: false).token;
    if (authToken == null) return;

    final updatedData = {
      'name': namaLengkapController.text,
      'email': emailController.text,
      'telepon': teleponController.text,
      'alamat': alamatController.text,
    };

    try {
      final result = await authService.updateProfile(authToken, updatedData, _selectedImage);
      setState(() {
        userData = result['data'];
        _selectedImage = null;
        profileImageUrl = userData['foto_profil'] != null ? baseUrl + userData['foto_profil'] : null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perubahan Profil Berhasil Disimpan!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void logout() async {
  final authToken = Provider.of<UserModel>(context, listen: false).token;
  if (authToken == null) return;

    try {
      await authService.logout(authToken);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Logout!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "DATA AKUN",
          style: TextStyle(
            color: Color.fromARGB(255, 30, 94, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: 
            [
              
              const SizedBox(height: 15),
              // Foto Profil
              Container(
                width: 210, // slightly larger to include the border
                height: 210,
                padding: EdgeInsets.all(5), // space for the border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 30, 94, 32), // border color
                    width: 5.0, // border width
                  ),
                ),
                child: ClipOval(
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : (profileImageUrl != null
                          ? Image.network(
                              profileImageUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "asset/profil.jpg",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )),
                ),
              ),

              // Text Ganti Foto Profil
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(
                "Ganti Foto Profil",
                style: TextStyle(
                    color: Color.fromARGB(255, 30, 94, 32),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                ),
              ),

              const SizedBox(height: 10),

              // Text Field Nama Lengkap
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: namaLengkapController,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      fillColor: Colors.green.shade50,
                      filled: true,
                      hintText: 'Nama Lengkap'),
                ),
              ),

              const SizedBox(height: 10),

              // Text Field Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      fillColor: Colors.green.shade50,
                      filled: true,
                      hintText: 'Email'),
                ),
              ),

              const SizedBox(height: 10),

              // Text Field No Telepon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: teleponController,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      fillColor: Colors.green.shade50,
                      filled: true,
                      hintText: 'No Telepon'),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: alamatController,
                  obscureText: false,
                  maxLines: null,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      fillColor: Colors.green.shade50,
                      filled: true,
                      hintText: 'Masukan Alamat Anda'),
                ),
              ),

              MyButtonEdit(onTap: edit),

              MyButtonLogout(onTap: logout),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
