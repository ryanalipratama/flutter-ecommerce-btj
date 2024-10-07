import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belajarflutter1/Models/chat.dart';
import 'package:belajarflutter1/Api/ChatService.dart';
import 'dart:developer' as developer; // Sesuaikan dengan path yang benar

class ChatPage extends StatefulWidget {
  final String? token;
  final int userId; // Tambahkan userId untuk menyimpan ID pengguna yang login

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
        _messages = messages.reversed.toList(); 
      });
      _scrollToBottom();
    } catch (e) {
      print('Error fetching messages: $e');
    }finally {
    // Lakukan polling lagi setelah 10 detik
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        _fetchMessages(); // Panggil fungsi untuk polling kembali
      }
    });
  }
  }

  // Fungsi untuk mengirim pesan baru
  void _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isNotEmpty) {
      try {
        await _chatService.sendMessage(message, widget.userId, 1, widget.token!); // Gunakan userId dari widget dan id admin adalah 1
        // Jika pesan terkirim berhasil, tambahkan ke daftar pesan
        setState(() {
          _messages.insert(
            0,
            Chat(
              id: _messages.length + 1, // ID dummy untuk sementara
              sender_id: widget.userId, 
              receiver_id: 1, // ID admin sebagai integer
              sender_type: 'App\\Models\\User', // Tipe sender user sesuai data
              receiver_type: 'App\\Models\\Admin', // Tipe receiver admin sesuai data
              message: message,
              timestamp: DateTime.now(),
            ),
          );
        });
        _textController.clear(); // Hapus teks dari TextField setelah mengirim
        _scrollToBottom();
      } catch (e) {
         developer.log('Error sending message: $e', name: 'ChatPage');
        // Handle error jika diperlukan
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
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
      // Tambahkan fungsionalitas untuk mengirim file di sini
      print('Picked file: ${pickedFile.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Sama Mimin Yuk!',
          style: TextStyle(
            color: Color.fromARGB(255, 30, 94, 32)
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // Untuk menampilkan pesan terbaru di bagian bawah
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                Chat message = _messages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Align(
                    alignment: message.sender_type == 'App\\Models\\Admin'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.sender_type == 'App\\Models\\Admin'
                            ? Colors.grey[300]
                            : Color.fromARGB(255, 30, 94, 32),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        message.message,
                        style: TextStyle(
                          color: message.sender_type == 'App\\Models\\Admin'
                              ? Colors.black
                              : Colors.white,
                        ),
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
                        borderSide: BorderSide(color: Colors.grey), // Warna border default
                        borderRadius: BorderRadius.circular(8.0), // Sudut border yang dibulatkan
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 30, 94, 32)), // Warna border saat aktif (dipencet)
                        borderRadius: BorderRadius.circular(20.0), // Sudut border yang dibulatkan
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 30, 94, 32), // Mengatur warna ikon menjadi hijau
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
