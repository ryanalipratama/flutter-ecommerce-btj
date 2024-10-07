import 'package:belajarflutter1/halaman/cart.dart';
import 'package:belajarflutter1/halaman/chat.dart';
import 'package:belajarflutter1/halaman/menu-utama.dart';
import 'package:belajarflutter1/halaman/profil.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:belajarflutter1/Models/AuthModel.dart';

class navigasi extends StatefulWidget {
  final int initialIndex;
  
  const navigasi({super.key, this.initialIndex = 0});

  @override
  State<navigasi> createState() => _HomePageState();
}

class _HomePageState extends State<navigasi> {
  int _selectedIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    final authModel = Provider.of<UserModel>(context, listen: false);
    // Pastikan userId tidak bernilai null sebelum menggunakannya
    final userId = authModel.userId ?? -1; // Berikan nilai default jika userId null
    _pages = <Widget>[
      MenuUtama(token: authModel.token),
      Cart(token: authModel.token),
      ChatPage(token: authModel.token, userId: userId),
      Profil(token: authModel.token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: 
      Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color.fromARGB(255, 143, 143, 143), // Warna border
              width: 1, // Ketebalan border
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), // Sudut bulat kiri atas
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,),
          child: GNav(
            backgroundColor: Colors.white,
            color: Color.fromARGB(255, 30, 94, 32),
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 30, 94, 32),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            gap: 8,
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.shopping_cart_checkout,
                text: 'Cart',
              ),
              GButton(
                icon: Icons.message,
                text: 'Chat',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
