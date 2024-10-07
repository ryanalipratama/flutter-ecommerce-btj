import 'package:belajarflutter1/Api/ApiService.dart';
import 'package:belajarflutter1/Models/banner.dart';
import 'package:belajarflutter1/Models/kategori.dart';
import 'package:belajarflutter1/Models/produk.dart';
import 'package:belajarflutter1/halaman/detail-produk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:belajarflutter1/Api/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:belajarflutter1/Models/AuthModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MenuUtama extends StatefulWidget {
  final String? token;
  MenuUtama({Key? key, this.token}) : super(key: key);

  @override
  _MenuUtamaState createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  final TextEditingController searchController = TextEditingController();
  final AuthService authService = AuthService();
  final Apiservice apiservice = Apiservice();
  late Map<String, dynamic> userData;
  List<BannerModel> _bannerModel = [];
  List<Kategori> _kategori = [];
  List<Produk> _produk = [];
  List<Produk> _filteredProduk = [];
  String? _selectedKategori;
  final TextEditingController namaLengkapController = TextEditingController();
  int _currentCarouselIndex = 0;
  String? profileImageUrl;
  String baseUrl = 'http://10.0.2.2:8000/'; 

  @override
  void initState() {
    super.initState();
    _getProfile();
    _fetchKategori();
    _fetchProduk();
    _fetchBannerModel();
  }

  Future<void> _getProfile() async {
    final authToken = Provider.of<UserModel>(context, listen: false).token;
    if (authToken == null) return;
    try {
      final result = await authService.getProfile(authToken);
      setState(() {
        userData = result['data'];
        namaLengkapController.text = userData['name'];
        profileImageUrl = userData['foto_profil'] != null ? baseUrl + userData['foto_profil'] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _fetchBannerModel() async {
    try {
      final bannerModel = await apiservice.fetchBannerModel();
      setState(() {
        _bannerModel = bannerModel;
      });
    } catch (e) {
      print('Gagal mengambil banner: $e');
    }
  }

  Future<void> _fetchKategori() async {
    try {
      final kategori = await apiservice.fetchKategori();
      setState(() {
        _kategori = kategori;
      });
    } catch (e) {
      print('Gagal mengambil kategori: $e');
    }
  }

  Future<void> _fetchProduk() async {
    try {
      final produk = await apiservice.fetchProduk();
      setState(() {
        _produk = produk;
        _filteredProduk = produk; // Awalnya tampilkan semua produk
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  void _filterProduk() {
    setState(() {
      if (_selectedKategori == null) {
        _filteredProduk = _produk;
      } else {
        _filteredProduk = _produk
            .where((produk) => produk.kategori_id.toString() == _selectedKategori)
            .toList();
      }
    });
  }

  void _searchProduk(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredProduk = _produk;
      } else {
        _filteredProduk = _produk.where((produk) {
          return produk.nama_produk.toLowerCase().contains(keyword.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bintang Tiga Jaya",
          style: TextStyle(
            color: Color.fromARGB(255, 30, 94, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 40,
                  ),
                  child: Text(
                    'Hello, ${namaLengkapController.text}!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 30, 94, 32),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    right: 40,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2), 
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(255, 30, 94, 32), 
                        width: 2, 
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _bannerModel.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      CarouselSlider(
                        items: _bannerModel.map((banner) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Image.network(
                              'http://10.0.2.2:8000/${banner.gambar_banner}',
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 150.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _bannerModel.map((banner) {
                          int index = _bannerModel.indexOf(banner);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselIndex == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Produk',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Color.fromARGB(255, 30, 94, 32))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Color.fromARGB(255, 30, 94, 32)), // Set border color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Color.fromARGB(255, 30, 94, 32)), // Set border color when enabled
                  ),
                ),
                onChanged: (value) {
                  _searchProduk(value);
                },
              ),
            ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedKategori = null;
                          _filterProduk();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedKategori == null 
                            ? Colors.white // Background color for selected button
                            : Color.fromARGB(255, 30, 94, 32), // Background color for unselected button
                        side: BorderSide(
                          color: Color.fromARGB(255, 30, 94, 32), // Border color for both states
                          width: 1.0, // Border width
                        ),
                      ),
                      child: Text(
                        "All",
                        style: TextStyle(
                          color: _selectedKategori == null 
                              ? Color.fromARGB(255, 30, 94, 32) // Text color for selected button
                              : Colors.white, // Text color for unselected button
                        ),
                      ),
                    ),
                  ),
                  ..._kategori.map((kategori) {
                    bool isSelected = _selectedKategori == kategori.id.toString();
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedKategori = kategori.id.toString();
                            _filterProduk();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected 
                              ? Colors.white // Background color for selected button
                              : Color.fromARGB(255, 30, 94, 32), // Background color for unselected button
                          side: BorderSide(
                            color: Color.fromARGB(255, 30, 94, 32), // Border color for both states
                            width: 1.0, // Border width
                          ),
                        ),
                        child: Text(
                          kategori.nama_kategori,
                          style: TextStyle(
                            color: isSelected 
                                ? Color.fromARGB(255, 30, 94, 32) // Text color for selected button
                                : Colors.white, // Text color for unselected button
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1, // Ubah nilai childAspectRatio untuk memperbesar gambar produk
                ),
                itemCount: _filteredProduk.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProduk(produk: _filteredProduk[index], token: widget.token!,),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.circular(10), // Atur nilai sesuai keinginan Anda
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _filteredProduk[index].gambar != null
                              ? Image.network(
                                  'http://10.0.2.2:8000/${_filteredProduk[index].gambar!}',
                                  height: 100, // Sesuaikan tinggi gambar
                                  width: double.infinity, // Mengatur lebar gambar sesuai dengan lebar kotak
                                  fit: BoxFit.cover, // Memastikan gambar menutupi seluruh area yang tersedia
                                )
                              : SizedBox(height: 100, width: double.infinity),
                          Padding(
                            padding: const EdgeInsets.all(8.0), // Tambahkan padding di sekitar teks
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Atur agar teks dimulai dari kiri
                              children: [
                                Text(
                                  _filteredProduk[index].nama_produk,
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 30, 94, 32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left, // Atur agar teks rata kiri
                                ),
                                SizedBox(height: 5), // Jarak antara nama produk dan harga
                                Text(
                                  'Rp ${_filteredProduk[index].harga}', // Tampilkan harga produk
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 30, 94, 32),
                                  ),
                                  textAlign: TextAlign.left, // Atur agar teks rata kiri
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
