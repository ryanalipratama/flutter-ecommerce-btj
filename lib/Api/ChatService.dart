import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belajarflutter1/Models/chat.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class ChatService {
  final String baseUrl = 'http://10.0.2.2:8000/api';


  Future<List<Chat>> fetchMessages(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-messages'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final List<dynamic> responseData = jsonDecode(response.body);
        List<Chat> messages = responseData.map((json) => Chat.fromJson(json)).toList();
        return messages;
      } else {
        throw Exception('Failed to load chat messages. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching messages: $e');
        print('Stack trace: $stackTrace');
      }
      throw Exception('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(String message, int senderId, int receiverId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-message/user'),
        body: jsonEncode({
          'message': message,
          'sender_id': senderId,
          'receiver_id': receiverId
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        print('Message sent successfully');
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
