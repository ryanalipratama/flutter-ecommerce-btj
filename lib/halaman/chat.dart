import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belajarflutter1/Models/chat.dart';
import 'package:belajarflutter1/Api/ChatService.dart';
import 'dart:developer' as developer;

class ChatPage extends StatefulWidget {
  final String? token;
  final int userId; // Menyimpan ID pengguna yang login

  const ChatPage({Key? key, this.token, required this.userId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Chat> _messages = []; // Daftar pesan
  ChatService _chatService = ChatService();
  final ImagePicker _picker = ImagePicker();
  String? _fileUrl; // Menyimpan URL file yang dipilih

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fungsi untuk mengambil pesan dari server
  void _fetchMessages() async {
    try {
      List<Chat> messages = await _chatService.fetchMessages(widget.token!);
      setState(() {
        _messages = messages; // Menyimpan pesan
      });
      _scrollToBottom();
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      // Polling setiap 10 detik
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          _fetchMessages();
        }
      });
    }
  }

  // Fungsi untuk mengirim pesan baru
  void _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isNotEmpty) {
      try {
        await _chatService.sendMessage(message, widget.userId, 1, widget.token!, _fileUrl);
        setState(() {
          _messages.add(
            Chat(
              id: _messages.length + 1,
              messageId: message, // ID dummy
              sender_id: widget.userId,
              receiver_id: 1, // ID admin
              sender_type: 'user',
              receiver_type: 'admin',
              message: message,
              timestamp: DateTime.now(),
              fileUrl: _fileUrl, // Menyertakan URL file
            ),
          );
        });
        _textController.clear();
        _fileUrl = null; // Reset URL file setelah pengiriman
        _scrollToBottom();
      } catch (e) {
        developer.log('Error sending message: $e', name: 'ChatPage');
      }
    }
  }

  // Fungsi untuk mengatur scroll agar selalu di bawah
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Fungsi untuk memilih file dari galeri
  Future<void> _pickFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fileUrl = pickedFile.path; // Menyimpan URL file yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Sama Mimin Yuk!',
          style: TextStyle(
            color: Color.fromARGB(255, 30, 94, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                Chat message = _messages[index];
                bool isUserMessage = message.sender_type == 'user';
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Color.fromARGB(255, 30, 94, 32) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(
                              color: isUserMessage ? Colors.white : Colors.black,
                            ),
                          ),
                          // Cek jika ada file
                          if (message.fileUrl != null && message.fileUrl!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  print('File URL: ${message.fileUrl}');
                                },
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Image.network(
                                    message.fileUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: Color.fromARGB(255, 30, 94, 32),
                  ),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 30, 94, 32)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 30, 94, 32),
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
