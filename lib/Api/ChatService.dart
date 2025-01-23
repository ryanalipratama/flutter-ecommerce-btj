import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belajarflutter1/Models/chat.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class ChatService {
  final String baseUrl = 'http://10.0.2.2:8000/api';


  // Fungsi untuk mengambil pesan dari server
  Future<List<Chat>> fetchMessages(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-messages'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> messagesData = responseData['messages'];

        List<Chat> messages = messagesData.map((json) {
          return Chat.fromJson(json); // Chat.fromJson sudah menangani fileUrl
        }).toList();

        return messages;
      } else {
        throw Exception('Failed to load chat messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }


  // Fungsi untuk mengirim pesan ke server
  Future<void> sendMessage(String message, int senderId, int receiverId, String token, String? filePath) async {
    try {
      final uri = Uri.parse('$baseUrl/send-message/user');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        })
        ..fields['message'] = message
        ..fields['sender_id'] = senderId.toString()
        ..fields['receiver_id'] = receiverId.toString()
        ..fields['sender_type'] = 'user'
        ..fields['receiver_type'] = 'admin';

      // Jika file gambar ada, kita tambahkan ke request
      if (filePath != null) {
        var file = await http.MultipartFile.fromPath('file', filePath);
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
    }
  }

}