import 'package:flutter/material.dart';
import 'package:belajarflutter1/Models/cart.dart' as CartModel;
import 'package:belajarflutter1/Api/cartService.dart';
import 'package:belajarflutter1/Componen/button-checkout.dart';
import 'bottom-navigation.dart';

class Cart extends StatefulWidget {
  final String? token;

  const Cart({Key? key, this.token}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<CartModel.Cart>> _cartItems;
  late CartService _cartService;

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _cartItems = _fetchCartItems();
  }

  Future<List<CartModel.Cart>> _fetchCartItems() async {
    try {
      if (widget.token != null) {
        final List<CartModel.Cart> carts = await _cartService.fetchCart(widget.token!);
        return carts;
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      throw Exception('Failed to fetch cart items');
    }
  }

  void checkout() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => navigasi(initialIndex: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Produk Pilihan mu!",
          style: TextStyle(
              color: Color.fromARGB(255, 30, 94, 32),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CartModel.Cart>>(
        future: _cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Keranjang kosong'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.map((cartItem) {
                          final totalPrice = cartItem.produk.harga * cartItem.quantity; 
                          return Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: cartItem.isChecked,
                                  activeColor: Color.fromARGB(255, 30, 94, 32),
                                  onChanged: (newBool) {
                                    setState(() {
                                      cartItem.isChecked = newBool ?? false;
                                    });
                                  },
                                ),
                                Container(
                                  height: 90,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 30, 94, 32),
                                    ),
                                  ),
                                  child: cartItem.produk.gambar != null && cartItem.produk.gambar!.isNotEmpty
                                      ? Image.network('http://10.0.2.2:8000/${cartItem.produk.gambar}')
                                      : Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        cartItem.produk.nama_produk,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 30, 94, 32)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "Rp ${cartItem.produk.harga}",
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "Total: Rp $totalPrice", // Tampilkan total harga
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color.fromARGB(255, 30, 94, 32),
                                            child: Icon(
                                              size: 15,
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () async {
                                            try {
                                              await _cartService.addToCart(widget.token!, cartItem.produk_id, 1); // Tambahkan satu item baru ke keranjang
                                              // Ambil nilai terbaru dari server setelah menambahkan item ke keranjang
                                              var updatedCartItems = await _fetchCartItems();
                                              setState(() {
                                                // Perbarui nilai lokal dengan nilai yang diperbarui dari server
                                                _cartItems = Future.value(updatedCartItems);
                                              });
                                            } catch (e) {
                                              print('Failed to add item to cart: $e');
                                              // Handle error jika diperlukan
                                            }
                                          },
                                        ),
                                        Container(
                                          height: 20,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Color.fromARGB(255, 30, 94, 32))),
                                          child: Center(child: Text("${cartItem.quantity}")),
                                        ),
                                        IconButton(
                                          icon: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color.fromARGB(255, 194, 23, 23),
                                            child: Icon(
                                              size: 15,
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (cartItem.quantity > 1) {
                                              setState(() {
                                                cartItem.quantity--;
                                              });
                                              try {
                                                await _cartService.updateCartItemQuantity(cartItem.id, cartItem.quantity, widget.token!);
                                              } catch (e) {
                                                print('Failed to update item quantity: $e');
                                              }
                                            } else {
                                              try {
                                                // Hapus item dari database
                                                await _cartService.removeFromCart(widget.token!, cartItem.id);
                                                // Hapus item dari tampilan
                                                setState(() {
                                                  _cartItems = _cartItems.then((cartItems) => cartItems.where((item) => item.id != cartItem.id).toList());
                                                });
                                              } catch (e) {
                                                print('Failed to remove item from cart: $e');
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                MyButtonCheckoout(
                  onTap: checkout,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
