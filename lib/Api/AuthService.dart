import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AuthService{
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Registrasi
  Future<Map<String, dynamic>> register(String name, String email, String telepon, String password) async{
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'telepon': telepon,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    } else{
      throw Exception('Pastikan Email Dengan Benar!');
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async{
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else{
      throw Exception('Login Gagal');
    }
  }

  // Get Profil
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data Profil');
    }
  }

  // Edit Profil
  Future<Map<String, dynamic>> updateProfile(String token, Map<String, dynamic> updatedData, File? image) async {
  var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profile/update'));
  request.headers['Authorization'] = 'Bearer $token';

  // Tambahkan field formulir
  updatedData.forEach((key, value) {
    request.fields[key] = value.toString(); // Convert to string if necessary
  });

  // Tambahkan file gambar jika ada
  if (image != null) {
    var stream = http.ByteStream(image.openRead());
    stream.cast();
    var length = await image.length();

    // Tentukan MIME type
    var mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
    var mediaType = MediaType.parse(mimeType);

    var multipartFile = http.MultipartFile(
      'foto_profil',
      stream,
      length,
      filename: basename(image.path),
      contentType: mediaType, // Tentukan tipe MIME di sini
    );
    request.files.add(multipartFile);
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    return jsonDecode(responseData); // Kembalikan respons sebagai hasil
  } else {
    var responseData = await response.stream.bytesToString();
    throw Exception('Failed to update profile: $responseData');
  }
}

  // logout
  Future<void> logout(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/logout'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout.');
    }
  }

}